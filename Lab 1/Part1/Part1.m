%% PART ONE - EDGE DETECTION
% In this part we will detect the edges of noisy images and then we will
% compare the results with the edges of a non noisy image in order to find
% the best parameters combination that maximizes the success percentage.
clear variables;

%% Part 1.1 - Image Loading and Creating the noisy image

% 1.1.1 - Read the image and normalize its pixel values between 0 and 1
image_original = imread('alex.jpg');
image_original = rgb2gray(image_original);
image = im2double(image_original);

% 1.1.2 - Add some noise to the image. In order to do so, we will make a
% function called add_noise.
    % Add white gaussian noise with zero mean and standard deviation s in
    % order to achieve the desired PSNR.
    desired_psnr = [10 20];
    image_psnr10 = add_noise(image,desired_psnr(1));
    image_psnr20 = add_noise(image,desired_psnr(2));

edges_10 = EdgeDetect(image_psnr10,4,0,0.2);
edges_10_nlinear = EdgeDetect(image_psnr10,4,1,0.2);
edges_20 = EdgeDetect(image_psnr20,1.5,0,0.2);
edges_20_nlinear = EdgeDetect(image_psnr20,1.5,1,0.2);

%% Part 1.3 - Predicting the accuracy of our methods.

% 1.3.1 - With function real_edges we find the edges of the original image
% without any noise added.
    edges_0 = real_edges(image,0.2);

% 1.3.2 - With function calculate_accuracy we calculate the similarity
% between the image we created and the original, not noisy, image.
    C_10 = calculate_accuracy(edges_0,edges_10);
    C_20 = calculate_accuracy(edges_0,edges_20);

% 1.3.3 - With function tune_params we choose the best parameters
% combination that maximizes our similarity percentage. First, we set the
% range of our variables:
    desired_psnr = [10 20 30];
    desired_sigma = 0.2:0.2:4;
    filtering_type = [0 1];
    desired_th_edge = 0.05:0.025:0.3;
    best_params = tune_params(image,desired_psnr,desired_sigma,filtering_type,desired_th_edge);
    
% Plotting the resulting images with the edges in a single figure.
    figure(1);
    subplot(1,2,1);
    imshow(image);
    title('Original Image');
    subplot(1,2,2);
    imshow(real_edges(image,0.2));
    title('Real Edges');
    
    figure(2);
    subplot(1,2,1);
    imshow(image_psnr10);
    title('PSNR = 10dB');
    subplot(1,2,2);
    imshow(EdgeDetect(image_psnr10,best_params(1,2),best_params(1,3),best_params(1,4)));
    title('Best tuning');

    figure(3);
    subplot(1,2,1);
    imshow(image_psnr20);
    title('PSNR = 20dB');
    subplot(1,2,2);
    imshow(EdgeDetect(image_psnr20,best_params(2,2),best_params(2,3),best_params(2,4)));
    title('Best tuning');
    pause(5);
    
%% Part 1.4 - Venice Example
% We repeat the previous process, but now with a more complicated image of
% Venice.

% 1.4.1 - First, we load the image and find the edges without noise.
    close all;
    image_original = imread('venice1_edges.png');
    image = im2double(image_original);   
    edges_0 = real_edges(image,0.2);

% 1.4.2 - Tune the parameters to find the best result.
    desired_psnr = [10 20 30];
    desired_type = [0 1];
    desired_sigma = 0.2:0.1:4;
    desired_th_edge = 0.025:0.025:0.4;
    best_params = tune_params(image,desired_psnr,desired_sigma,desired_type,desired_th_edge);
