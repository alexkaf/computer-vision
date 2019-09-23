%% PART THREE 
% In this part we implement a multiscale version of the Lucas-Kanade
% Algorithm described in the previous Part.

% At first, clear the workspace.
    clear variables
    
% Add the path of the Lucas-Kanade implementation.
    addpath(genpath('../Part1'));
    addpath(genpath('../Part2'));
    
% Load the sample images to calulate the mean and covariance.
    load ../cv18_lab2_material/skinSamplesRGB.mat
    dataset = skinSamplesRGB;
    
% Calculate the mean and covariance of the dataset.
    [mean_CbCr, cov_CbCr] = fitParameters(dataset);

% Implement the multiscale Lucas-Kanade for all the consecutive frames.
    for i =1:65
        
        % Make the filenames.
            path1 = strcat('../cv18_lab2_material/GreekSignLanguage/',int2str(i),'.png');
            path2 = strcat('../cv18_lab2_material/GreekSignLanguage/',int2str(i+1),'.png');
       
            
        % Load two consecutive frames and locate the face on the first.
            I1 = imread(path1);
            I2 = imread(path2);

            [x1, y1, w1, h1] = fd(I1,mean_CbCr,cov_CbCr);
            face1 = I1((round(y1):round(y1+h1)),(round(x1)):(round(x1+w1)),:);
            face2 = I2((round(y1):round(y1+h1)),(round(x1)):(round(x1+w1)),:);
        % Turn the images to grayscale and normalize them.
            face1 = im2double(rgb2gray(face1));
            face2 = im2double(rgb2gray(face2));

        % Set the parameter values for the Lucas-Kanade Algorithm.
            rho = 5;
            epsilon = 0.01;
            scales = 5;
        
        % Run the multiscale Lucas-Kanade Algorithm.
            [d_x, d_y] = lk_multiscale(face1,face2,rho,epsilon,scales);
            
            figure(1);
            d_x_r = imresize(d_x,0.3);
            d_y_r = imresize(d_y,0.3);
            quiver(-d_x_r, -d_y_r);
            name = "Optical Flow Mult";
            title(name);
            q.LineWidth = 0.8;
            set(gca,'DataAspectRatio',[1 1 1])
            axis ij;
            name1 = strcat('../Data/Optical_Flow_Multiscale/',name,int2str(i));
%             saveas(1,name1,'png');
    end