function STATS=mybarnard(varargin)
%BARNARD Barnard's Exact Probability Test.
%There are two fundamentally different exact tests for comparing the equality
%of two binomial probabilities ¨C Fisher¡¯s exact test (Fisher, 1925), and
%Barnard¡¯s exact test (Barnard, 1945). Fisher¡¯s exact test (Fisher, 1925) is
%the more popular of the two. In fact, Fisher was bitterly critical of
%Barnard¡¯s proposal for esoteric reasons that we will not go into here. 
%For 2 ¡Á 2 tables, Barnard¡¯s test is more powerful than Fisher¡¯s, as Barnard
%noted in his 1945 paper, much to Fisher¡¯s chagrin. Anyway, perhaps due to its
%computational difficulty the Barnard's is not widely used. This function is
%completely vectorized and without for...end loops, and so, the computation is
%very fast.
%The Barnard's exact test is a unconditioned test for it generates the exact
%distribution of the Wald statistic T(X),
%
%           T(X) = abs((p(a) - p(b))/sqrt(p*(1-p)*((1/c1)+(1/c2)))),
%   where,
%           p(a) = a/c1, p(b) = b/c2 and p = (a+b)/n, 
%
%by considering all tables X and calculates P(np) for all possible values of 
%np?(0,1). 
%Under H0, the probability of observing any generic table X is
%
%            /Cs1\  /Cs2\   (I+J)       [N-(I+J)]
% P(X|np) =  |    | |    |*np     *(1-np)
%            \ I /  \ J /
%
%Then, for any given np, the exact p-value of the observed Table Xo is 
%        __
%        \
%  p(np)=/_P(X|np)
%        T(X)>=T(Xo)
%
%Barnard suggested that we calculate p(np) for all possible values of np?(0,1)
%and choose the value, np*, say, that maximizes p(np): PB=sup{p(np): np?(0,1)}.
%
%   Syntax: function [STATS]=mybarnard(x,Tbx,plts) 
%      
%      
%     Inputs:
%           X - 2x2 data matrix
%           Tbx - is the granularity of the np array (how many points in the
%           interval (0,1) must be considered to determine np* (default=100).
%           PLTS - Flag to set if you don't want (0) or want (1) view the plots (default=0)
%     Output:
%         A table with:
%         - Wald statistic, Nuisance parameter and P-value
%         - Plot of the nuisance parameter PI against the corresponding P-value for
%           all the PI in (0, 1). It shows the maximized PI where it attains the
%           P-value.
%        If STATS nargout was specified the results will be stored in the STATS
%        struct.
%
%   Example (by itself, mybarndard runs this demo):
%
%                                    Vaccine
%                               Yes           No
%                            ---------------------
%                    Yes         7            12
% Infectious status                 
%                     No         8            3
%                            ---------------------
%                                       
%   Calling on Matlab the function: 
%             mybarnard([7 12; 8 2])
%
%   Answer is:
%
% 2x2 matrix Barnard's exact test: 1000 16x16 tables were evaluated
% --------------------------------------------------------------------------------
% Wald statistic = 1.8943 - Nuisance parameter = 0.6646
% p-values		 1-tailed = 0.034077 		2-tailed = 0.068153
% --------------------------------------------------------------------------------
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2009) MyBarnard: a very compact routine for Barnard's exact test on 2x2 matrix
% http://www.mathworks.com/matlabcentral/fileexchange/25760

%Input Error handling
args=cell(varargin);
nu=numel(args);
if nu<=3
    default.values = {[7 12; 8 3],100,0};
    default.values(1:nu) = args;
    [x Tbx plts] = deal(default.values{:});
    if nu==0
        plts=1;
    end
    if nu>=1
        if ~isequal(size(x),[2 2])
            error('Input matrix must be a 2x2 matrix')
        end
        if ~all(isfinite(x(:))) || ~all(isnumeric(x(:)))
            error('Warning: all X values must be numeric and finite')
        end
        if ~isequal(x(:),round(x(:)))
            error('Warning: X data matrix values must be whole numbers')
        end
    end
    if nu>=2
        if ~all(isfinite(Tbx) || ~all(isnumeric(Tbx))) && ~isreal(Tbx) && Tbx~=round(Tbx)
            error('Error: Tbx value must be a whole number')
        end
    end
    if nu==3
        if plts ~= 0 && plts ~= 1 %check if plts is 0 or 1
            error('Warning: PLTS must be 0 if you don''t want or 1 if you want to see plot.')
        end
    end
else
    error('Warning: Max three input data are required')
end
clear args default nu
    

Cs=sum(x); N=sum(Cs); %Columns sum and total observed elements
%First of all, we must compute the Wald's statistic.
%           T(X) = (p(a) - p(b))/sqrt(p*(1-p)*((1/Cs1)+(1/Cs2))),
%   where:
% I can vary from 0 to Cs(1)
% J can vary from 0 to Cs(2)
% p(a) = I/Cs1, p(b) = J/Cs2 and p = (I+J)/N
% It is possible to compute all the T(X) values, without using the for...end loops

