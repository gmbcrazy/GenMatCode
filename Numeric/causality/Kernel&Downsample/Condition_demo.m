clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
path_filename='J:\6-xk128\103005\nex_1_finish\lab02-xk128-103005004-f.nex';%%%%文件路径名;
 timerange=[1760;1790];
CausalityParameter.MORDER_band=[11;11];
CausalityParameter.fre_band=[0;50];
CausalityParameter.NFFT=512;
CausalityParameter.fs=1000;
CausalityParameter.downsample=10;
 fs=1000;                  %%%%%%%%采样频率
 Data_name(1).Name='AD27_ad_000';    %%%%%%%变量名1 可以为任何nex中的任何变量
 Data_name(2).Name='scsig053ats';    %%%%%%%变量名2 可以为任何nex中的任何变量
 Data_name(3).Name='scsig041ats';    %%%%%%%变量名3 可以为任何nex中的任何变量
Causality1=Causality_Condition(path_filename,Data_name,timerange,CausalityParameter)%%%%%%%%%计算条件causality

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%计算两两普通causality
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%计算两两普通causality





% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%画图
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
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%画图


figure;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%画图 行i 列j表示第i个变量对第j个变量的Causality
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%画图