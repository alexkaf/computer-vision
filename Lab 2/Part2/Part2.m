%% PART TWO
% Empty the workspace.
    clear variables
    
% Load the path of Part1.
    addpath(genpath('../Part1'));
    
% At first load the sample images to calulate the mean and covariance.
    load ../cv18_lab2_material/skinSamplesRGB.mat
    dataset = skinSamplesRGB;
    
% Calculate the mean and covariance of the dataset.
    [mean_CbCr, cov_CbCr] = fitParameters(dataset);

%% use this code for just one frame!!

% %Load two consecutive frames and locate the face on the first.
%     I1 = imread('../cv18_lab2_material/GreekSignLanguage/1.png');
%     I2 = imread('../cv18_lab2_material/GreekSignLanguage/2.png');
%    
%     [x1, y1, w1, h1] = fd(I1,mean_CbCr,cov_CbCr);
%     face1 = I1((round(y1):round(y1+h1)),(round(x1)):(round(x1+w1)),:);
%     face2 = I2((round(y1):round(y1+h1)),(round(x1)):(round(x1+w1)),:);
% %Turn the images to grayscale and normalize them.
%     face1 = im2double(rgb2gray(face1));
%     face2 = im2double(rgb2gray(face2));
%     
% %Set the parameter values for the Lucas-Kanade Algorithm.
%     rho = 5;
%     epsilon = 0.1;
%     d_x0 = 0 * face1;
%     d_y0 = 0 * face2;
% 
% %Use the algorithm to locate optical flow on the two frames.
%       [d_x, d_y] = lk(face1,face2,rho,epsilon,d_x0,d_y0); 
%       displ(d_x, d_y);
%       
%       d_x_r = imresize(d_x,0.3);
%       d_y_r = imresize(d_y,0.3); 
%       
%       figure(2)
%       quiver(-d_x_r, -d_y_r);
%       title("Optical Flow");
%       q.LineWidth = 0.8;
%       set(gca,'DataAspectRatio',[1 1 1])
%       axis ij;
      
%% use this code for all frames!      
      
%Repeat the process for each picture and save the results.
tic;
      for counter = 1:65
          path1= strcat('../cv18_lab2_material/GreekSignLanguage/',int2str(counter),'.png');
          path2 = strcat('../cv18_lab2_material/GreekSignLanguage/',int2str(counter+1),'.png');
          I1 = imread(path1);
          I2 = imread(path2);
          [x1, y1, w1, h1] = fd(I1,mean_CbCr,cov_CbCr);
          face1 = I1((round(y1):round(y1+h1)),(round(x1)):(round(x1+w1)),:);
          face2 = I2((round(y1):round(y1+h1)),(round(x1)):(round(x1+w1)),:);
          face1 = im2double(rgb2gray(face1));
          face2 = im2double(rgb2gray(face2));
          
          rho = 5;
          epsilon = 0.01;
          d_x0 = 0 * face1;
          d_y0 = 0 * face2;
          [d_x, d_y] = lk(face1,face2,rho,epsilon,d_x0,d_y0);
          
          
          [displ_x, displ_y] = displ(d_x, d_y);
          name1=strcat('../Data/Energy_Flows/Energy_Optical_Flow',int2str(counter));
%           saveas(1,name1,'png');
          
          
          d_x_r = imresize(d_x,0.3);
          d_y_r = imresize(d_y,0.3);
          figure(2)
          quiver(-d_x_r, -d_y_r);
          title("Optical Flow");
          q.LineWidth = 0.8;
          set(gca,'DataAspectRatio',[1 1 1]);
          axis ij;
          name2=strcat('../Data/Optical_Flows/Optical_Flow',int2str(counter));
%           saveas(2,name2,'png');
      end
toc;