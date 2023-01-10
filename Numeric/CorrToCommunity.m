function [SScommunity,QQ,n_it]=CorrToCommunity(r)        

%%%%%%%quick communit clustering with input r, correlation matrix


        AdjMat=r+1;  %%%%%%%%%%Non-negative weighted correlation.
%            clear SampleCorr;
            for itt=1:size(AdjMat,1)
                AdjMat(itt,itt)=0;%%%%%%diagonal zeros for Adjcent matrix
            end
            k = full(sum(AdjMat));
        twom = sum(k);
%         B = full(Adj - gamma*k'*k/twom);
        tic
        k = full(sum(AdjMat));
        twom = sum(k);
        gamma = 1;  %%Community Clustering Paramter%%
        limit =10000; %%memory consideration for community clustering 

        B = @(i) AdjMat(:,i) - gamma*k'*k(i)/twom;
        disp('Clustering ...iterated_genlouvain.m');
        tic        %%%%%%Clustering
        [SScommunity,QQ,n_it]=iterated_genlouvain(B,limit);
        toc
%         QQ = QQ/twom;
        clear B AdjMat;
