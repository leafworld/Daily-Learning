function sys = feedback(sys1,sys2,varargin)
%FEEDBACK  Feedback connection of two LTI models. 
%
%   SYS = FEEDBACK(SYS1,SYS2) computes an LTI model SYS for
%   the closed-loop feedback system
%
%          u --->O---->[ SYS1 ]----+---> y
%                |                 |           y = SYS * u
%                +-----[ SYS2 ]<---+
%
%   Negative feedback is assumed and the resulting system SYS 
%   maps u to y.  To apply positive feedback, use the syntax
%   SYS = FEEDBACK(SYS1,SYS2,+1).
%
%   SYS = FEEDBACK(SYS1,SYS2,FEEDIN,FEEDOUT,SIGN) builds the more
%   general feedback interconnection:
%                      +--------+
%          v --------->|        |--------> z
%                      |  SYS1  |
%          u --->O---->|        |----+---> y
%                |     +--------+    |
%                |                   |
%                +-----[  SYS2  ]<---+
%
%   The vector FEEDIN contains indices into the input vector of SYS1
%   and specifies which inputs u are involved in the feedback loop.
%   Similarly, FEEDOUT specifies which outputs y of SYS1 are used for
%   feedback.  If SIGN=1 then positive feedback is used.  If SIGN=-1 
%   or SIGN is omitted, then negative feedback is used.  In all cases,
%   the resulting LTI model SYS has the same inputs and outputs as SYS1 
%   (with their order preserved).
%
%   If SYS1 and SYS2 are arrays of LTI models, FEEDBACK returns an LTI
%   array SYS of the same dimensions where 
%      SYS(:,:,k) = FEEDBACK(SYS1(:,:,k),SYS2(:,:,k)) .
%
%   See also LFT, PARALLEL, SERIES, CONNECT, LTIMODELS.

%   S. Almy, P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.3 $  $Date: 1998/08/25 22:08:25 $

ni = nargin;
error(nargchk(2,5,ni));
switch ni
case 2
   sign = -1;
case 3
   sign = varargin{1};
case 4
   sign = -1;   [indu,indy] = deal(varargin{:});
case 5
   [indu,indy,sign] = deal(varargin{:});
end

% Ensure both operands are FRD
if ~isa(sys1,'frd')
   if isa(sys1,'double') & ndims(sys1) < 3
      sys1 = repmat(sys1,[1 1 length(sys2.Frequency)]);
   end
   sys1 = frd(sys1,sys2.Frequency,'units',sys2.Units);
   sys.Frequency = sys2.Frequency;
   units = sys2.Units;
elseif ~isa(sys2,'frd')
   if isa(sys2,'double') & ndims(sys2) < 3
      sys2 = repmat(sys2,[1 1 length(sys1.Frequency)]);
   end
   sys2 = frd(sys2,sys1.Frequency,'units',sys1.Units);
   sys.Frequency = sys1.Frequency;
   units = sys1.Units;
else
   % Check frequency vectors
   try
      % give priority to rad/s if both FRD's
      [sys.Frequency,units] = ...
         freqcheck(sys1.Frequency,sys1.Units,sys2.Frequency,sys2.Units);
   catch
      error(lasterr);
   end
end

% Incorporate time delays
if hasdelay(sys1)
   sys1 = delay2z(sys1);
end
if hasdelay(sys2)
   sys2 = delay2z(sys2);
end

% Extract data
sizeResp = size(sys1.ResponseData);
sizeRespFB = size(sys2.ResponseData);
ny1 = sizeResp(1);
nu1 = sizeResp(2);
ny2 = sizeRespFB(1);
nu2 = sizeRespFB(2);

% LTI inheritance. Use try/catch to keep errors at top level
sys = sys1;
try
   sys.lti = feedback(sys1.lti,sys2.lti,[isstatic(sys1),isstatic(sys2)]);
catch
   error(lasterr)
end

% Determine indices for v/u and z/y
if ni<4,
   indu = 1:nu1;   
   indy = 1:ny1;
elseif min(size(indu))>1,
   error('Third input FEEDIN must be a row vector.');
elseif min(size(indy))>1,
   error('Fourth input FEEDOUT must be a row vector.');
end

% Dimension compatibility
if length(indu)~=ny2 | length(indy)~=nu2,
   error('I/O dimensions of SYS2 don''t match feedback channel widths in SYS1.');
elseif ~isequal(sizeResp(3:end),sizeRespFB(3:end)) & ...
   ~all(sizeResp(4:end)==1) & ~all(sizeRespFB(4:end)==1),
   error('Arrays SYS1 and SYS2 must have compatible dimensions.')
end
nsys = max(prod(sizeResp(4:end)),prod(sizeRespFB(4:end)));

% Compute response data of FEEDBACK(H,K) as
%    H + [H12 0;H22 0] * inv([sign*I -K;-H22 I]) * [0 0;H21 H22]
sys.ResponseData = sys1.ResponseData;
for k=1:nsys
   for j=1:length(sys.Frequency)      
      H = sys.ResponseData(:,:,j,min(k,end));
      K = sys2.ResponseData(:,:,j,min(k,end));
      
      % LU factorize and test for singularity (algebraic loop)
      [L,U,P] = lu([diag(sign*ones(1,ny2)) -K ; -H(indy,indu) eye(nu2)]);     
      if rcond(U) < 1e3*eps,
         error('Algebraic loop: feedback loop is non causal.')
      end
      
      % Compute freq. response
      tmp = U\(L\(P*[zeros(ny2,nu1) ; H(indy,:)]));
      sys.ResponseData(:,:,j,min(k,end)) = H + H(:,indu) * tmp(1:ny2,:);
   end
end

