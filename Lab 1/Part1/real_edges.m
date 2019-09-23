%% real_edges(image,th_edge): This function locates the edges of original image.
% We use this function in order to find the edges of the original image
% with zero PSNR. This is done in order to calculate the accuracy of our
% methods.
function real_edges = real_edges(image,th_edge)
    % We use B in the same way as we used it in EdgeDetect function.
        B = strel('arbitrary',[0 1 0; 1 1 1; 0 1 0]);
    
    % Now we calculate the real edges in a way vary similar to the
    % EdgeDetect function.
        M = imdilate(image,B) - imerode(image,B);
        real_edges = (M >= th_edge);
   
end