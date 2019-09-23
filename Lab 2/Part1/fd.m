%% FUNCTION fd
% This function finds the box in which the face of the person we
% examine is located.
function [x, y, width, height] = fd(I, mu, cov)
   
    % At first, normalize the image and convert it from RGB to YCbCr 
    % and delete the Y coefficient.
        
        I = rgb2ycbcr(I);
        I = im2double(I);
        I = I(:,:,2:3);

    % Save the dimensions of the given image.
        x_dim = size(I,1);
        y_dim = size(I,2);
        
    % Then reshape the image.
        I_Cb = reshape(I(:,:,1), [1, x_dim * y_dim]);
        I_Cr = reshape(I(:,:,2), [1, x_dim * y_dim]);
        
    % Then decide if each pixel could be a part of skin.
        skin = mvnpdf([I_Cb' I_Cr'], mu, cov);   
        

    % Refold the image in its original shape.
        I = reshape(skin,[x_dim, y_dim]);
%         
%         figure(2)
%         imshow(I)
%         title('Image of Skin Probability');
    % Then use a threshold to make it in a binary form and only keep the
    % pixels that could really represent skin.
        threshold = 0.2;
        I = (I >= threshold);
        
%         figure(3)
%         imshow(I)
%         title('Binary Skin Image before Morphological Processing');
        
    
    % Use opening and closing in order to separate different groups and
    % fill some holes created by distracting elements such as shadows,
    % clothes, eyes, other skin parts except for the skin, etc.
        B = strel('disk',27);
        I = imopen(I,B);
        B = strel('disk',50);
        I = imclose(I,B);
        
    % Locate the unconnected areas and label them.
        I = bwlabel(I);
        
%         figure(4)
%         imshow(I)
%         title('Binary Skin Image after Morphological Processing');
%         pause(0.05);
    
    % Find the biggest area and keep only this in the image.
        areas = regionprops(I,'Area');
        areas_sizes = struct2array(areas);
        max_area = find(areas_sizes == max(areas_sizes));
        I = (I == max_area);
        
    % Find the rectangle parameters in order to locate the face.
        face = regionprops(I,'BoundingBox');
        temp = face.BoundingBox;
        x = temp(1);
        y = temp(2);
        width = temp(3);
        height = temp(4);
       
end