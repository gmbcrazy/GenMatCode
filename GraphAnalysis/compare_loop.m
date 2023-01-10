function status = compare_loop(loop,loop_list)
% PURPOSE:  Check to see if the loop already exists in the loop_list
% USAGE:    >> status = compare_loop(loop,loop_list);
% INPUTS:   loop  - 1xM vector containing nodes that are connected in a loop
%           loop_list  - a structure with one field named 'loop' containing a list
%                        of all previously found loops
% OUTPUTS:  status  - equals 1 if 'loop' already exists,0 otherwise

status = 0;
if isempty(loop_list)
    return
end
for k = 1:length(loop_list)
    m = length(loop_list(k).loop);
    n = length(loop);
    % if the two loops have the same length,check if they are identical
    if (m == n)
        status = 1;
        for kk = 1:n
            if (loop_list(k).loop(kk) ~= loop(kk))
                status = 0;  % loops are different,move on to next
                break
            end
        end
        % loops are identical
        if status
            return
        end
    end
end
