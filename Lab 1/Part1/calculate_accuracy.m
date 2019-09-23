%% calculate_accuracy(edges_0,edges_x): Calculates the accuracy of our model.
% With this function we calculate a percentage that shows the similarity
% between the not noisy image edges and the edges resulted from our own
% EdgeDetect function.

function C = calculate_accuracy(edges_0,edges_x)
    % We calculate the precision and the recall of our model according to
    % the formulas that were given in the lab paper.
        DT = edges_0 & edges_x;
        Precision = sum(DT(:,:))/sum(edges_0(:,:));
        Recall = sum(DT(:,:))/sum(edges_x(:,:));
        K1 = sum(sum(DT(:,:)));
        K2 = sum(sum(edges_0(:,:)));
        K3 = sum(sum(edges_x(:,:)));
        C = (Precision + Recall)./2;
end