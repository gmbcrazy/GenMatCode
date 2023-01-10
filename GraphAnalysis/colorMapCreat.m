function xx=colorMapCreat(SColor,EColor,n,varargin)

for i=1:length(SColor(:,1))
step=(EColor(i,:)-SColor(i,:))/(n-1);

x(:,1)=SColor(i,1):step(1):EColor(i,1);
x(:,2)=SColor(i,2):step(2):EColor(i,2);
x(:,3)=SColor(i,3):step(3):EColor(i,3);

   xx{i}=x;
   clear x;
end


if nargin==5
   PathSave=varargin{1};
   MapName=varargin{2};
else
   return
end


fileID = fopen([PathSave '.txt'],'w');
%%Show(2,:)=[MapName '1-' num2str(n) '-seq-rev=' MapName '1-' num2str(n) '-seq=(\d+)'];

for iMap=1:length(xx)
    Show(1,:)='                                                 ';
%     temptext=['# color ' MapName num2str(iMap)];
%     Show(1,1:length(temptext))=temptext;
%     temptext=[MapName num2str(iMap) '-' num2str(n) '-seq=' MapName '1-' num2str(n) '-seq(\d+)'];
%     Show(2,1:length(temptext))=temptext;
    for i=1:n
        c1=ceil(xx{iMap}(i,1)); 
        c2=ceil(xx{iMap}(i,2));
        c3=ceil(xx{iMap}(i,3));
%         temptext=[MapName num2str(iMap) '-' num2str(n) '-seq-' num2str(i) '=' num2str(c1) ',' num2str(c2) ',' num2str(c3)];
        temptext=[MapName num2str(iMap) num2str(i) '=' num2str(c1) ',' num2str(c2) ',' num2str(c3)];

        Show(i,1:length(temptext))=temptext;
 
    end

    for ii=1:length(Show(:,1))
    fprintf(fileID,'%s\r\n',deblank(Show(ii,:)));
    end
% % % %     fprintf(fileID,'%s\r\n');
    clear Show
end

fclose(fileID);
clear Show





    
