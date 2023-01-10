function LUbioinfochecknargin(numArgs,low,name)
%BIOINFOCHECKNARGIN Validate number of input arguments
%
%   BIOINFOCHECKNARGIN(NUM,LOW,FUNCTIONNAME) throws an MException if the
%   number of input arguments NUM to function FUNCTIONNAME is less than the
%   minimum number of expected inputs LOW.
% 
%   Example
%      bioinfochecknargin(nargin, 3, mfilename)
%
%   See also MFILENAME, NARGCHK, NARGIN, NARGOUT, NARGOUTCHK.

%   Copyright 2007-2012  The MathWorks, Inc.

    
if numArgs < low
    msg = getString(message('bioinfo:bioinfochecknargin:NotEnoughInputs'));
    msgId = sprintf('bioinfo:%s:NotEnoughInputs',name);
    x = MException(msgId,msg);
    x.throwAsCaller;    
end
