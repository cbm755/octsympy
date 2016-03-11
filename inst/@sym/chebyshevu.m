%% Copyright (C) 2016, Abhinav Tripathi
%%
%% This file is part of OctSymPy.
%%
%% OctSymPy is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 3 of the License,
%% or (at your option) any later version.
%%
%% This software is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty
%% of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
%% the GNU General Public License for more details.
%%
%% You should have received a copy of the GNU General Public
%% License along with this software; see the file COPYING.
%% If not, see <http://www.gnu.org/licenses/>.

%% -*- texinfo -*-
%% @documentencoding UTF-8
%% @deftypefn  {Function File} {@var{s} =} chebyshevu (@var{x}, @var{n})
%% Find the chebyshev's seconf type nth polynomial in the variable x.
%%
%% Example:
%% @example
%% @group
%% >> syms x
%% >> g = chebyshevu(x, 1)
%%    @result{} g = 2x
%% >> g = chebyshevu(x, 2)
%%    @result{} g = 4x^2 - 1
%% @end group
%% @end example
%%
%% @seealso{chebyshevt}
%% @end deftypefn

%% Author: Abhinav Tripathi
%% Keywords: symbolic

function y = chebyshevu(x, n)
  cmd = { 'x, n = _ins'
          'return sp.chebyu(int(n),x),' };
 
 y = python_cmd (cmd, x, n);
end

%!shared x
%! syms x

%!test
%! poly0 = chebyshevu(x, 0);
%! assert(isequal(poly0, sym(1)))

%!test
%! poly1 = chebyshevu(x, 1);
%! assert(isequal(poly1, 2*x))

%!test
%! poly2 = chebyshevu(x, 2);
%! assert(isequal(poly2, 4*x*x - 1))
