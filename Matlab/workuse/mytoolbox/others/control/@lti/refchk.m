function indices = refchk(indices,sizes,L)
%REFCHK  Check and format indices for SUBSREF
%
%   IND = REFCHK(IND,SIZES,L) checks the SUBSREF indices IND
%   against the model SIZES and the I/O names/groups of its LTI
%   parent L, and turns all name-based references in IND into 
%   integer-valued subscripts.
%
%   See also SUBSREF.

%   Author(s): P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.4 $  $Date: 1998/08/25 19:10:11 $


% Check number of indices against number of dimensions
nind = length(indices);
nd = length(sizes); 
if nd>2 & nind==2,
   % SYS(*,*) for LTI arrays (no indices into the array). Interpret as I/O 
   % selection across the entire array:
   %    SYS(1,2,3,4)  <->  Array(3,4) , channel pair (1,2)
   %    SYS(1,2)      <->  Array (entire array), channel pair (1,2)
   indices = [indices repmat({':'},1,nd-2)];
   nind = nd;
end

% Turn name references into regular indices (first 2 dimensions only)
for j=1:2, 
   indices{j} = nameref(indices{j},L,j); 
end

% Make SIZES the same length as INDICES
%  * if NIND<ND (absolute reference into LTI array), fold the dimensions 
%    NIND through ND into a single dimension
%  * if NIND>ND, pad SIZES with unit sizes.
sizes = [sizes(1:min(nind-1,nd)) prod(sizes(nind:nd)) ones(1,nind-nd)];

% Check compatibility of indices with sizes
% RE: at this point, LENGTH(SIZES) = LENGTH(INDICES)
nci = find(~strcmp(indices,':'));  % locate non-colon indices
for j=nci,
   indj = indices{j};
   LogicalFlag = islogical(indj);
   if ~isa(indj,'numeric'), 
      error(sprintf('Subscript #%d cannot be processed.',j))
   elseif (LogicalFlag & length(indj)~=sizes(j))
      error(sprintf('Logical subscript #%d has wrong length.',j));
   elseif (~LogicalFlag & any(indj<=0 | indj>sizes(j)))
      error(sprintf('Subscript #%d is out of range.',j));
   end
end

