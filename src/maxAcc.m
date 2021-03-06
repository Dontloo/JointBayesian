% compute the maximun accuracy we can get by chosing a particular boundary.
% 1. sort x and y accordingly
% 2. compute the accuracy at each point using dp ( max(l+r)
% 3. find a maximum theshold and accuracy
% time complexity O(nlogn)
function [acc,thres] = maxAcc(x,y)
    [x_sorted,idx] = sort(x);
    y_sorted = y(idx); % sorted labels
    
    n = size(x,1);
    l = zeros(n+1,1); % number of zeros from left
    r = zeros(n+1,1); % number of ones from right    
    
    ctr_0 = 0;
    ctr_1 = 0;
    for i=1:n        
        ctr_0 = ctr_0 + 1-y_sorted(i);
        l(i+1) = ctr_0;
                
        ctr_1 = ctr_1 + y_sorted(n-i+1);  
        r(n-i+1) = ctr_1;
    end
    
    [~,idx] = max(l+r);
    thres = x_sorted(idx);
    acc = sum(y==(x>=thres))/n; % threshold value must be included
end

