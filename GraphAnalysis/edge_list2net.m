%--------------------------------------------------------------------------
function net = edge_list2net(edge_list)
% PURPOSE:  Transform an edge list into a network structure
% USAGE:    >> net = edge_list2net(edge_list);
% INPUTS:   edge_list  - Nx2 matrix of nodes where each row represents an edge connection
% OUTPUTS:  net  - network structure containing two fields: 'node' and 'edges'
%                  'node' is the ID of the current node
%                  'edges' is a vector that lists all the nodes connected to 'node'

net = [];
if isempty(edge_list)
    return
end
edge_list = abs(round(real(edge_list)));
ne = size(edge_list);
net(1).node = edge_list(1,1); net(1).edges = edge_list(1,2);
net(2).node = edge_list(1,2); net(2).edges = edge_list(1,1);
for idx = 2:ne(1)
    node_exists = 0;
    % if the node is already part of the net, update the list of edges
    for k = 1:length(net)
        if (edge_list(idx,1) == net(k).node)
            % do not update the edge list if the edge already exists
            if isempty(find([net(k).edges net(k).node] == edge_list(idx,2),1))
                net(k).edges = [net(k).edges edge_list(idx,2)];
            end
            node_exists = 1;
            break
        end
    end
    % if the node is new, add it to the end of the net along with the edge
    if ~node_exists
        net(k+1).node = edge_list(idx,1);
        net(k+1).edges = edge_list(idx,2);
    end
    node_exists = 0;
    % if the node is already part of the net, update the list of edges
    for k = 1:length(net)
        if (edge_list(idx,2) == net(k).node)
            % do not update the edge list if the edge already exists
            if isempty(find([net(k).edges net(k).node] == edge_list(idx,1),1))
                net(k).edges = [net(k).edges edge_list(idx,1)];
            end
            node_exists = 1;
            break
        end
    end
    % if the node is new, add it to the end of the net along with the edge
    if ~node_exists
        net(k+1).node = edge_list(idx,2);
        net(k+1).edges = edge_list(idx,1);
    end
end
