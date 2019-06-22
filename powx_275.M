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

powx_275 := proc(x) x^(11/4) end:
Cmacro := `#define powx_275(x) pow(x,2.75)`:
lim1 := DBL_MIN^(1/2.75):
lim2 := DBL_MAX^(1/2.75):
GenerateTestFunction( powx_275, C, powx_275,
   { seq(B^(i/2.75), i=-10..10), lim1, lim2 },
   { 0..1, -10..-9, 5..10, 300..500, lim1 ... lim1*1.01,
     lim2*0.99 ... lim2 } );
