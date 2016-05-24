function sys = reshape(sys,varargin)
%RESHAPE  Reshape array of LTI models
%
%   SYS = RESHAPE(SYS,S1,S2,...,Sk) reshapes the LTI array SYS
%   into a S1-by-S2-by...-Sk array of LTI models.  There must
%   be S1*S2*...*Sk models to begin with.
% 
%   SYS = RESHAPE(SYS,[S1 S2 ... Sk]) is the same thing.
%
%   See also SIZE, NDIMS, LTIMODELS.

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/02/12 19:55:57 $

ni = nargin;
if ni<2,
   error('Not enough inputs.')
elseif ni==2,
   newdims = varargin{1};
else
   newdims = [varargin{:}];
end

% Perform RESHAPE operation
sizes = size(sys.num);

if prod(newdims)~=prod(sizes(3:end)),
   error('In RESHAPE operations, the number of LTI models must not change.')
else
   newdims = [sizes(1:2) newdims];
   sys.num = reshape(sys.num,newdims);
   sys.den = reshape(sys.den,newdims);
end

