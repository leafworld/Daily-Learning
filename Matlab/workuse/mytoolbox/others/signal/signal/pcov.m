function varargout = pcov(varargin)
%PCOV   Power Spectrum estimate via Covariance method.
%   Pxx = PCOV(X,ORDER,NFFT) is the Power Spectral Density estimate,
%   Pxx(w), of signal vector X using the Covariance method.  ORDER is
%   the model order of the AR model equations. NFFT is the FFT length
%   which determines the frequency grid.  Pxx is length (NFFT/2+1) for
%   NFFT even, (NFFT+1)/2 for NFFT odd, and NFFT if X is complex.  NFFT
%   is optional; it defaults to 256.
%
%   [Pxx,W] = PCOV(X,ORDER,NFFT) returns a vector of frequencies, W,
%   in rads/sample, at which the PSD is estimated.   
%
%   PCOV with no output arguments plots the PSD in the next available
%   figure.  By default, PCOV will plot the PSD over the frequency 
%   interval [0,Pi] for a real signal vector X and over the frequency
%   interval [0,2*Pi] for a complex vector X.  To plot the PSD over the
%   interval [0,2*Pi] for a real X use:
%   PCOV(X,ORDER,NFFT,'whole').
%
%   [Pxx,F] = PCOV(X,ORDER,NFFT,Fs) or PCOV(X,ORDER,NFFT,Fs,'whole') 
%   return the PSD estimate and the vector of frequencies, F, in Hz, at
%   which the PSD is estimated.  If left empty, Fs defaults to 1 Hz. If no
%   output arguments are given and Fs is specified, the plot will be over
%   the frequency interval [0,Fs/2] for a real signal vector X and over 
%   the frequency interval [0,Fs] for a complex vector X.
%
%   PCOV(X,ORDER,NFFT,Fs,'whole','squared') will plot the PSD estimate 
%   directly instead of converting to decibels.
%
%   You can obtain a default parameter for NFFT and Fs by inserting an 
%   empty matrix [], e.g., PCOV(X,4,[],1000).
%
%   See also PMCOV, PYULEAR, PMTM, PMUSIC, PBURG, PWELCH, PEIG, ARCOV
%   and PRONY.

%   Author(s): R. Losada
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.16.1.2 $  $Date: 1999/01/22 03:42:32 $

error(nargchk(2,6,nargin))

method = 'arcov';
titlestring = 'Covariance PSD Estimate';
if nargout==0,
   pfreqz(method,titlestring,varargin{:});
else
   [varargout{1:nargout}] = pfreqz(method,titlestring,varargin{:});
end

% [EOF] pcov.m
