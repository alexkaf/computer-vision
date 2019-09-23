%% PART 2.5 - one_scale_im(...): A function to accelerate the previous processes.
% With this function we can locate the interest points using a different
% approach with integral images and box filters.
function Lxx = one_scale_im(image,sigma)
    % Part 2.5.1 - Calculate the integral image.
        int_image = integralImage(image);
  
    % Part 2.5.2 - Find the Box Filters dimensions and pad the image in
    % order to accelerate the calculations.
        n = 2*ceil(3*sigma) + 1;
        Dxx_x = 2 * floor(n/6) + 1;
        Dxx_y = 4 * floor(n/6) + 1;
        Dyy_x = 4 * floor(n/6) + 1;
        Dyy_y = 2 * floor(n/6) + 1;
        Dxy_x = 2 * floor(n/6) + 1;
        Dxy_y = 2 * floor(n/6) + 1;
    
    % Then we pad the images and calculate the inner space.
        hor_pad = floor(Dxx_x/2) + 1;
        vert_pad = floor(Dxx_y/2) + 1;
        
        % First for A.
        A_image = zeros(size(int_image,1)+hor_pad,size(int_image,2)+vert_pad);
        A_image(1:size(int_image,1),1:size(int_image,2)) = int_image(:,:);
        
        % Then for B.
        B_image = zeros(size(int_image,1)+hor_pad,size(int_image,2)+vert_pad);
        B_image(hor_pad+1:size(B_image,1),1:size(int_image,2)) = int_image(:,:);
        
        % Then for C.
        C_image = zeros(size(int_image,1)+hor_pad,size(int_image,2)+vert_pad);
        C_image(hor_pad+1:size(C_image,1),vert_pad+1:size(C_image,2)) = int_image(:,:);
        
        % Finally for D.
        D_image = zeros(size(int_image,1)+hor_pad,size(int_image,2)+vert_pad);
        D_image(1:size(int_image,1),vert_pad+1:size(D_image,2)) = int_image(:,:);
        
        final = A_image + C_image - B_image - D_image;
        Lxx = imfilter(final,[1 1 1 -2 -2 -2 1 1 1; 1 1 1 -2 -2 -2 1 1 1; 1 1 1 -2 -2 -2 1 1 1]);
        % Now it is time to filter the image for the Lxx.
%         split_x = ceil(Dxx_x/3);
%         split_y = Dxx_y;
%         for i = hor_pad+1:size(int_image,1)
%             for j = vert_pad+1:size(int_image,2)
%                 Lxx = final(
%             end
%         end
        
end