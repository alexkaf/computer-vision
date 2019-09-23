%% PART THREE - MATCHING AND CATEGORIZATION OF IMAGES
% In this part, we use the methods we made previously in order to achieve
% an image categorization and matching.
clear variables;

%% Part 3.1 - Matching Images with Rotation and Scaling
% At first, we add the paths and load the image files.
    addpath(genpath('cv18_lab1_part3_material/matching'));

% Part 3.1.1 & 3.1.2 - Here we will guess the rotation and scaling of the 
% images in our dataset using the matching_evaluation function.
% At first, we add the detectors and descriptors path in out script.
    addpath(genpath('cv18_lab1_part3_material/detectors'));
    addpath(genpath('cv18_lab1_part3_material/descriptors'));
    
% We then make our lambda functions and use then in featureSURF and 
% featureHOG given functions.
    sigma = 2;
    p = 2.5;
    k = 0.05;
    th_corn = 0.005;
    s = 1.5;
    N = 4;
    sc_error = cell(2,4);
    th_error = cell(2,4);
% First for Harris-Stephens method.
    tic;
    detector_func = @(image) harris_stephens(image,sigma,p,k,th_corn);
    descriptor_func = @(image,points) featuresSURF(image,points);
    [sc_error{1,1},th_error{1,1}] = evaluation(detector_func,descriptor_func);
    toc;

% Then for Harris-Laplacian
    tic;
    detector_func = @(image) harris_laplacian(image,s,sigma,p,k,th_corn,N);
    descriptor_func = @(image,points) featuresSURF(image,points);
    [sc_error{1,2},th_error{1,2}] = evaluation(detector_func,descriptor_func);
    toc;

% Then with find_blobs
    tic;
    detector_func = @(image) find_blobs(image,sigma,th_corn);
    descriptor_func = @(image,points) featuresSURF(image,points);
    [sc_error{1,3},th_error{1,3}] = evaluation(detector_func,descriptor_func);
    toc;

% Multiscale blobs
    tic;
    detector_func = @(image) find_blobs_ms(image,s,sigma,th_corn,N);
    descriptor_func = @(image,points) featuresSURF(image,points);
    [sc_error{1,4},th_error{1,4}] = evaluation(detector_func,descriptor_func);
    toc;
    
% Multiscale approach with box filters.
    tic;
    detector_func = @(image) box_det_multiscale(image,sigma,s,th_corn,N);
    descriptor_func = @(image,points) featuresSURF(image,points);
    [sc_error{1,5},th_error{1,5}] = evaluation(detector_func,descriptor_func);
    toc;
    
% Repeat process but this time using HOG method.
% First for Harris-Stephens method.
    tic;
    detector_func = @(image) harris_stephens(image,sigma,p,k,th_corn);
    descriptor_func = @(image,points) featuresHOG(image,points);
    [sc_error{2,1},th_error{2,1}] = evaluation(detector_func,descriptor_func);
    toc;

% Then for Harris-Laplacian
    tic;
    detector_func = @(image) harris_laplacian(image,s,sigma,p,k,th_corn,N);
    descriptor_func = @(image,points) featuresHOG(image,points);
    [sc_error{2,2},th_error{2,2}] = evaluation(detector_func,descriptor_func);
    toc;

% Then with find_blobs
    tic;
    detector_func = @(image) find_blobs(image,sigma,th_corn);
    descriptor_func = @(image,points) featuresHOG(image,points);
    [sc_error{2,3},th_error{2,3}] = evaluation(detector_func,descriptor_func);
    toc;

% Multiscale blobs
    tic;
    detector_func = @(image) find_blobs_ms(image,s,sigma,th_corn,N);
    descriptor_func = @(image,points) featuresHOG(image,points);
    [sc_error{2,4},th_error{2,4}] = evaluation(detector_func,descriptor_func);
    toc;

% Multiscale approach with box filters.
    tic;
    detector_func = @(image) box_det_multiscale(image,sigma,s,th_corn,N);
    descriptor_func = @(image,points) featuresHOG(image,points);
    [sc_error{2,5},th_error{2,5}] = evaluation(detector_func,descriptor_func);
    toc;
    
% Save the results so it is not necessary to run the upper script again.
    results{1} = sc_error;
    results{2} = th_error;
    save matching_results results;
    
%% Part 3.2 - Categorization
% In this part, we use the methods described and applied earlier in order
% to classify our images and create the best model.

     get_back = cd('./');
     cd 'cv18_lab1_part3_material/classification';
     addpath(genpath('cv18_lab1_part3_material/classification'));
    
     results_model = cell(2,3);
     
     descriptor_func = @(image,points) featuresSURF(image,points);
     detector_func = @(image) harris_laplacian(image,s,sigma,p,k,th_corn,N);
     results_model{1,1} = my_classification(detector_func,descriptor_func);

     detector_func = @(image) find_blobs_ms(image,s,sigma,th_corn,N);
     results_model{1,2} = my_classification(detector_func,descriptor_func);

     detector_func = @(image) box_det_multiscale(image,sigma,s,th_corn,N);
     results_model{1,3} = my_classification(detector_func,descriptor_func);

     descriptor_func = @(image,points) featuresHOG(image,points);
     detector_func = @(image) harris_laplacian(image,s,sigma,p,k,th_corn,N);
     results_model{2,1} = my_classification(detector_func,descriptor_func);
   
     descriptor_func = @(image,points) featuresHOG(image,points);
     detector_func = @(image) find_blobs_ms(image,s,sigma,th_corn,N);
     results_model{2,2} = my_classification(detector_func,descriptor_func);
     
     descriptor_func = @(image,points) featuresHOG(image,points);
     detector_func = @(image) box_det_multiscale(image,sigma,s,th_corn,N);
     results_model{2,3} = my_classification(detector_func,descriptor_func);
     
     % Save the results because it will take a lot of time to run the model
     % again.
        save models results_model;
        