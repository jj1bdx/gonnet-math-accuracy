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

GenerateTestFunction( tan, C, tan, { seq((i+1/2)*Pi,i=1..10), (32+1/2)*Pi,
  (256+1/2)*Pi, (2^10+1/2)*Pi, (2^52+1/2)*Pi, 2^300*Pi, 3/2, 11, 333/4,
  355/2, 103993/4, 52174, 208341/2, 312689/8, 833719/2, 573204, 4272943/16,
  5419351/2, 80143857/4, 165707065/2, 122925461, 411557987/64, 534483448,
  2549491779/4, 3083975227, 14885392687/8, 21053343141/2, 1783366216531/128,
  3587785776203/2, 2685575996367, 8958937768937/4, 139755218526789/2,
  214112296674652, 5706674932067741/4, 6134899525417045/2, DBL_MIN,
  seq(i*Pi,i=1..10), 32*Pi,
  256*Pi, 2^10*Pi, 2^52*Pi, 2^300*Pi, 355, 103993, 104348, 208341, 312689,
  833719, 1146408, 4272943, 5419351, 80143857, 165707065, 245850922,
  411557987, 1068966896, 2549491779, 6167950454, 14885392687, 21053343141,
  1783366216531, 3587785776203, 5371151992734, 8958937768937,
  139755218526789, 428224593349304 }, { -1..1, -10..-9, 5..10, 300..500,
  DBL_MAX/10..DBL_MAX } );
