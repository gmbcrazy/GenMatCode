function [index] = selectindex2(spreadsheetfile, sheetnumber, headers, processeddatadir, rewritefileinfo, cortex, fad, sizeindex, varargin)
% [index] = selectindex(spreadsheetfile, sheetnumber, headers, varargin)
%
%selects indices of files that correspond to selected values in columns of
%spreadsheet.  All options must be satified for each file for the file to be included If no input
%options selected, all indices will be reported.
%
% INPUTS
%   spreadsheetfile:    filename including location, eg
%   sheetnumber:        sheet in spreadsheet file to read in
%   headers:            names of headers for each column.  WIll be determined
%                       automatically if left blank, but if using a Mac or do not have Excel must be specified.
%                       eg '' or {'animal',	'date',	'cell',	'file'}
%   processeddatadir:   directory where processed data is saved, eg
%                       '/Users/asinger/Desktop/AwakeAutopatchData/', to save fileinfo
%   rewritefileinfo:    default 0.  if 1, rewrite fileinfo##.mat even if it
%                       exists.  if file does not exist it will be written
%   cortex:             1 for cortex recordings, 0 for hpc
%   sizeindex:          how many of first few columns are index, eg 3 or 4
%   fad:                1 if fad analysis
%
% SPREADSHEET FORMAT
%   first 4 columns are indices: [animal# YYMMDD cell# file#]
%   first row is value name
%   second row is description of value
%
% INPUT Options
%   name of each column in spreadsheet, must match column name exactly
%   'headername', 'equation', eg 'min Ra', '< 40'
%   for column that is being used to select data, blank rows will be
%   excluded
%
% OUTPUT
%   [animal# YYMMDD cell# file#] or [animal# YYMMDD file#] for fad

%read in the spreadsheet
[data, text, rawData]=xlsread(spreadsheetfile,sheetnumber);

if isempty(headers) & ~isempty(text)
    headers = rawData(1,:);
elseif isempty(headers) & isempty(text)
    error('you must specify headers because they cannot be read from file')
end

data = rawData(3:end,:);

%find repeated indices and deal asssign them separate file numbers if have
%different start and end times
allindex = cell2mat(data(:,1:sizeindex));
tempind = unique(allindex,'rows');
repeatind = [];
if size(tempind,1) < size(allindex,1) %if there are repeats in the indices
    for i = 1:size(tempind,1)
        numrepeats = sum(ismember(allindex, tempind(i,:), 'rows'));
        if numrepeats > 1 % if more than one row with this index
            repeatind = [repeatind; tempind(i,:)];
            %set subsequent indices file numbers to 1000+filenumber or 2000+
            %filenumebr etc
            rindices = find(ismember(allindex, tempind(i,:), 'rows')); %find rows of all indices of the repeated index
            for j = 2:numrepeats
                origfilenum = allindex(rindices(j),sizeindex);
                allindex(rindices(j),sizeindex) =  origfilenum+(1000*(j-1));
                data{rindices(j),sizeindex} = origfilenum+(1000*(j-1));
            end
        end
    end
end


%--------find indices that match options---------------
if ~isempty(varargin) %if options are specified
    
    goodrows = zeros(size(data,1), length(varargin)/2); %will indicate which files to include
    col = 1; %column of goodrows
    for option = 1:2:length(varargin)-1 %for each option
        currentoption =  varargin{option};
        optioneqn = varargin{option+1};
        %find column number to match input options
        [tf loc] = ismember(currentoption, headers);
        if tf == 1
            try
                optiondata = cell2mat(data(:, loc)); %relevant data for this option, eg select column of data matrix
                goodrows(:,col) = eval(['optiondata', optioneqn]); %find rows that meet requirements
            catch
                optiondata = data(:, loc); %relevant data for this option, eg select column of data matrix
                for r = 1:size(optiondata,1)
                    goodrows(r,col) = all(eval(['optiondata{r}', optioneqn])); %find rows that meet requirements %only include if all options satisfied
                end
            end
            col = col+1;
        elseif tf == 0
            error([currentoption ' does not correspond to a header'])
        end
    end
    inclrows = all(goodrows,2); %only include if all options satisfied
    index = cell2mat(data(inclrows,[1:sizeindex]));
    
else isempty(varargin) % if no options specified, select all data indices
    index = cell2mat(data(:,[1:sizeindex]));
end


%---------create fileinfo structure------------

%get info for each index
for r = 1:size(data,1)
    if cortex == 0 && fad == 0
        anprocesseddatadir = [processeddatadir, 'hp',num2str(data{r,1}), '_', num2str(data{r,2}) , '/cell',num2str(data{r,3}) '/'];
    elseif cortex == 1 && fad == 0
        anprocesseddatadir = [processeddatadir, 'ct',num2str(data{r,1}), '_', num2str(data{r,2}) , '/cell',num2str(data{r,3}) '/'];
    elseif fad == 1
        anprocesseddatadir = [processeddatadir, 't',num2str(data{r,1}), '_', num2str(data{r,2}) , '/'];
    end
    if ~exist(anprocesseddatadir,'dir')
        mkdir(anprocesseddatadir)
    end
    if ~exist([anprocesseddatadir,'fileinfo', num2str(data{r,sizeindex}),'.mat'], 'file') || rewritefileinfo == 1
        fileinfo = [];
        for h = 1:size(headers,2) %also refers to column number)
            spaces = [];
            
            value = data{r,h};
            %makes spaces in headernames into _
            fieldname = headers{h};
            spaces = strfind(headers{h}, ' ');
            if ~isempty(spaces)
                fieldname(spaces) = '_';
            end
            fileinfo = setfield(fileinfo,fieldname,value); %set each header as a field
        end
        fileinfo.index = cell2mat(data(r,1:sizeindex));
        
        %save it
        save([anprocesseddatadir,'fileinfo', num2str(data{r,sizeindex}),'.mat'], 'fileinfo')
    end
end


