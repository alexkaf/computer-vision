clear; clc;
addpath(genpath('libsvm-3.17'));
addpath(genpath('../cv18_lab1_part3_material/detectors'));
addpath(genpath('../cv18_lab1_part3_material/descriptors'));
addpath(genpath('../cv18_lab1_part3_material/matching'));
addpath(genpath('../cv18_lab1_part3_material/classification'));

%% Feature Extraction
% add here your detector/descriptor functions i.e.
%     sigma = 2;
%     p = 2.5;
%     k = 0.05;
%     th_corn = 0.005;
%     s = 1.5;
%     N = 4;
%     
% detector_func = @(I) harris_stephens(I,sigma,p,k,th_corn);
% descriptor_func = @(I,points) featuresSURF(I,points); 
% 
% features = FeatureExtraction(detector_func,descriptor_func);

%% Image Classification
parfor k=1:5
    %% Split train and test set
    [data_train,label_train,data_test,label_test]=createTrainTest(features,1);
    %% Bag of Words
    [BOF_tr,BOF_ts]=my_BoVW(data_train,data_test);
    %% SVM classification
    [percent(k),KMea] = svm(BOF_tr,label_train,BOF_ts,label_test);
    fprintf('Classification Accuracy: %f %%\n',percent(k)*100);
end
fprintf('Average Classification Accuracy: %f %%\n',mean(percent)*100);