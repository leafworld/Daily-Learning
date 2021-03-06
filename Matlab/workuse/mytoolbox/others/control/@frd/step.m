function [yout,t,x] = step(varargin)
%STEP  Step response of LTI models.
%
%   STEP(SYS) plots the step response of the LTI model SYS (created 
%   with either TF, ZPK, or SS).  For multi-input models, independent
%   step commands are applied to each input channel.  The time range 
%   and number of points are chosen automatically.
%
%   STEP(SYS,TFINAL) simulates the step response from t=0 to the 
%   final time t=TFINAL.  For discrete-time models with unspecified 
%   sampling time, TFINAL is interpreted as the number of samples.
%
%   STEP(SYS,T) uses the user-supplied time vector T for simulation. 
%   For discrete-time models, T should be of the form  Ti:Ts:Tf 
%   where Ts is the sample time.  For continuous-time models,
%   T should be of the form  Ti:dt:Tf  where dt will become the sample 
%   time for the discrete approximation to the continuous system.  The
%   step input is always assumed to start at t=0 (regardless of Ti).
%
%   STEP(SYS1,SYS2,...,T) plots the step response of multiple LTI
%   models SYS1,SYS2,... on a single plot.  The time vector T is 
%   optional.  You can also specify a color, line style, and marker 
%   for each system, as in 
%      step(sys1,'r',sys2,'y--',sys3,'gx').
%
%   When invoked with left-hand arguments,
%      [Y,T] = STEP(SYS)
%   returns the output response Y and the time vector T used for 
%   simulation.  No plot is drawn on the screen.  If SYS has NY
%   outputs and NU inputs, and LT=length(T), Y is an array of
%   size [LT NY NU] where Y(:,:,j) gives the step response of the 
%   j-th input channel.
%
%   For state-space models, 
%      [Y,T,X] = STEP(SYS) 
%   also returns the state trajectory X which is an LT-by-NX-by-NU
%   array if SYS has NX states.
%
%   See also IMPULSE, INITIAL, LSIM, LTIVIEW, LTIMODELS.

%   Author(s): S. Almy
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/04/14 21:40:44 $

error('STEP unsupported for FRD systems.  Remove FRDs from system list.');