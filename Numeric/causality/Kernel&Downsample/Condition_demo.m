clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
path_filename='J:\6-xk128\103005\nex_1_finish\lab02-xk128-103005004-f.nex';%%%%�ļ�·����;
 timerange=[1760;1790];
CausalityParameter.MORDER_band=[11;11];
CausalityParameter.fre_band=[0;50];
CausalityParameter.NFFT=512;
CausalityParameter.fs=1000;
CausalityParameter.downsample=10;
 fs=1000;                  %%%%%%%%����Ƶ��
 Data_name(1).Name='AD27_ad_000';    %%%%%%%������1 ����Ϊ�κ�nex�е��κα���
 Data_name(2).Name='scsig053ats';    %%%%%%%������2 ����Ϊ�κ�nex�е��κα���
 Data_name(3).Name='scsig041ats';    %%%%%%%������3 ����Ϊ�κ�nex�е��κα���
Causality1=Causality_Condition(path_filename,Data_name,timerange,CausalityParameter)%%%%%%%%%��������causality

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����������ͨcausality
for i=1:length(Data_name)
    for ii=i:length(Data_name)
        if i~=ii
        temp_Name(1).Name=Data_name(i).Name;
        temp_Name(2).Name=Data_name(ii).Name;
        Causality_temp=Causality_Pair(path_filename,temp_Name,timerange,CausalityParameter);
        Causality_pair{i,ii}= Causality_temp.F1to2;
        Causality_pair{ii,i}= Causality_temp.F2to1;
        fre_pair=Causality_temp.F;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����������ͨcausality





% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ͼ
% for i=1:length(Data_name)
%     for ii=i:length(Data_name)
%         
%         if ii~=i
%             iii=setdiff(1:3,[i,ii]);
%             figure;
%             plot(fre_pair,Causality_pair{i,ii},'color',[0 0 1]);
%             hold on
%             plot(fre_pair,Causality_pair{ii,i},'color',[1 0 0]);
%             hold on;
%             t=plot(Causality1.F, Causality1.Fy2x(i,ii).Causality,'color',[0 0 1]);
%             set(t,'marker','.');
%             hold on;
%             t=plot(Causality1.F, Causality1.Fy2x(ii,i).Causality,'color',[1 0 0]);
%             set(t,'marker','.');
% 
%             title(['causality between ' Data_name(i).Name 'and' Data_name(ii).Name]);
%             legend([Data_name(i).Name ' to ' Data_name(ii).Name],[Data_name(ii).Name ' to ' Data_name(i).Name],[Data_name(i).Name ' to ' Data_name(ii).Name,' with ' Data_name(iii).Name],[Data_name(ii).Name ' to ' Data_name(i).Name,' with ' Data_name(iii).Name]);
%             set(gca,'xlim',[0 100])
%         end
%             
%     end
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ͼ


figure;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ͼ ��i ��j��ʾ��i�������Ե�j��������Causality
for i=1:length(Data_name)
    for ii=1:length(Data_name)
        
        if ii~=i
            subplot(3,3,(i-1)*3+ii);

            iii=setdiff(1:3,[i,ii]);
%             figure;
            plot(fre_pair,Causality_pair{i,ii},'color',[0 0 1]);
            hold on
%             plot(fre_pair,Causality_pair{ii,i},'color',[1 0 0]);
%             hold on;
            t=plot(Causality1.F, Causality1.Fy2x(i,ii).Causality,'color',[1 0 0]);
%             set(t,'marker','.');
            hold on;
%             t=plot(Causality1.F, Causality1.Fy2x(ii,i).Causality,'color',[1 0 0]);
%             set(t,'marker','.');

%             title(['causality between ' Data_name(i).Name 'and' Data_name(ii).Name]);
%             legend([Data_name(i).Name ' to ' Data_name(ii).Name],[Data_name(i).Name ' to ' Data_name(ii).Name,' with ' Data_name(iii).Name]);
            set(gca,'xlim',[0 100])
        end
            
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ͼ