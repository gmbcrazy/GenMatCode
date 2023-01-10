function structNew=FieldName2Struct(fieldNames)

%%%%Define am empty structure variable with field names from cell variable fieldNames

structCell=cell(length(fieldNames),1);

structNew=cell2struct(structCell,fieldNames);
structNew(1)=[];
