function [Coord,Time]=InsertTimeCoor(Coord,Time,CoordTh,TimeTh)

Time=Time(:);
SampleWin=median(diff(Time));
diffT=diff(Time);
I1=find(diffT>TimeTh);
diffC=diff(Coord);

% figure;
% subplot(1,2,1)
% plot(Time,Coord,'.');
% CoordI=find(diffCoord>CoordTh)+1;
% for i=1:length(CoordI)
%      
%     
% end

if ~isempty(I1)
      I1=I1(1);
      I2=find(diffC>CoordTh);
      if ~isempty(I2)&&max(I2)>I1
         I2=I2(min(find(I2>I1)));
         Ivalid=(I1+1):I2;
         Coord(Ivalid)=[];
         Time(Ivalid)=[];
         I2=I2+1-length(Ivalid);
         
         InsertTime=Time(I1):SampleWin:Time(I2);
         InsertTime((InsertTime==Time(I1)|InsertTime==Time(I2)))=[];
         NumInsert=length(InsertTime);
         
          temp=(Coord(I2)-Coord(I1))/NumInsert;

         temp1=temp*(1:NumInsert);
         CoordInsert=temp1(:)+Coord(I1);
         Coord=[Coord(1:I1);CoordInsert;Coord(I2:end)];
         Time=[Time(1:I1);InsertTime(:);Time(I2:end)];
      end
end

Ivalid=find(diff(Time)<=0.005);
Coord(Ivalid)=[];
Time(Ivalid)=[];

% subplot(1,2,2)
% plot(Time,Coord,'r.');


