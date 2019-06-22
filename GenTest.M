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
#							#
#  FPAccuracy -- accuracy testing of special functions  #
#							#
#		Gaston H. Gonnet (Aug 25, 2002)		#
#							#
#########################################################
interface(warnlevel=0);
kernelopts(gcfreq=10^7):
kernelopts(ASSERT=true):
readlib(lattice):

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



#########################
#  scalb(x,n)  x * B^n  #
#########################
scalb := (x,n) -> x * B^n:

#
#################################################################
#  Compute candidates which give results very close to 1/2 ulp  #
#################################################################
NastyCandidates := proc( F, arg )

if arg=0 then RETURN( {0} )
elif not type(arg,numeric) then
     t := evalf(arg);
     if not type(t,numeric) then RETURN( {} ) fi;
     RETURN( procname(t) ) fi;

candidates := NULL;
arg_man, arg_expo := man_expo(arg);
arg0 := arg_man * B^arg_expo;

val := evalf( F(arg0) );
val_man, val_expo := man_expo(val);

# construct the LLL lattice to find a val close to 1/2 ulp
for ifact from 2 to 10 do
    fact := 10^ifact;
    val1 := evalf( eval( diff(F(x),x), x=arg0 ));

    lat := [ [ frac(val / B^val_expo + 0.5) * fact, 0, fact ],
	     [ val1 * B^(arg_expo-val_expo) * fact, 1, 0 ],
	     [ fact, 0, 0 ]];
    rlat := lattice(lat);


    for z in lattice(lat) do
        if abs(z[3]) <> fact then next fi;
        a := (arg_man+signum(z[3])*round(z[2])) * B^arg_expo;
	if abs(numer(a)) >= B^(ML+1) then next fi;
        candidates := candidates, a;
        od:
    od:
{candidates}
end:


###############################################################
#  Compute the pair of FP numbers which bracket the argument  #
###############################################################
BracketPair := proc( F, arg )

if arg=0 then RETURN( {-DBL_MIN,DBL_MIN} )
elif not type(arg,numeric) then
     t := evalf(arg);
     if not type(t,numeric) then RETURN( {} ) fi;
     RETURN( procname(t) ) fi;

arg_man, arg_expo := man_expo(arg);
arg_man1 := Floor( arg / B^arg_expo );
arg_man2 := ceil( arg / B^arg_expo );
if arg_man1 = arg_man2 then arg_man1 := arg_man1-1;  arg_man2 := arg_man2+1 fi;
if abs(arg_man1) < B^ML then arg_man1 := arg_man1+(B-1)/B fi;
ASSERT( abs(arg_man1) <= B^(ML+1) and abs(arg_man2) <= B^(ML+1) );
{ arg_man1 * B^arg_expo, arg_man2 * B^arg_expo }
end:


#########################
#  auxiliary functions  #
#########################
RunSsys := proc( comm::{string,symbol} )
r := ssystem(comm);
if not type(r,list) or nops(r) <> 2 or r[1] <> 0 then
     printf( `command: %s, returned %a\n`, comm, r );
     ERROR(`ssystem command failed`)
     fi;
r[2]
end:

GetTimeStamp := proc()
r := RunSsys( `date "+%Y-%m-%d %k:%M:%S"` );
substring(r,1..length(r)-1)
end:

hostname := proc() option remember;
r := RunSsys( 'hostname' );
convert(substring(r,1..length(r)-1),name);
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




##################################################
#  Generate testing function on standard output  #
##################################################
GenerateTestFunction := proc( F::name, Lang::symbol, FLang::symbol,
    SpecialPts::set, Ranges::{range,set(range)}  )
global TrialsSize;

if Lang <> 'C' then ERROR(Language,Lang,`not implemented yet`) fi;
if not type(TrialsSize,posint) then TrialsSize := 200 fi;

candidates := {};

# Try random numbers for every given range
for z in Ranges do
    lo := evalf(op(1,z));  hi := evalf(op(2,z));
    if not type(lo,numeric) or not type(hi,numeric) or lo >= hi then
	ERROR(z,`is an invalid range for numerical testing`) fi;
    to ceil( TrialsSize / nops(Ranges) ) do
	t := traperror( NastyCandidates(F,U()*(hi-lo)+lo) );
	if t<>lasterror then candidates := candidates union t fi;
	od
    od;

# Try the given points and some of ours
points := SpecialPts union {0,1,2,sqrt(2),Pi,Pi/2,Pi/3,Pi/4,sqrt(Pi),ln(2)};

# try results which are powers of the base
for z in [1,B,B^2,B^3,1/B,1/B^2,1/B^3] do
    t := traperror( fsolve(F(x)=z,x) );
    if t<>lasterror and t<>NULL and type(t,numeric) then
	points := points union {t} fi
    od;

# try results which are zero
for i from -10 to 20 do
    t := traperror( fsolve( F(x)=0, x=3*i..3*(i+1) ) );
    if t<>lasterror and t<>NULL and type(t,numeric) then
	points := points union {t} fi
    od;

for z in points do
    t := traperror( BracketPair(F,z) );
    if t<>lasterror then candidates := candidates union t fi;
    t := traperror( NastyCandidates(F,z) );
    if t<>lasterror then candidates := candidates union t fi;
    od;

tot1 := 0:
for z in candidates do
    val := traperror(evalf(F(z)));
    if val=lasterror or
	not type(val,numeric) or
	z <> 0 and abs(z) < DBL_MIN or
	abs(z) > DBL_MAX or
	val <> 0 and abs(val) < DBL_MIN or
	abs(val) > DBL_MAX then
	tot1 := tot1+1;  candidates := candidates minus {z} fi
    od:


candidates := sort( [op(candidates)] );
N := nops(candidates);

printf(`/* This program was generated automatically by a program written\n`);
printf(`   by Gaston H. Gonnet on %s on %s.\n`, hostname(), GetTimeStamp() );
printf(`   Do not edit, rerun the original maple program.       */\n`);

printf(`#include "header.h"\n`);
printf(`#define DBL_MAX_EXP %d\n`, DBL_MAX_EXP );
printf(`#define N %d\n`, N );
printf(`#define F %s\n`, FLang );
printf(`#define Fs "%s"\n`, FLang );
if tot1 > 0 then printf(`  /* %d candidate values discarded */\n`, tot1 ) fi;
printf(`\n`);
printf(`struct input_point { double arg_m, val, eps;\n`);
printf(`\tint arg_e, val_e; } input_points[N] = {\n`);

for i to N do
    arg := candidates[i];
    arg_man, arg_expo := man_expo(arg);

    val := evalf( F(arg) );
    ASSERT( type(val,numeric) );
    val_man, val_expo := man_expo(val);
    eps := val / B^val_expo - val_man;

    printf( ` %d,%d,%.21f,%d,%d%s`, arg_man, val_man, eps,
	arg_expo, -val_expo, `if`( i=N, ` };\n`, `,\n` ) );
    od:

if assigned(Cmacro) then printf( `%s\n`, Cmacro ) fi;
printf(`#include "trailer.h"\n`);

end:

printlevel := 3:

