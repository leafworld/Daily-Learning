function sys = d2d(sys,Ts,Nd)
%D2D  Resample discrete LTI system.
%
%   SYS = D2D(SYS,TS) resamples the discrete-time LTI model SYS 
%   to produce an equivalent discrete system with sample time TS.
%
%   See also D2C, C2D, LTIMODELS.

%	Andrew C. W. Grace 2-20-91, P. Gahinet 8-28-96
%	Copyright (c) 1986-98 by The MathWorks, Inc.
%	$Revision: 1.1 $  $Date: 1998/08/26 16:42:31 $

error('D2D is not supported for FRD models.')



