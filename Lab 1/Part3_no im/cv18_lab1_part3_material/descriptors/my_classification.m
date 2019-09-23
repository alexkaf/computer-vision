%% my_classification(...): This function is used in order to use a classifiers.
% We make this function in order to run several classfiers multiple times
% without making many new scripts.
function result = my_classification(class_function,descriptor_function)
    % At first, we will use the class_function and the descriptor_function
    % in order to extract the features from our dataset.
        features = FeatureExtraction(class_function,descriptor_function);
        
    % Then we will run the classification code from classification.m to
    % create our model.
        addpath(genpath('libsvm-3.17'));
        parfor k=1:5
            %% Split train and test set
            [data_train,label_train,data_test,label_test]=createTrainTest(features,1);
            %% Bag of Words
            [BOF_tr,BOF_ts]=my_BoVW(data_train,data_test);
            %% SVM classification
            [percent(k),~] = svm(BOF_tr,label_train,BOF_ts,label_test);
            fprintf('Classification Accuracy: %f %%\n',percent(k)*100);
        end
        fprintf('Average Classification Accuracy: %f %%\n',mean(percent)*100);
        result = mean(percent)*100;
end