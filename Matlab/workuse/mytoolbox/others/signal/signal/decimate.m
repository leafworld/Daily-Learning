function odata = decimate(idata,r,nfilt,option)
%DECIMATE Resample data at a lower rate after lowpass filtering.
%   Y = DECIMATE(X,R) resamples the sequence in vector X at 1/R times the 
%   original sample rate.  The resulting resampled vector Y is R times shorter,
%   LENGTH(Y) = LENGTH(X)/R.
%   DECIMATE filters the data with an eighth order Chebyshev type I lowpass 
%   filter with cutoff frequency .8*(Fs/2)/R, before resampling.
%   Y = DECIMATE(X,R,N) uses an N'th order Chebyshev filter.
%   Y = DECIMATE(X,R,'FIR') uses the 30 point FIR filter generated by 
%   FIR1(30,1/R) to filter the data.
%   Y = DECIMATE(X,R,N,'FIR') uses the N-point FIR filter.
%
%   Note: For large R, the Chebyshev filter design might be incorrect
%   due to numeric precision limitations.  In this case, DECIMATE will
%   use a lower filter order.  For better anti-aliasing performance, try 
%   breaking R up into its factors and calling DECIMATE several times.
%
%   See also INTERP, RESAMPLE.

%   Author(s): L. Shure, 6-4-87
%              L. Shure, 12-11-88, revised
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/06/03 14:42:24 $

%   References:
%    [1] "Programs for Digital Signal Processing", IEEE Press
%         John Wiley & Sons, 1979, Chap. 8.3.

if nargin < 2
   error('Not enough input arguments.')
end
if abs(r-fix(r)) > eps
   error('Resampling rate R must be a positive integer.')
end
if fix(r) == 1
	odata = idata;
	return
end
if r <= 0
	error('Resampling rate R must be a positive integer.')
end
fopt = 1;
if nargin == 2
	nfilt = 8;
else
	if isstr(nfilt)
		if nfilt(1) == 'f' | nfilt(1) == 'F'
			fopt = 0;
		elseif nfilt(1) == 'i' | nfilt(1) == 'I'
			fopt = 1;
		else
			error('Filter options are FIR and IIR.')
		end
		if nargin == 4
			nfilt = option;
		else
			nfilt = 8*fopt + 30*(1-fopt);
		end
	else
		if nargin == 4
			if option(1) == 'f' | option(1) == 'F'
				fopt = 0;
			elseif option(1) == 'i' | option(1) == 'I'
				fopt = 1;
			else
				error('Filter options are FIR and IIR.')
			end
		end
	end
end
if fopt == 1 & nfilt > 13
	disp('Warning: IIR filters above order 13 may be unreliable.')
end

nd = length(idata);
m = size(idata,1);
nout = ceil(nd/r);

if fopt == 0	% FIR filter
	b = fir1(nfilt,1/r);
% prepend sequence with mirror image of first points so that transients
% can be eliminated. then do same thing at right end of data sequence.
	nfilt = nfilt+1;
	itemp = 2*idata(1) - idata((nfilt+1):-1:2);
	[itemp,zi]=filter(b,1,itemp);
	[odata,zf] = filter(b,1,idata,zi);
	if m == 1	% row data
		itemp = zeros(1,2*nfilt);
	else	% column data
		itemp = zeros(2*nfilt,1);
	end
	itemp(:) = [2*idata(nd)-idata((nd-1):-1:(nd-2*nfilt))];
	itemp = filter(b,1,itemp,zf);
% finally, select only every r'th point from the interior of the lowpass
% filtered sequence
	gd = grpdelay(b,1,8);
	list = round(gd(1)+1.25):r:nd;
	odata = odata(list);
	lod = length(odata);
	nlen = nout - lod;
	nbeg = r - (nd - list(length(list)));
	if m == 1	% row data
		odata = [odata itemp(nbeg:r:nbeg+nlen*r-1)];
	else
		odata = [odata; itemp(nbeg:r:nbeg+nlen*r-1)];
	end
else	% IIR filter
	rip = .05;	% passband ripple in dB
	[b,a] = cheby1(nfilt, rip, .8/r);
	while (abs(filtmag_db(b,a,.8/r)+rip)>1e-6) 
		nfilt = nfilt - 1;
		if nfilt == 0
			break
		end
		[b,a] = cheby1(nfilt, rip, .8/r);
	end
	if nfilt == 0
error('Bad Chebyshev design, likely R is too big; try mult. decimation (R=R1*R2).')
	end
        
% be sure to filter in both directions to make sure the filtered data has zero phase
% make a data vector properly pre- and ap- pended to filter forwards and back
% so end effects can be obliterated.
	odata = filtfilt(b,a,idata);
	nbeg = r - (r*nout - nd);
	odata = odata(nbeg:r:nd);
end

function H = filtmag_db(b,a,f)
%FILTMAG_DB Find filter's magnitude response in decibels at given frequency.

nb = length(b);
na = length(a);
top = exp(-j*(0:nb-1)*pi*f)*b(:);
bot = exp(-j*(0:na-1)*pi*f)*a(:);

H = 20*log10(abs(top/bot));

