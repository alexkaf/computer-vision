%% Part 3.2.3c - hist(...): A function to calculate the histogram of a word.
% This function will make a histogram for an element.

function bins = hist(features,model)
    % At first, calculate the minimum eucleidian distance of the elements
    % to the centers of the model(clusters).
        distances = eucliddist(features,model);
        [~,idx_min] = min(distances,[],2);
     
    % Then count the frequency of appearance for each word and normalize
    % them according to the L2 norm.
        bins = histc(idx_min,1:size(model,1));
        normL2 = norm(bins,2);
        bins = bins ./ normL2;
end