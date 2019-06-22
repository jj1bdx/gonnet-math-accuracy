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

pow2_x := x -> 2^x:
Cmacro := `#define pow2_x(x) pow(2.0,x)`:
lim1 := ln(DBL_MIN)/ln(2):
lim2 := ln(DBL_MAX)/ln(2):
GenerateTestFunction( pow2_x, C, pow2_x,
   { seq(i,i=-10..10), seq(ln(i)/ln(2),i=3..20), lim1, lim2 },
   { 0..1, -10..-9, 5..10, 300..500, lim1 ... lim1*0.99,
     lim2*0.99 ... lim2 } );
