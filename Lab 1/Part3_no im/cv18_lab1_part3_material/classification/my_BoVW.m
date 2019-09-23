%% PART 3.2.3 - my_BoVW(...): A function to create a Bag of Visual Words
% This is a model we create in order to classify the given images.

function [BoF_tr,BoF_ts] = my_BoVW(train,test,no_clusters)
    % Part 3.2.3a - At first, we concatenate the descriptors in a single 
    % vector.
    descriptors = cell2mat(train');
    
    % Then we choose around half of them.
    rows_rand = randperm(size(descriptors,1));
    half_descr = descriptors(rows_rand(1:floor(size(descriptors,1)/2)),:);
    
    % Then apply kmeans.
    [~,model] = kmeans(half_descr,no_clusters);
    
    % Part 3.2.3b - Calculate the distance of each data with the clusters
    % made. For each image, produce the appropriate histogram.
        BoF = cellfun(@(x) hist(x,model),train,'UniformOutput',false);
        BoF_tr = cell2mat(BoF)';

        BoF_n = cellfun(@(x) hist(x,model),test,'UniformOutput',false);
        BoF_ts = cell2mat(BoF_n)';
end