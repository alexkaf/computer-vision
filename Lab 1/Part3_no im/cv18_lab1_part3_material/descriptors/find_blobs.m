%% PART 2.3 - find_blobs(..): A funtion that locates blobs
% In this part we will use the Hessian array in order to apply a criterion
% for blobs detection.
function blobs = find_blobs(image,sigma,th_corn)
    % Part 2.3.1 - At first, we calculate the determinant of the 
    % Hessian array.
        ns = 2*ceil(3*sigma) + 1;
        HSIZE = [ns ns];
        Gs = fspecial('gaussian',HSIZE,sigma);
        Is = imfilter(image,Gs,'symmetric');
        [Lx,Ly] = imgradientxy(Is);
        [Lxx,Lxy] = imgradientxy(Lx);
        [~,Lyy] = imgradientxy(Ly);
        R = Lxx .* Lyy - Lxy .^2;
  
    % Part 2.3.2 - In order to find the blobs, we use a way similar to
    % Harris-Stephens criterion.
        ns = ceil(3*sigma)*2 + 1;
        B_sq = strel('disk',ns);
        Cond1 = (R == imdilate(R,B_sq));
        Cond2 = (R > th_corn * max(max(R)));
        blobs = Cond1 & Cond2;
        [row,column] = find(blobs == 1);
        sigmas(1:size(row,1),1) = sigma;
        blobs = [column row sigmas];        
end