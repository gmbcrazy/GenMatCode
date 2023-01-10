% Fast detection of communities using modularity optimisation
% Author: Erwan Le Martelot
% Date: 21/10/11
%
% Input
%   - adj: adjacency matrix (with no self-loops??)
%
% Output
%   - com: best community partition
%   - Q  : modularity value of the corresponding partition
%
% Comments:
% - This implementation uses the modularity criterion. The code
% specific to modularity is placed between comment signs lines and can be
% replaced with code optimising any other criterion. It was placed within
% the algorithm and not in external functions for speed optimisation
% purposes only.
% - Algorithm principle: 1) Shifts all nodes, 2) Merge all communities
% Variations can be used (merge only some communities, some nodes, merge
% communities first and the nodes, etc) but overall this setup seems to
% work best.
% Modification:
% - Consider the links have positive or negative signs. Following the
% paper: "?????" to re-define the linking "probabilities" as  the
% "positive" linking minus the negative linking.
%  So, re-define the function compute-Q.

function [comq,QQ] = fast_mo_sgn(adj,KL)
% KL is the number of overlaps to avoid local maximum
%adj=[1 -1 -1;-1 1 1; -1 1 1]
%clear all;
%cd('./szo_data');
%load FEP;
%cd ..
%[r_s,p_s]=corrcoef(FEP);
%KL=2;
%adj=A;
%adj=r_s.*(r_s>0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% please keep the diagonals zeros
    % divide the adjacent into the positive and negative graphs
   %KL=1; 
    adjpositive=adj.*(adj>0);
    adjnegative=-(adj.*(adj<0));
    
    % Number of edges m and its double m2 
    mp2= sum(sum(adjpositive));
    mp = mp2/2;
    mn2=sum(sum(adjnegative));
    mn=mn2/2;
    m=mn+mp;
    m2=mp2+mn2;
    
    % Degree vector
    dp = sum(adjpositive,2);
    dn = sum(adjnegative,2);
    %d=dp-dn;
    
    % Neighbours list for each node
    % We don't need to identify the neighbrohood because we give the loop
    % for all nodes
     for i=1:length(adj)
         Nbs{i} = [1:length(adj)];
         Nbs{i}(Nbs{i}==i) = []; % remove the self-loop
     end
    
     
    QQ=0; 
   for kl=1:KL
      %kl
    % Total weight of each community
    % Shall we need this term? yes!!!
    wcomp = dp;
    wcomn = dn;
    wcom=wcomp-wcomn;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Community of each node
    com = 1:length(adj);
    
    % Initial Q value
%     Q = compute_Q_sgn(adj, com);
    Q=18;
    % While changes can be made
    check_nodes = true;
    check_communities = true;
    while check_nodes
%        disp('MO big loop');

        % Nodes moving
        moved = true;
        while moved
            %fprintf('Node loop\n');
            moved = false;

            % Create list of nodes to inspect
            l = 1:length(adj);

            % While the list of candidates is not finished
            while ~isempty(l)

                % Pick at random a node n from l and remove it from l
                idx = randi(length(l));
                n = l(idx);
                l(idx) = [];

                % Find neighbour communities of n
                %ncom = unique(com(Nbs{n}));%
                ncom=unique(com);
                ncom(ncom == com(n)) = []; % remove the community of the current node
                % For each neighbour community of n
                best_dQ = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                nb = Nbs{n};
                nb1 = nb(com(nb) == com(n));
                sum_nb1 = -sum(adj(n,nb1));
                wp1 = wcomp(com(n)) - dp(n);
                wn1=wcomn(com(n))-dn(n);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                for i=1:length(ncom)
                    % Compute dQ for moving n to current community
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    c = ncom(i);
                    
                    nb2 = nb(com(nb) == c);
                    dQ = sum_nb1+sum(adj(n,nb2));
                    if mn2>0
                    dQ = (dQ + (dp(n)*(wp1-wcomp(c)))/mp2-(dn(n)*(wn1-wcomn(c)))/mn2)/m;
                    else 
                        dQ = (dQ + (dp(n)*(wp1-wcomp(c)))/mp2)/m;
                    end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % If positive, keep track of the best
                    if dQ > best_dQ+eps
                        best_dQ = dQ;
                        new_c = ncom(i);
                    end
                end

                % If a move is worth it, do it
                if best_dQ > 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % Update total weight of communities
                    wcomp(com(n)) = wcomp(com(n)) - dp(n);
                    wcomn(com(n))=wcomn(com(n))-dn(n);
                    wcomp(new_c) = wcomp(new_c) + dp(n);
                    wcomn(new_c)=wcomn(new_c)+dn(n);
                    wcom=wcomp-wcomn;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % Update community of n
                    com(n) = new_c;
                    % Update Q
                    Q = Q + best_dQ;
% Debug code: check Q computed by adding dQs is accuarate
%                     eqQ = compute_Q(adj, com, m2, d);
%                     if abs(Q - eqQ) >= 0.00001
%                         fprintf('Warning: found Q=%f, should be Q=%f. Diff = %f\n',Q, eqQ, abs(Q-eqQ));
%                     end
                    % A move occured
                    moved = true;
                    check_communities = true;
                end

            end

        end % Nodes
        check_nodes = false;
            
        if ~check_communities
            break;
        end

        % Community merging
        moved = true;
        while moved
            %fprintf('Community loop\n');
            moved = false;

            % Create community list cl
            cl = unique(com);

            % While the list of candidates is not finished
            while ~isempty(cl)

                % Pick at random a community cn from cl and remove it from cl
                idx = randi(length(cl));
                cn = cl(idx);
                cl(idx) = []; 

                % Find neighbour communities of cn
                ncn = find(com==cn);
                nbn = unique([Nbs{ncn}]);%sum(adj(idx,:) ~= 0,1) ~= 0;
                ncom = unique(com(nbn));
                ncom(ncom == cn) = [];
                    
                % For each neighbour community of cn
                best_dQ = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                sum_dpn1 = sum(dp(ncn));
                sum_dnn1 = sum(dn(ncn));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                for ncom_idx=1:length(ncom)
                    % Compute dQ for merging cn with current community
                    %dQ = com_dQ(adj,com,cn,ncom(ncom_idx),m2,d);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    n2 = (com==ncom(ncom_idx));
                    if mn2>0
                    dQ = (sum(sum(adj(ncn,n2))) - sum_dpn1*sum(dp(n2))/mp2+sum_dnn1*sum(dn(n2))/mn2)/m;
                    else
                     dQ = (sum(sum(adj(ncn,n2))) - sum_dpn1*sum(dp(n2))/mp2)/m;
                    end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % If positive, keep track of the best
                    if dQ > best_dQ+eps
                        best_dQ = dQ;
                        new_cn = ncom(ncom_idx);
                    end
                end

                % If a move is worth it, do it
                if best_dQ > 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % Update total weight of communities
                    wcomp(new_cn) = wcomp(new_cn) +wcomp(cn);
                    wcomp(cn) = 0;
                    wcomn(new_cn) = wcomn(new_cn) + wcomn(cn);
                    wcomn(cn) = 0;
                    wcom=wcomp-wcomn;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % Merge communities
                    com(ncn) = new_cn;
                    % Update Q
                    Q = Q + best_dQ;
% Debug code: check Q computed by adding dQs is accuarate
%                     eqQ = compute_Q(adj, com, m2, d);
%                     if abs(Q - eqQ) >= 0.00001
%                         fprintf('Warning: found Q=%f, should be Q=%f. Diff = %f\n',Q, eqQ, abs(Q-eqQ));
%                     end
                    % A move occured
                    moved = true;
                    check_nodes = true;
                end

            end

        end % Communities
        check_communities = false;

    end % while changes can be made
    
    if Q>QQ
        QQ=Q;
    
    % Reindexing communities
    ucom = unique(com);
    for i=1:length(com)
        com(i) = find(ucom==com(i));
    end
    com = com';
    comq=com;
    end;
   end;

%end


