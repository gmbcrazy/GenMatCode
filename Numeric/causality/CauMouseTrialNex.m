function FileMouseDay=CauMouseTrialNex(NexFile,FileIndex,varargin)

% % FileMouseDay=PowerMouseTrialNex(fileName,FileIndex,psdParameter,AnalysisP)
%%%FileMouseDay.Chanlist is a vector includes Num of LFP pairs in Each day's data. 
cauCase=0;
anaCase=0;

if nargin==4
CausalityParameter=varargin{1};
AnalysisP=varargin{2};

elseif nargin==3

    if isfield(varargin{1},'nfft')
       CausalityParameter=varargin{1};
       anaCase=1;
    else
       AnalysisP=varargin{1};
       cauCase=1;

    end
    
else
    cauCase=1;
    anaCase=1;


    
end

if cauCase
    
CausalityParameter.downsample=8;
CausalityParameter.MORDER_band=[16;16];
CausalityParameter.fre_band=[0;500];
CausalityParameter.NFFT=512;
CausalityParameter.fs=1000;

end

if anaCase
AnalysisP.psd_p=1;
AnalysisP.csd_p=1;
AnalysisP.Vth=2.5;          %speed threshold to compute distance of traces
AnalysisP.run_th=5;    %speed threshold to define running period    
AnalysisP.time_th=1;  %time threshold to define running period 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%speed >run_th continously for >time_th is
%%%%%%%%%%%%%%%%%%%%%%%%%%%%considered as running period
AnalysisP.ArtificialDelay=0.4;%%%%%%%%%%% LFP data immediatelly after reward was excluded in psd analysis
AnalysisP.NaviDelay=1; %%%%%%% 1s delay for goal-directed navigation
AnalysisP.AnalysisDuration=4;%%%%length of data included in LFP analysis
AnalysisP.Timerange=[0;720];%%%%length of data included in LFP analysis
end



for i_s=1:5
              AllS1{i_s}=[];
              NaviS1{i_s}=[];
              ForeS1{i_s}=[];
              DiS1{i_s}=[];
              InDiS1{i_s}=[];


              AllS2{i_s}=[];
              NaviS2{i_s}=[];
              ForeS2{i_s}=[];
              DiS2{i_s}=[];
              InDiS2{i_s}=[];

            
              AllCmm{i_s}=[];
              NaviCmm{i_s}=[];
              ForeCmm{i_s}=[];
              DiCmm{i_s}=[];
              InDiCmm{i_s}=[];
              
              
              AllF1to2{i_s}=[];
              NaviF1to2{i_s}=[];
              ForeF1to2{i_s}=[];
              DiF1to2{i_s}=[];
              InDiF1to2{i_s}=[];
              
              
              AllF2to1{i_s}=[];
              NaviF2to1{i_s}=[];
              ForeF2to1{i_s}=[];
              DiF2to1{i_s}=[];
              InDiF2to1{i_s}=[];


end

F=[];
TimeResetIndex=[];
for i_d=1:length(FileIndex)
    tic
    Chanlist(i_d,1)=length(NexFile{FileIndex(i_d)}.HippChan)*length(NexFile{FileIndex(i_d)}.CereChan);
    iChan=1;
    ChanNames(i_d).Name=[NexFile{FileIndex(i_d)}.HippChan NexFile{FileIndex(i_d)}.CereChan];
    File{i_d}=NexFile{FileIndex(i_d)}.General;
    
    Duration=diff(NexFile{FileIndex(i_d)}.Timerange);
    [minD pmin]=min(Duration);
    [maxD pmax]=max(Duration);
    if ((maxD-minD)/minD)>0.5
        NexFile{FileIndex(i_d)}.Timerange(1,:)=NexFile{FileIndex(i_d)}.Timerange(1,pmin);
        NexFile{FileIndex(i_d)}.Timerange(2,:)=NexFile{FileIndex(i_d)}.Timerange(2,pmin);
        TimeResetIndex=[TimeResetIndex i_d];
    elseif (maxD-minD)>240
        NexFile{FileIndex(i_d)}.Timerange(1,:)=NexFile{FileIndex(i_d)}.Timerange(1,pmin);
        NexFile{FileIndex(i_d)}.Timerange(2,:)=NexFile{FileIndex(i_d)}.Timerange(2,pmin);
        TimeResetIndex=[TimeResetIndex i_d];
    else

    end
    
    while iChan<=Chanlist(i_d,1);
          for iHipp=1:length(NexFile{FileIndex(i_d)}.HippChan)
              for iCere=1:length(NexFile{FileIndex(i_d)}.CereChan)
    
                  Temp1=NexFile{FileIndex(i_d)}.HippChan(iHipp);
                  Temp2=NexFile{FileIndex(i_d)}.CereChan(iCere);

                  clear Chan
                  Chan{1}.Name=['HippCh' num2str(Temp1) 'AD'];
                  Chan{2}.Name=['CereCh' num2str(Temp2) 'AD'];

                  for i_s=1:length(NexFile{FileIndex(i_d)}.Individual)
                      fileName=[NexFile{FileIndex(i_d)}.General num2str(NexFile{FileIndex(i_d)}.Individual(i_s)) '-f.nex'];
                      AnalysisP.Timerange=NexFile{FileIndex(i_d)}.Timerange(:,i_s);                 
%                       FileData=PowerAnalysisTrialNex(fileName,Chan,psdParameter,AnalysisP);
                      
                      FileAveDay=CauTrialAveAR(fileName,Chan,CausalityParameter,AnalysisP);
                      
