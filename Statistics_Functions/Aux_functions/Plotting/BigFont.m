function h=BigFont(sz)
% FORMAT [h] = BigFont([sz],...)
% Makes fonts on current plot big
%
% [sz]  Width of line.  By default 18.
% 
%
%________________________________________________________________________
% %W% %E%

if (nargin<1)
  sz = 20;
end

g = get(gcf,'Children');
try,
set(g,'FontSize',sz)
end

if (nargout>0)
  h=g;
end
