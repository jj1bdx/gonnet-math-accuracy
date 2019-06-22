# Copyright (C) Gaston H. Gonnet

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

# signgam has to be used after calling lgamma(x)
Cmacro :=
`double exp( double x ), lgamma( double x );
double Gamma( double x )
    { double t;  extern int signgam;
      t = exp(lgamma(x)); return(t*signgam); }`:
e := DBL_EPSILON:
lim1 := fsolve( lnGAMMA(x)=ln(DBL_MAX), x ):
GenerateTestFunction( GAMMA, C, Gamma,
   { seq(i,i=1..30), lim1, DBL_MIN, -DBL_MIN, 171.624376956302683,
	-3.13983059200000048 },
   { 0..1, 1..2, 2..lim1, -4..-1, -e..e,
     1-sqrt(e)..1+sqrt(e), 2-sqrt(e)..2+sqrt(e) } );
