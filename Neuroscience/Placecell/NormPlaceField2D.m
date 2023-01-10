function CellField=NormPlaceField2D(aMap,Cell,aRowAxis,aColAxis,PeakRateTh,p)

[~,arenasize]=arenaPlot(p,0);

GoalCenter=[arenasize(2)-17.75 arenasize(6)];
GoalCenter=NORMtrace([GoalCenter],p);

GoalRadius=0.075;
InFieldR=[];

if isempty(Cell)
CellField.InFieldR=[];
CellField.Normfield=[];
CellField.NormPeakP=[];
CellField.PeakDist=[];
CellField.PeakRate=[];
CellField.MeanFieldR=[];
return
else
    ii=1;
    InIndexX=[];
    for i=1:length(Cell)

        if Cell(i).PeakR>PeakRateTh
           py=aRowAxis(Cell(i).IndX);
           px=aColAxis(Cell(i).IndY);
           NormfieldInX{ii}=Cell(i).IndX(:);
           NormfieldInY{ii}=Cell(i).IndY(:);

%            Normfield{ii}=NORMtrace([px(:) py(:)],p);
           Normfield{ii}=[px(:) py(:)];
           
           Peaky=aRowAxis(Cell(i).PeakIX);
           Peakx=aColAxis(Cell(i).PeakIY);
           
%            NormPeakP(ii,:)=NORMtrace([Peakx(:) Peaky(:)],p);
           NormPeakP(ii,:)=[Peakx(:) Peaky(:)];
 
           for j=1:length(Cell(i).PeakIX)
               TempR(j)=aMap(Cell(i).PeakIX,Cell(i).PeakIY);
           end
           
            TempMeanField{ii}=TempR(:);
            PeakRate(ii)=max(TempR);
            TempDistField{ii}=sqrt((Normfield{ii}(:,1)-GoalCenter(1)).^2+(Normfield{ii}(:,2)-GoalCenter(2)).^2);
            PeakDist(ii)=sqrt((NormPeakP(ii,1)-GoalCenter(1)).^2+(NormPeakP(ii,2)-GoalCenter(2)).^2);   %%%%%Distance between peak pixel in each place field and the goal zone center
            InFieldR(ii)=length(find(TempDistField{ii}<=GoalRadius))/length(TempDistField{ii});         %%%%%ratio of the area of place field which is inside of the goal zone
            ii=ii+1;
        end
    end
end



if ~isempty(InFieldR)
    
   if length(InFieldR)==1
      MeanFieldR=mean(TempMeanField{1});
   else
      ExC=find(InFieldR>=1.1);
      InC=setdiff(1:length(InFieldR),ExC);
      if length(InC)==0
         InFieldR=InFieldR;
         Normfield=Normfield;
         NormfieldInX=NormfieldInX;
         NormfieldInY=NormfieldInY;

         NormPeakP=NormPeakP;
         PeakDist=PeakDist;
         PeakRate=PeakRate;
         
         R=[];
         for j=1:length(InC)
             R=[R;TempMeanField{InC(j)}];
         end
         MeanFieldR=mean(R);

      else
         InFieldR=InFieldR(InC);
         NormfieldInX=CellSubIndex(NormfieldInX,InC);
         NormfieldInY=CellSubIndex(NormfieldInY,InC);

         Normfield=CellSubIndex(Normfield,InC);
         NormPeakP=NormPeakP(InC,:);
         PeakDist=PeakDist(InC);
         PeakRate=PeakRate(InC);
         R=[];
         for j=1:length(InC)
             R=[R;TempMeanField{InC(j)}];
         end
         MeanFieldR=mean(R);
         
         
      end
   end
else
         InFieldR=[];
         Normfield=[];
         NormPeakP=[];
         PeakDist=[];
         PeakRate=[];
         MeanFieldR=[];
         NormfieldInX=[];
         NormfieldInY=[];

end
CellField.InFieldR=InFieldR;
CellField.NormfieldInX=NormfieldInX;
CellField.NormfieldInY=NormfieldInY;

CellField.Normfield=Normfield;
CellField.NormPeakP=NormPeakP;
CellField.PeakDist=PeakDist;
CellField.PeakRate=PeakRate;
CellField.MeanFieldR=MeanFieldR;










