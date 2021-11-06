/* Copyright (C) Gaston H. Gonnet

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA. */

struct point { double arg, res, err1, err2; } points[N+1];

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#ifdef FORCE_FPU_DOUBLE
#include <fpu_control.h>
#endif

#define SHOW 20

int main( int argc, char *argv[] ) {
  struct point *by_err1[N], *by_err2[N], *q;
  struct input_point *p;
  double t, t1, t2;
  int i, tot1={0}, tot2={0}, tot3={0}, tot4={0}, tot5={0};

#ifdef FORCE_FPU_DOUBLE
#define FPU_CW  (_FPU_MASK_IM+_FPU_MASK_ZM+_FPU_MASK_OM+_FPU_MASK_UM+ \
	_FPU_MASK_PM+_FPU_MASK_DM+_FPU_DOUBLE+_FPU_RC_NEAREST)

  fpu_control_t cw = FPU_CW;
  _FPU_SETCW (cw);
#endif

  /* compute the results and store them in points structure */
  for( p=input_points, q=points; q-points<N; p++,q++ ) {
	q->arg = scalb(p->arg_m,p->arg_e);
	q->res = F( q->arg );
	}

  for( i=0; i<N; i++ ) by_err1[i] = by_err2[i] = points+i;

  /* do something silly to avoid loop merging optimization */
  q->res = points[N/2].res+points[N/3].res+points[N/4].res;

  /* Now compute the error directly, for the benefit of more precise hw */
  for( p=input_points, q=points; q-points<N; p++,q++ ) {
	if( p->val_e >= DBL_MAX_EXP-2 ) {
	    t1 = scalb(1.0,p->val_e/2);
	    t2 = scalb(1.0,p->val_e-p->val_e/2);
	    t = F(q->arg)*t1*t2 - p->val;
	    }
	else {
	    t1 = scalb(1.0,p->val_e);
	    t = F(q->arg)*t1 - p->val;
	    }
	t -= p->eps;
	q->err2 = fabs(t);
	t = scalb(q->res,p->val_e) - p->val;
	t -= p->eps;
	q->err1 = fabs(t);
	}

  /* Sort by errors in decreasing order */
#define KEY(x) (-(x)->err1)
  SORT(by_err1,0,N-1,q);
#undef KEY
#define KEY(x) (-(x)->err2)
  SORT(by_err2,0,N-1,q);

  /* count the number of differences in errors */
  for( q=points; q-points < N; q++ ) {
	if( q->err1 > q->err2 ) tot1++;
	else if( 2*q->err1 < q->err2 ) tot5++;
	else if( 1.1*q->err1 < q->err2 ) tot4++;
	else if( 1.01*q->err1 < q->err2 ) tot3++;
	else if( q->err1 < q->err2 ) tot2++;
	}

  printf( "result of %s is ", Fs );
  if( tot1==0 ) printf( "never more precise than double\n\n" );
  else printf( "more precise than double %d out of %d times\n\n", tot1, N );

  if( tot2+tot3+tot4+tot5 )
	printf( "%d errors <= 1%% worse in accum, %d <= 10%%,"
	    "%d <= 100%%, %d > 100%%\n\n", tot2, tot3, tot4, tot5 );

  for( i=N-1; i>=0 && by_err2[i]->err2 == 0; i-- );
  if( N-1-i > 0 )
	printf( "%d results were exact to double the precision\n\n", N-1-i );

  if( tot1 > 10 ) {
	printf( "%d largest ulp errors (from result in accumulator)\n", SHOW );
	for( i=0; i<SHOW; i++ )
	    printf( "   %.5f ulp for %s(%.18g) = %.18g)\n",
		by_err2[i]->err2, Fs, by_err2[i]->arg, by_err2[i]->res );
	printf( "\n" );
	}

  printf( "%d largest ulp errors (stored in a double)\n", SHOW );
  for( i=0; i<SHOW; i++ )
	printf( "   %.5f ulp for %s(%.18g) = %.18g)\n",
	    by_err1[i]->err1, Fs, by_err1[i]->arg, by_err1[i]->res );
  printf( "\n" );

  printf( "<tr><td align=left>" );
  printf( "<a href=%s.res>%s</a></td><td align=right>%d</td>",
	Fs, Fs, N );
  printf( "<td align=right>%.5f</td>", by_err1[0]->err1 );
  printf( "<td>%.18g</td><td>%.18g</td></tr>\n",
	by_err1[0]->arg, by_err1[0]->res );
  exit(0);
}
