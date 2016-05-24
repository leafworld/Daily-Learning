function varargout = margin(a,b,c,d)
%MARGIN  Gain and phase margins and crossover frequencies.
%
%   [Gm,Pm,Wcg,Wcp] = MARGIN(SYS) computes the gain margin Gm, the
%   phase margin Pm in degrees, and the associated frequencies 
%   Wcg and Wcp, for a SISO open-loop LTI model SYS (continuous or 
%   discrete).  The gain margin Gm is defined as 1/G where G is 
%   the gain at the -180 phase crossing.  The gain margin in dB 
%   is 20*log10(Gm).  By convention, Gm=1 (0 dB) and Pm=0 when 
%   the nominal closed loop is unstable.
%
%   [Gm,Pm,Wcg,Wcp] = MARGIN(MAG,PHASE,W) derives the gain and phase
%   margins from the Bode magnitude, phase, and frequency vectors 
%   MAG, PHASE, and W produced by BODE.  Interpolation is performed 
%   between the frequency points to estimate the values. 
%
%   For a S1-by...-by-Sp array SYS of LTI models, MARGIN returns 
%   arrays of size [S1 ... Sp] such that
%      [Gm(j1,...,jp),Pm(j1,...,jp)] = MARGIN(SYS(:,:,j1,...,jp)) .  
%
%   When invoked without left hand arguments, MARGIN(SYS) plots
%   the open-loop Bode plot with the gain and phase margins marked 
%   with a vertical line.  
%
%   See also BODE, LTIVIEW, LTIMODELS.

%Old help
%MARGIN Gain margin, phase margin, and crossover frequencies.
%   [Gm,Pm,Wcg,Wcp] = MARGIN(A,B,C,D) returns gain margin Gm,
%   phase margin Pm, and associated frequencies Wcg and Wcp, given
%   the continuous state-space system (A,B,C,D).
%
%   [Gm,Pm,Wcg,Wcp] = MARGIN(NUM,DEN) returns the gain and phase
%   margins for a system in s-domain transfer function form (NUM,DEN).
%
%   [Gm,Pm,Wcg,Wcp] = MARGIN(MAG,PHASE,W)  returns the gain and phase
%       margins given the Bode magnitude, phase, and frequency vectors 
%   MAG, PHASE, and W from a system.  In this case interpolation is 
%   performed between frequency points to find the values. This works
%   for both continuous and discrete systems.
%
%   When invoked without left hand arguments, MARGIN(A,B,C,D) plots
%   the Bode plot with the gain and phase margins marked with a 
%   vertical line. The gain margin, Gm, is defined as 1/G where G 
%   is the gain at the -180 phase frequency. 
%   20*log10(Gm) gives the gain margin in dB.  
%
%   See also, IMARGIN.

%   Note: if there is more than one crossover point, margin will
%   return the worst case gain and phase margins. 

%   Andrew Grace 12-5-91
%   Revised ACWG 6-21-92
%   Revised A.Potvin 6-1-94
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.10 $  $Date: 1999/01/05 12:08:52 $

ni = nargin;
no = nargout;
if ni==0,
   eval('exresp(''margin'')')
   return
end
error(nargchk(2,4,ni));

if no==0,
   switch ni
   case 2
      margin(tf(a,b));
   case 3
      a = squeeze(a);
      b = squeeze(b);
      if ndims(a)>2 | ndims(b)>2, 
         error('MAG and PHASE must come from a SISO system')
      end
      imargin(a(:),b(:),c(:));
   case 4
      margin(ss(a,b,c,d));
   end

else
   switch ni
   case 2
      [varargout{1:no}] = margin(tf(a,b));
   case 3
      a = squeeze(a);
      b = squeeze(b);
      if ndims(a)>2 | ndims(b)>2, 
         error('MAG and PHASE must come from a SISO system')
      end
      [varargout{1:no}] = imargin(a(:),b(:),c(:));
   case 4
      [varargout{1:no}] = margin(ss(a,b,c,d));
   end
end


% end margin
