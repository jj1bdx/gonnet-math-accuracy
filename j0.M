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
nu := 0:
j0 := x -> BesselJ(nu,x):
beta := (s+nu/2-1/4)*Pi:
mu := 4*nu^2:
J0zeros := seq( fsolve( BesselJ(nu,x)=0, x=beta-(mu-1)/8/beta ), s=1..20 ):
GenerateTestFunction( j0, C, j0,
   { DBL_MIN, -DBL_MIN, DBL_MAX, J0zeros },
   { 0..1, 1..10, 10..62, 62..1/e, 1/e..DBL_MAX } );