%                       FileAveDay=PowerRep(FileData);
                      
              if isempty(F)        
                 if ~isempty(FileAveDay.All.F)
                    F=FileAveDay.All.F;
                 end
              end
                  SubZero=zeros(size(FileAveDay.All.Pxx));
              
              if iHipp==1
              AllS2{i_s}=rowAddingPower(AllS2{i_s},FileAveDay.All.Pyy,SubZero);
              NaviS2{i_s}=rowAddingPower(NaviS2{i_s},FileAveDay.Navi.Pyy,SubZero);
              ForeS2{i_s}=rowAddingPower(ForeS2{i_s},FileAveDay.Fore.Pyy,SubZero);
              DiS2{i_s}=rowAddingPower(DiS2{i_s},FileAveDay.DiNavi.Pyy,SubZero);
              InDiS2{i_s}=rowAddingPower(InDiS2{i_s},FileAveDay.InDiNavi.Pyy,SubZero);
              end
              
              if iCere==1
              AllS1{i_s}=rowAddingPower(AllS1{i_s},FileAveDay.All.Pxx,SubZero);
              NaviS1{i_s}=rowAddingPower(NaviS1{i_s},FileAveDay.Navi.Pxx,SubZero);
              ForeS1{i_s}=rowAddingPower(ForeS1{i_s},FileAveDay.Fore.Pxx,SubZero);
              DiS1{i_s}=rowAddingPower(DiS1{i_s},FileAveDay.DiNavi.Pxx,SubZero);
              InDiS1{i_s}=rowAddingPower(InDiS1{i_s},FileAveDay.InDiNavi.Pxx,SubZero);
              end
            
              AllCmm{i_s}=rowAddingPower(AllCmm{i_s},FileAveDay.All.Coh,SubZero);
              NaviCmm{i_s}=rowAddingPower(NaviCmm{i_s},FileAveDay.Navi.Coh,SubZero);
              ForeCmm{i_s}=rowAddingPower(ForeCmm{i_s},FileAveDay.Fore.Coh,SubZero);
              DiCmm{i_s}=rowAddingPower(DiCmm{i_s},FileAveDay.DiNavi.Coh,SubZero);
              InDiCmm{i_s}=rowAddingPower(InDiCmm{i_s},FileAveDay.InDiNavi.Coh,SubZero);

              
              AllF1to2{i_s}=rowAddingPower(AllF1to2{i_s},FileAveDay.All.F1to2,SubZero);
              NaviF1to2{i_s}=rowAddingPower(NaviF1to2{i_s},FileAveDay.Navi.F1to2,SubZero);
              ForeF1to2{i_s}=rowAddingPower(ForeF1to2{i_s},FileAveDay.Fore.F1to2,SubZero);
              DiF1to2{i_s}=rowAddingPower(DiF1to2{i_s},FileAveDay.DiNavi.F1to2,SubZero);
              InDiF1to2{i_s}=rowAddingPower(InDiF1to2{i_s},FileAveDay.InDiNavi.F1to2,SubZero);


              AllF2to1{i_s}=rowAddingPower(AllF2to1{i_s},FileAveDay.All.F2to1,SubZero);
              NaviF2to1{i_s}=rowAddingPower(NaviF2to1{i_s},FileAveDay.Navi.F2to1,SubZero);
              ForeF2to1{i_s}=rowAddingPower(ForeF2to1{i_s},FileAveDay.Fore.F2to1,SubZero);
              DiF2to1{i_s}=rowAddingPower(DiF2to1{i_s},FileAveDay.DiNavi.F2to1,SubZero);
              InDiF2to1{i_s}=rowAddingPower(InDiF2to1{i_s},FileAveDay.InDiNavi.F2to1,SubZero);
 
                      
                      
                  end

              iChan=iChan+1;

             
              end

          end

    end
    
    toc

end


FileMouseDay.AllS1=AllS1;
FileMouseDay.AllS2=AllS2;
FileMouseDay.AllCmm=AllCmm;
FileMouseDay.AllF1to2=AllF1to2;
FileMouseDay.AllF2to1=AllF2to1;


FileMouseDay.NaviS1=NaviS1;
FileMouseDay.NaviS2=NaviS2;
FileMouseDay.NaviCmm=NaviCmm;
FileMouseDay.NaviF1to2=NaviF1to2;
FileMouseDay.NaviF2to1=NaviF2to1;


FileMouseDay.ForeS1=ForeS1;
FileMouseDay.ForeS2=ForeS2;
FileMouseDay.ForeCmm=ForeCmm;
FileMouseDay.ForeF1to2=ForeF1to2;
FileMouseDay.ForeF2to1=ForeF2to1;


FileMouseDay.DiS1=DiS1;
FileMouseDay.DiS2=DiS2;
FileMouseDay.DiCmm=DiCmm;
FileMouseDay.DiF1to2=DiF1to2;
FileMouseDay.DiF2to1=DiF2to1;

FileMouseDay.InDiS1=InDiS1;
FileMouseDay.InDiS2=InDiS2;
FileMouseDay.InDiCmm=InDiCmm;
FileMouseDay.InDiF1to2=InDiF1to2;
FileMouseDay.InDiF2to1=InDiF2to1;




FileMouseDay.Chanlist=Chanlist;
FileMouseDay.F=F;
FileMouseDay.ChanNames=ChanNames;
FileMouseDay.File=File;
FileMouseDay.TimeResetIndex=TimeResetIndex;