[I,J]=ndgrid(0:1:Cs(1), 0:1:Cs(2));

% I and J will be 2 square matrix
%I=  0    0    0  ... ...  0
%    1    1    1  ... ...  1
%   ...  ...  ... ... ... ...
%   ...  ...  ... ... ... ...
%   Cs1  Cs1  Cs1 ... ... Cs1
%
%J=  0    1    2  ... ...  Cs2
%    0    1    2  ... ...  Cs2
%   ...  ...  ... ... ...  ...
%   ...  ...  ... ... ...  ...
%    0    1    2  ... ...  Cs2
%
%TX will be a Cs(1)+1 x Cs(2)+1 matrix.
%For two I and J combinations, T(X) shows a singularity:
%i.e. I=0 J=0 T(X)=0/0
%     I=Cs(1) J=Cs(2) T(X)=0/0
%So, for these two points T(X) will be set to 0

warning('OFF','MATLAB:divideByZero') %disable the warning
TX=(I./Cs(1)-J./Cs(2))./realsqrt(((I+J)./N).*(1-((I+J)./N)).*sum(1./Cs)); %computes the Wald's statistics
warning('ON','MATLAB:divideByZero') %renable the warning
TX([1 end])=0; %resolve the singularities
TX0=abs(TX(x(1)+1,x(3)+1)); %catch the observed Table (TXo), taking the 0 in account
idx=TX>=TX0; %set the index of all T(X)>=TXo
%Idx will be a Cs(1)+1 x Cs(2)+1 matrix where cells are 1 if TX>=TXo otherwise 0

%Now we must introduce the nuisance parameter.
%Under H0, the probability of observing any generic table X is
%
%            /Cs1\  /Cs2\   (I+J)       [N-(I+J)]
% P(X|np) =  |    | |    |*np     *(1-np)
%            \ I /  \ J /
%
%Then, for any given np, the exact p-value of the observed Table Xo is 
%        __
%        \
%  p(np)=/_P(X|np)
%        T(X)>=T(Xo)
%What shall we do with the unknown nuisance parameter np in the above p-value?
%Barnard suggested that we calculate p(np) for all possible values of np?(0,1)
%and choose the value, np*, say, that maximizes p(np).
% PB=sup{p(np): np?(0,1)}
%
%Expanding P(X|np) we have:
%
%                  (I+J)        [N-(I+J)]
%  Cs1! * Cs2! * np      * (1-np)
%  --------------------------------------
%     I! * (Cs1-I)! * J! * (Cs2-J)!
%
%The factorials growth very quickly, so to avoid and overflow:
%x!=prod(1:x) => log(x!)=sum(log(1:x))
%x!=G(x+1) => log(x!)=Glog(x+1) where G is the Gamma function and Glog is the
%logarithm of the Gamma function.
%Using the logarithm, multiplications and divisions became sums (and computers
%love sums much more than multiplications...)
%log(a*b)=log(a)+log(b); log(a/b)=log(a)-log(b); log(a^b)=b*log(a)
%So:
%log(P(X|np))=[Glog(Cs1+1)+Glog(Cs2+1)-Glog(I+1)-Glog(Cs1-I+1)-Glog(J+1)-Glog(Cs2-J+1)]+[(I+J)*log(np)]+{[N-(I+J)]*log(1-np)]}
% 
%Thus, to compute log(P(X|np)) we should implement three nested for...end loops
%for np=0:step:1
%  for I=0:Cs1
%      for J=0:Cs2
%          compute S=log(P(np,I,J))
%      end
%  end
%  P(np)=sum(exp(S(TX>=TXo)));
% end
%p-value=Max(P); nuisance parameter=np(P==p-value)
%
%This approach is very time consuming and is not efficient. Consider that is 
%the users that establishes the duration of the first loop: little step values
%(Tbx variable) raise up the accuracy of the nuisance parameter computations but
%the time of computing becames highest. Moreover, in Matlab you can do the same
%without using the for...end loops. 
%First of all, the quantity between the first square brackets depends only on I
%and J but not on np
%log(P(X|np))=CF+[(I+J)*log(np)]+{[N-(I+J)]*log(1-np)]}
%I and J were implemented using ndgrid function and so CF, as TX, will be a
%(Cs1+1) x (Cs2+2) matrix. But, also [(I+J)*log(np)] and {[N-(I+J)]*log(1-np)]}
%will be (Cs1+1) x (Cs2+2) matrix. These matrix will be summed Tbx times...

