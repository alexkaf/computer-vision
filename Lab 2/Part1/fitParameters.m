%% FUNCTION calculateParameters
% This function takes a dataset as input and calculates the mean and the
% covariance matrix of a 2D-Gaussian that corresponds to the distrubution
% of the color of the skin pixels. In order to calculate the parameters 
% were given a dataset of skin pixels in RGB. We transformed the color
% space to YCbCr and ignored the parameter Y because it is not helpful in
% the skin recognition task. Hence, mean is a 1x2 vector and cov is a 2x2
% matrix.
function [mean_CbCr, cov_CbCr] = fitParameters(dataset)

    % At first we will convert the RGB colors to YCbCr.
        YCbCr_image = rgb2ycbcr(dataset);

    % Keep the Cb Cr channels.
        image = im2double(YCbCr_image(:,:,2:3));

    % Reshape the images in order to use mean function.
        Cb_1D = reshape(image(:,:,1),[1 size(image(:,:,1),1)*size(image(:,:,1),2)]);
        Cr_1D = reshape(image(:,:,2),[1 size(image(:,:,2),1)*size(image(:,:,2),2)]);

    % Calculate the mean of Cb and Cr.
        mean_CbCr = [mean(Cb_1D) mean(Cr_1D)];

    % Calculate the covariance matrix.
        cov_CbCr = cov(Cb_1D, Cr_1D);

end