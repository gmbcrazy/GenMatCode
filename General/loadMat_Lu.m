function Output=loadMat_Lu(PathFile)

%%%%%%%load .mat file; PathFile might not be 100% accurate, such as '*abc.mat';
%%%%%%%loadMat_Lu('Y:\Python\Animal*5.mat')

a=dir(PathFile);
if isempty(a)
    disp([PathFile ' not found']);
   Output=[];
elseif length(a)==1
   Output=load([a.folder '\' a.name]);
else 
   disp('more than one .mat file qualified');
   for i=1:length(a)
       disp(a(i).name); 
   end
end