%Set the basic parameters...
A=[1 1 Tbx]; B=Cs+1; npa = linspace(0.0001,0.9999,Tbx); 
LP=log(npa); ALP=log(1-npa); E=repmat(I+J,A); F=N-E;

%Generate a 3D matrix (Cs1+1 x Cs2+1 x Tbx): this is a "box" where each of Tbx 2D
%slice is the Cs1+1 x Cs2+1 matrix CF
CF=repmat(sum(gammaln(B))-(gammaln(I+1)+gammaln(J+1)+gammaln(B(1)-I)+gammaln(B(2)-J)),A);

%Now we have two 1xTbx arrays (LP and ALP) and two Cs1+1 x Cs2+1 x Tbx "boxes"
%(E and F). As Peter J. Acklam wrote in his "Matlab array manipulation tips and
%tricks" (http://home.online.no/~pjacklam/matlab/doc/mtt/doc/mtt.pdf), there is
%a no for...loop solution to multiply each 2D slice with the corresponding
%element of a vector. 
%Assume X is an m-by-n-by-p array and v is a row vector with length p. 
%How does one write:
%
%  Y = zeros(m, n, p);
%  for i = 1:p
%     Y(:,:,i) = X(:,:,i) * v(i);
%  end
%
%with no for-loop? One way is to use:
%  Y = X .* repmat(reshape(v, [1 1 p]), [m n]);
% 
%So we can construct the two others 3D boxes:
%Box1=CF
%Box2=E.*repmat(reshape(LP,[1 1 Tbx]),[Cs1+1 Cs2+1])=E.*repmat(reshape(LP,A),B)
%Box3=F.*repmat(reshape(ALP,[1 1 Tbx]),[Cs1+1 Cs2+1])=F.*repmat(reshape(ALP,A),B)
%Finally, we can obtain the S box that is the sum of these three boxes (remember
%that we are using logarithms, so we must convert them using the exp function)
S=exp(CF+E.*repmat(reshape(LP,A),B)+F.*repmat(reshape(ALP,A),B));

%Now we are at the last point: for each 2D slice of the S box we must sum the
%values corresponding to TX>=TXo, obtaining a new vector P.
%To use the logical indexing tecnique, we must replicate the idx matrix:
%S(repmat(idx,A)) is a column vector that has L*Tbx row; 
%L=sum(idx(idx==1)) is the number of 1 in the idx matrix.
%Using the reshape function we can obtain a new LxTbx matrix: in each column
%we'll have the P(X|np & TX>=Txo) and using the function sum we'll, finally,
%obtain the P vector.
P=sum(reshape(S(repmat(idx, A)),sum(idx(idx==1)),Tbx));

PV=max(P); %The p-value is tha max value of the P vector;
np=npa(P==PV); %The nuisance parameter is the value of the npa array coinciding with PMax

%display results
tr=repmat('-',1,80); %Set up the divisor
disp(' ')
fprintf('2x2 matrix Barnard''s exact test: %u %ux%u tables were evaluated\n',Tbx,B)
disp(tr)
fprintf('Wald statistic = %0.4f - Nuisance parameter = %0.4f\n',TX0,np)
fprintf('p-values\t\t 1-tailed = %0.6f \t\t2-tailed = %0.6f\n',PV,min(2*PV,1))
disp(tr)
disp(' ')

if nargout
    STATS.TX0=TX0;
    STATS.p_value=PV;
    STATS.nuisance=np;
end

if plts
    %display plot
    subplot(1,2,1)
    hold on; 
    patch(npa,P,'b');
    plot([0 np],[PV PV],'k--'); 
    plot([np np],[0 PV],'w--'); 
    plot(np,PV,'ro','MarkerFaceColor','red'); 
    hold off
    title('Barnard''s exact p-value as a function of nuisance parameter np.','FontName','Arial','FontSize',14,'FontWeight','Bold');
    xlabel('Nuisance parameter (np)','FontName','Arial','FontSize',14,'FontWeight','Bold');
    ylabel('p-value  [p(TX >= TXO | np)]','FontName','Arial','FontSize',14,'FontWeight','Bold');
    axis square

    A=TX(:);
    B=reshape(S(:,:,P==PV),numel(TX),1);
    [As,idx]=sort(A);
    Bs=B(idx);
    clear A B idx 
    Xplot=unique(As);
    Yplot=zeros(size(Xplot));
    for I=1:length(Xplot)
        Yplot(I)=sum(Bs(As==Xplot(I)));
    end
    subplot(1,2,2)
    bar(Xplot,Yplot)
    title('Distribution of Wald Statistic for Barnard''s Exact test','FontName','Arial','FontSize',12,'FontWeight','Bold');
    xlabel('T(X)','FontName','Arial','FontSize',12,'FontWeight','Bold');
    txt=['P[T(X)|pi=' num2str(np) ']'];
    ylabel(txt,'FontSize',12,'FontWeight','Bold');
    axis square
end
