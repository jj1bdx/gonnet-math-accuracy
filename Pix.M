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

Pi_man, Pi_expo := man_expo( Pi ):
Pi_rat := scalb( Pi_man, Pi_expo ):
Pix := x -> Pi_rat*x:
Cmacro := sprintf( `#define Pix(x) (scalb(%d,%d)*x)`, Pi_man, Pi_expo ):
GenerateTestFunction( Pix, C, Pix, {DBL_MAX/Pi,DBL_MIN,-DBL_MAX/Pi,-DBL_MIN},
	{ -1..1,  -DBL_MAX/Pi..DBL_MAX/Pi } );
