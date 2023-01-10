function ss=StrSubIndex(s,Index)

for i=1:length(Index)
    ss(i)=s(Index(i));    

end



% i=1;
% i_Day=1;
% 
% Names=fieldnames(s);
% while i_Day<=length(Index)
% 
%       for ii=1:length(DayIndex{i_Day})
%           if ii==1
%              TempDay(i_Day).Track=DayFile(i).Track;
%           else
% 
%               for iii=1:length(DayFile(i).Track)
%                  l=length(TempDay(i_Day).Track);
%                  for i_field=1:length(Names)
%                      temp=getfield(DayFile(i).Track,{iii},Names{i_field});                    
%                      TempDay(i_Day).Track=setfield(TempDay(i_Day).Track,{l+1},Names{i_field},temp);
%                  
%                  end
%               
%               end
%                  
% 
%               
%           end
%           i=i+1;
% 
%       end
%       i_Day=i_Day+1;
% 
% end
% 
% DayFile=TempDay;