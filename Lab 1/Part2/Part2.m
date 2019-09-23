%% PART TWO - INTEREST POINTS DETECTION
% In this part, we will use 5 methods to locate points of interest on an
% image. Those are points that either represent corners or areas that
% differ from their surroundings. Firstly, we load the image with the
% sunflowers.
    clear variables;
    image_original = imread('john.jpg');
    image = rgb2gray(image_original);
    image = im2double(image);
    
%% Part 2.1 - Corner Detection
% In the first part, we will use the Harris-Stephens method to
% locate the corners in the given image. First, we set some parameters that
% will be used.
    sigma = 1.2;
    p = 2.5;
    k = 0.05;
    th_corn = 0.005;
    s = 1.5;
    N = 4;
    
% We create harris_stephens function to find those angles.
    hs_points = harris_stephens(image,sigma,p,k,th_corn);
    %interest_points_visualization(image_original,hs_points);

%% Part 2.2 - Multiscale Corner Detection
% Part 2.2.2 - We use the function harris_laplacian that does a job similar to
% harris_stephens function except for the multiscale approach.
    hl_points = harris_laplacian(image,s,sigma,p,k,th_corn,N);
    %interest_points_visualization(image,hl_points);

%% Part 2.3 - Blobs Detection
% In this part we will use function find_blobs which will locate all the
% image blobs. Blobs are regions that differ from their surroundings.
    blobs = find_blobs(image,sigma,th_corn);
    %interest_points_visualization(image,blobs);

%% Part 2.4 - Multiscale Blobs Detection
% In this part we follow a similar process just like the one in part 2.2
% except the fact that now we use function find_blobs.
    ms_blobs = find_blobs_ms(image,s,sigma,th_corn,N);
    %interest_points_visualization(image,ms_blobs);

%% Part 2.5 - Acceleration using Integral Images
% In this part we use the one_scale_im function to find the interest points
% of the image.
    interest_points = box_det_multiscale(image,sigma,s,th_corn,N);
    %interest_points_visualization(image_original,interest_points);