function [k, pval] = LUoptPartialMatch(pval, oktypes, parametername, matlabfile)
%OPTPARTIALMATCH Helper function that looks for partial matches of string
% options in a list of inputs and returns the complete string for the
% selected option.
%
%   [K, PVAL] = OPTPARTIALMATCH(PVAL, OKTYPES, PNAME, MATLABFILE) given
%   an input string PVAL and a cell with possible matches OKTYPES, finds
%   the matching unambiguous string and returns K, the index of the match
%   and the complete string for the selected option. Function returns an
%   error in the case of an ambiguous match or an failed match. PNAME and
%   MATLABFILE are used to build the error ID.

% Copyright 2010-2012 The MathWorks, Inc.


k = find(strncmpi(pval, oktypes, numel(pval)));
if numel(k) == 1
    pval = oktypes{k};
    return
end

% Throw the respective exception
if isempty(k)
    switch numel(oktypes)
        case 1
            msg = getString(message('bioinfo:optPartialMatch:UnknownOption1',upper(parametername),oktypes{:}));
        case 2
            msg = getString(message('bioinfo:optPartialMatch:UnknownOption2',upper(parametername),oktypes{:}));
        case 3
            msg = getString(message('bioinfo:optPartialMatch:UnknownOption3',upper(parametername),oktypes{:}));
        case 4
            msg = getString(message('bioinfo:optPartialMatch:UnknownOption4',upper(parametername),oktypes{:}));
        case 5
            msg = getString(message('bioinfo:optPartialMatch:UnknownOption5',upper(parametername),oktypes{:}));
        case 6
            msg = getString(message('bioinfo:optPartialMatch:UnknownOption6',upper(parametername),oktypes{:}));
        case 7
            msg = getString(message('bioinfo:optPartialMatch:UnknownOption7',upper(parametername),oktypes{:}));
        case 8
            msg = getString(message('bioinfo:optPartialMatch:UnknownOption8',upper(parametername),oktypes{:}));
        case 9
            msg = getString(message('bioinfo:optPartialMatch:UnknownOption9',upper(parametername),oktypes{:}));
        otherwise
            msg = getString(message('bioinfo:optPartialMatch:UnknownOption0',upper(parametername)));
    end
    msgId = sprintf('bioinfo:%s:Unknown%s',matlabfile,parametername);
    x = MException(msgId,msg);
    x.throwAsCaller;
elseif length(k)>1
    switch numel(oktypes)
        case 1
            msg = getString(message('bioinfo:optPartialMatch:AmbiguousOption1',upper(parametername),oktypes{:}));
        case 2
            msg = getString(message('bioinfo:optPartialMatch:AmbiguousOption2',upper(parametername),oktypes{:}));
        case 3
            msg = getString(message('bioinfo:optPartialMatch:AmbiguousOption3',upper(parametername),oktypes{:}));
        case 4
            msg = getString(message('bioinfo:optPartialMatch:AmbiguousOption4',upper(parametername),oktypes{:}));
        case 5
            msg = getString(message('bioinfo:optPartialMatch:AmbiguousOption5',upper(parametername),oktypes{:}));
        case 6
            msg = getString(message('bioinfo:optPartialMatch:AmbiguousOption6',upper(parametername),oktypes{:}));
        case 7
            msg = getString(message('bioinfo:optPartialMatch:AmbiguousOption7',upper(parametername),oktypes{:}));
        case 8
            msg = getString(message('bioinfo:optPartialMatch:AmbiguousOption8',upper(parametername),oktypes{:}));
        case 9
            msg = getString(message('bioinfo:optPartialMatch:AmbiguousOption9',upper(parametername),oktypes{:}));
        otherwise
            msg = getString(message('bioinfo:optPartialMatch:AmbiguousOption0',upper(parametername)));
    end    
    msgId = sprintf('bioinfo:%s:Ambiguous%s',matlabfile,parametername);
    x = MException(msgId,msg);    
    x.throwAsCaller;
end

end % optPartialMatch method
