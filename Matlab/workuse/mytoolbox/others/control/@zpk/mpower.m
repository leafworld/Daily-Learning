function sysk = mpower(sys,k)
%MPOWER  Repeated product of LTI models.
%
%   MPOWER(SYS,K) is invoked by SYS^K where SYS is any 
%   LTI model with the same number of inputs and outputs, 
%   and K must be an integer.  The result is the LTI model
%     * if K>0, SYS * ... * SYS (K times) 
%     * if K<0, INV(SYS) * ... * INV(SYS) (K times)
%     * if K=0, the static gain EYE(SIZE(SYS)).
%
%   The syntax SYS^K is useful to specify transfer functions
%   in a pseudo-symbolic manner. For instance, you can specify
%             - (s+2) (s+3)
%      H(s) = ------------
%             s^2 + 2s + 2
%   by typing
%      s = tf('s')
%      H = -(s+2)*(s+3)/(s^2+2*s+2) .
%
%   See also TF, PLUS, MTIMES, LTIMODELS.

%   Author(s): P. Gahinet, 1-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 1998/03/31 16:58:18 $

error(nargchk(1,2,nargin))
sizes = size(sys.k);

% Error checking
if sizes(1)~=sizes(2),
   error('SYS must have the same number of inputs and outputs.')
elseif ~isa(k,'double') | ~isequal(size(k),[1 1]),
   error('Second argument K must be a scalar.')
elseif k~=round(k),
   error('Second argument K must be an integer.')
end

% Preprocessing
if k==0,
   % K=0 -> quick exit
   sysk = sys;
   sysk.z(:) = {zeros(0,1)};
   sysk.p(:) = {zeros(0,1)};
   sysk.k = repmat(eye(sizes(1)),[1 1 sizes(3:end)]);
   sysk.lti = mpower(sys.lti,k);
   return
elseif k<0,
   % Replace SYS by INV(SYS) and K by -K
   try
      sys = inv(sys);
   catch
      error(lasterr)
   end
   k = -k;
end

% Left with SYS^K with K>0.
sysk = sys;
if isequal(sizes,[1 1]) & isequal(sys.z{1},0) & isequal(sys.p{1},zeros(0,1)),
   % Detect and process the case SYS = s,z,... first (for speed)
   sysk.z{1} = zeros(k,1);
   sysk.k = (sys.k)^k;
   sysk.lti = mpower(sys.lti,k);
else
   % General case: perform K-1 products
   for j=1:k-1,
      sysk = mtimes(sysk,sys);
   end
end
