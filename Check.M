interface(quiet=true):
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

#########################################################
#                                                       #
#	Check a result					#
#                                                       #
#               Gaston H. Gonnet (Aug 26, 2002)         #
#                                                       #
#########################################################
interface(warnlevel=0);
kernelopts(gcfreq=10^7):
kernelopts(ASSERT=true):

U1e10 := rand(0..10^10-1):
U := proc() Float(U1e10(),-10) end:
Digits := 60:  # lattice needs a lot of precision
read "float.M";


###############################################
#  compute an fp representation of the input  #
#   arg = arg_man * B^arg_expo		      #
###############################################
man_expo := proc( arg ) option system, remember;
if not type(arg,numeric) then
     t := evalf(arg);
     if type(t,numeric) then RETURN( procname(t) )
     else ERROR(arg,`cannot be evaluated to numeric`) fi
elif arg=0 then 0,0
else arg_expo := Floor(ln(abs(arg))/ln(B)) - ML;
     arg_man := round( arg / B^arg_expo );
     if abs(arg_man) = B^(ML+1) then
	 arg_man := arg_man/B;  arg_expo := arg_expo + 1 fi;
     ASSERT( abs(arg_man) >= B^ML and abs(arg_man) < B^(ML+1) );
     arg_man, arg_expo
     fi
end:


###################################
#  Fix a bug/deficiency in floor  #
###################################
Floor := proc( x )
r := floor(x);
if type(r,integer) then RETURN(r) fi;
r := evalf(x,max(Digits,60));
if type(r,numeric) then RETURN( floor(r) ) fi;
lprint( `floor failed with`,x,r);
ASSERT(false);
end:


PrintFull := proc( tit::string, val::numeric )
val_man, val_expo := man_expo(val);
printf( "%s:\n%.18g ~ scalb(%d,%d) = %.18g\n", tit, val, val_man, val_expo,
	val_man*B^val_expo )
end:


##########################################################################
#  Check - compute the function at the hw precision numbers and compare  #
##########################################################################
Check := proc( f::symbol, arg::numeric, val::numeric )
arg_man, arg_expo := man_expo(arg);
arg0 := arg_man * B^arg_expo;
PrintFull("argument",arg);

val_man, val_expo := man_expo(val);
val0 := val_man * B^val_expo;
PrintFull("computed value",val);

v := evalf( f(arg0) );
PrintFull("exact value",v);
err := v-val0;

v_man, v_expo := man_expo(v);
ulp := abs(err) / B^v_expo;
printf( "error = %.5g, %.5f ulps\n", err, ulp );

barg := fsolve(f(x)=val,x=arg);
PrintFull("backward error analysis",barg);
end:
C := %:

Gamma := GAMMA:
INV := x -> 1/x:
Pix := x -> Pi*x:
acos := arccos:
acosh := arccosh:
asin := arcsin:
asinh := arcsinh:
atan := arctan:
atanh := arctanh:
j0 := x -> BesselJ(0,x):
j1 := x -> BesselJ(1,x):
lgamma := x -> ln(abs(GAMMA(x))):
log10 := x -> ln(x)/ln(10):
pow2_x := x -> 2^x:
powx_275 := x -> x^2.75:
y0 := x -> BesselY(0,x):
y1 := x -> BesselY(1,x):
interface(quiet=false):
#
#	Usage:  C( <functname>, argument, value )
#
#	prints the argument, value, exact value, error and exact
#	  argument that evaluates to value (backward error)
#	  together with their floating point representation (and
#	  value of this representation)
#
