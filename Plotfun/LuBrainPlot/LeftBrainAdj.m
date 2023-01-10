function Adj=LeftBrainAdj(Adj)

Adj=abs(Adj);
Adj=Adj-diag(diag(Adj));

load('D:\FMRI\AAL\LuAAL.mat');
% % % % for i=1:length(AALName)
% % % %     temp=deblank(AALName{i});
% % % %     if findstr(temp(end),'L')
% % % %        Side(i)=1;
% % % %     elseif findstr(temp(end),'R')
% % % %        Side(i)=2;
% % % %     else
% % % %        Side(i)=0;
% % % %     end
% % % % end
% % % % Side=Side';
Index1=find(Side==1);
Index2=find(Side==2);
if mean((Index1-Index2))~=-1
   error('Check LeftIndex and LeftIndex');
   return 
end


for i=1:size(Index1)
    a=Adj(Index1(i),:)+Adj(Index2(i),:);
    b=Adj(:,Index1(i))+Adj(:,Index2(i));    
    Adj(Index1(i),:)=a;
    Adj(:,Index1(i))=b;
    Adj(Index2(i),:)=0;
    Adj(:,Index2(i))=0;
end

