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



##############################################################
#  Hardware FP characteristics (typical results of enquire)  #
#   (this is for the target machine)			     #
#      http://www.cwi.nl/~steven/enquire.html		     #
##############################################################

# /*  float.h for target with IEEE 32/64 bit and Intel 386 style 80 bit
#   floating point formats */
#   /* Radix of exponent representation */
FLT_RADIX := 2:
#   /* Number of base-FLT_RADIX digits in the significand of a double */
DBL_MANT_DIG := 53:
#   /* Difference between 1.0 and the minimum double greater than 1.0 */
DBL_EPSILON := 2.2204460492503131e-16:
#   /* Minimum int x such that FLT_RADIX**(x-1) is a normalised double */
DBL_MIN_EXP := (-1021):
#   /* Minimum normalised double */
DBL_MIN := 2.2250738585072014e-308:
#   /* Maximum int x such that FLT_RADIX**(x-1) is a representable double */
DBL_MAX_EXP := 1024:
#   /* Maximum double */
DBL_MAX := 1.7976931348623157e+308:

###################################################################

B := FLT_RADIX:
ML := DBL_MANT_DIG-1:
DBL_MIN := B^round(ln(DBL_MIN)/ln(B)):
DBL_MAX := B^round(ln(DBL_MAX)/ln(B)) * (1-1/B^DBL_MANT_DIG):
