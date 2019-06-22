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

e := DBL_EPSILON:
lim1 := fsolve( lnGAMMA(x)=DBL_MAX, x=DBL_MAX/ln(DBL_MAX) ):
logabsGAMMA := x -> ln(abs(GAMMA(x))):
GenerateTestFunction( logabsGAMMA, C, lgamma,
   { seq(i,i=1..30), lim1, DBL_MIN, -DBL_MIN, 171.624376956302683 },
   { 0..1, 1..2, 2..lim1, -4..-1, -e..e,
     1-sqrt(e)..1+sqrt(e), 2-sqrt(e)..2+sqrt(e) } );
