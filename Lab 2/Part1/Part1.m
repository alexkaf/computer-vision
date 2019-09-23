%% PART ONE
% In this part we want to create a moving rectangle of not standard shape
% that best follows the face of a woman communicating in the sign language.
% In order to do so we model the skin colors on the space of YCbCr and
% calculate the parameters of a 2D-Gaussian that corresponds to the
% distributions of those colors in our dataset. 

% Clear the workspace.
    clear variables
    
% Load the dataset.
    load '../cv18_lab2_material/skinSamplesRGB'
    dataset = skinSamplesRGB;
    
% Calculate the mean and covariance of the dataset.
    [mean_CbCr, cov_CbCr] = fitParameters(dataset);
    
% Save the parameters.
    save ../Data/meancov mean_CbCr cov_CbCr
    
% Load each image and locate the face.
    filename = '../cv18_lab2_material/GreekSignLanguage/';
    tic;
    
    % We were given 66 frames so we make 66 repetitions.
    for i = 1:66
        name = strcat(filename,int2str(i),'.png');
        I = imread(name);
        % Apply the function fd that calculates the dimensions of the
        % moving rectangle.
            [x, y, width, height] = fd(I,mean_CbCr,cov_CbCr);
            
        % Illustrate the results showing the image with the corresponding
        % rectangle on the face of the woman.
            figure(1)
            imshow(I);
            title_tmp = strcat('frame ',int2str(i));
            title(title_tmp);
            hold on;
            face = rectangle('Position',[x y width height]);
            face.EdgeColor = 'g';
            face.LineWidth = 0.2;
            hold off;
            pause(0.05);
        %save figure as png at folder Data/Cutted_Frames
            %saveto = strcat('../Data/Cutted_Frames/',title_tmp);
            %saveas(1,saveto,'png');
    end
    toc;