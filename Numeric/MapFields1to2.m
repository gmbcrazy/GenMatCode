function structData=MapFields1to2(struct1,struct2)

%%%%Transfering subfields of struct variable 1 to Variable 2
%%%%Noticed that the dimention of struct 1 and struct 2 should equal or less than one

% Create a cell array with the names of the subfields you want to remove,
% the rest of fields were what you want to move from struct 1 to struct2;
rmFields = intersect(fieldnames(struct2),fieldnames(struct1));


% Remove the subfields you don't want from the original structure
struct1 = rmfield(struct1, rmFields);

% Convert the remaining subfields to a cell array
structData = [struct2cell(struct2);struct2cell(struct1)];
% Define the names of the subfields in the new structure
newFields = [fieldnames(struct2);fieldnames(struct1)];

% Convert the cell array back into a structure with the desired subfields
structData = cell2struct(structData(:), newFields(:));

