function [MBNet, FullBN] = CVModelStructureLearnLU(data, cols, pheno, priorPrecision, ...
    folds, experimentname)
%[auc, numnodes, classacc] = CVModelLearn(data, cols, pheno, priorPrecision, folds, experimentname, verbose)
% Does crossvalidation of model building and testing on data.  Will build a
% different network for each fold of cross validation.  Provides a
% good test of various parameter settings if called with differen values of
% PRIORPRECISION.
%
% DEPRICATED
%
% INPUT:
% DATA: data array
% COLS: column names, a cell array of strings
% PHENO: a string representing the phenotype column to predict.  Is matched
%   against the COLS array
% PRIORPRECISION: a structure including the usual HybridBayesNets
%   parameters:
%       priorPrecision.nu; % prior sample size for prior variance estimate
%       priorPrecision.sigma2; % prior variance estimate
%       priorPrecision.alpha; % prior sample size for discrete nodes
%       priorPrecision.maxParents; % hard-limit on the number of parents
%           each node
% FOLDS: Number of folds in the cross-validation to perform.  Default = 5.
% EXPERIMENTNAME: string that will be used in fileoutput names.  Should
%   represent a valid filename
% VERBOSE: boolean.  If true, increases output.
%
% OUTPUT: 
% AUC: the final AUC of the exercise; aggregated over each fold and
%   combined for the testing set of each fold.
% NUMNODES: size of each fold, in number of variables. 
% CLASSAC: accuracy per class of the phenotype.
%
%
% Copyright Michael McGeachie, 2010.  MIT license. See cgbayesnets_license.txt.

if (nargin < 5)
    folds = 5;
end
if (nargin < 6)
    experimentname = 'bayesnet-CV';
end


% find pheno col; cound data
phencol = strmatch(pheno, cols, 'exact');
[ncases,ncols] = size(data);

% split data into N-fold CV sets:
r = ceil(rand(1,ncases) * folds);

auc = 0;
numnodes = zeros(1,folds);


cvPClass = [];
cvPredZs = [];
cvTrueClass = [];
% for each fold in teh cross-validation
for k = 1:folds
    cvdata = data(r ~= k,:);
    cvtest = data(r == k,:);

    % check values of discrete vars::
    d = IsDiscrete(data, 5);
    discvals = cell(size(d));
    for i = 1:length(cols)
        if (d(i))
            discvals{i} = num2cell(unique(data(:,i),'legacy'));
        else 
            discvals{i} = {};
        end
    end

    % learn a BN for this fold of data:
%     MBNet = LearnStructure(cvdata, cols, pheno, priorPrecision, [experimentname,'-fold',num2str(k)], verbose);
    [MBNet{k}, FullBN{k}, outstats] = LearnStructureLU(cvdata, cols, pheno, priorPrecision, [experimentname,'-fold',num2str(k)],verbose);
end
    
    
