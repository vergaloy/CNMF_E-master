function [trainedClassifier, validationAccuracy] = trainClassifierPV_multiclass(trainingData,showplot)
% [trainedClassifier, validationAccuracy] = trainClassifierPV(Train,1);

% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
inputTable = trainingData;
predictorNames = cell(1,size(inputTable.neuron,2));
for k = 1:size(inputTable.neuron,2)
    predictorNames{k} = sprintf('Neuron_%d', k);
end


% Split matrices in the input table into vectors
inputTable = [inputTable(:,setdiff(inputTable.Properties.VariableNames, {'neuron'})), array2table(table2array(inputTable(:,{'neuron'})), 'VariableNames', predictorNames)];


predictors = inputTable(:, predictorNames);
response = inputTable.context;

% Train a classifier
% This code specifies all the classifier options and trains the classifier.
template = templateSVM(...
    'KernelFunction', 'gaussian', ...
    'PolynomialOrder', [], ...
    'KernelScale', 'auto', ...
    'BoxConstraint', 1, ...
    'Standardize', false);
classificationSVM = fitcecoc(...
    predictors, ...
    response, ...
    'Learners', template, ...
    'Coding', 'onevsone', ...
    'ClassNames', unique(response)');

% Create the result struct with predict function
splitMatricesInTableFcn = @(t) [t(:,setdiff(t.Properties.VariableNames, {'neuron'})), array2table(table2array(t(:,{'neuron'})), 'VariableNames', predictorNames)];
extractPredictorsFromTableFcn = @(t) t(:, predictorNames);
predictorExtractionFcn = @(x) extractPredictorsFromTableFcn(splitMatricesInTableFcn(x));
svmPredictFcn = @(x) predict(classificationSVM, x);
trainedClassifier.predictFcn = @(x) svmPredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainedClassifier.RequiredVariables = {'neuron'};
trainedClassifier.ClassificationSVM = classificationSVM;
trainedClassifier.About = 'This struct is a trained model exported from Classification Learner R2020a.';
trainedClassifier.HowToPredict = sprintf('To make predictions on a new table, T, use: \n  yfit = c.predictFcn(T) \nreplacing ''c'' with the name of the variable that is this struct, e.g. ''trainedModel''. \n \nThe table, T, must contain the variables returned by: \n  c.RequiredVariables \nVariable formats (e.g. matrix/vector, datatype) must match the original training data. \nAdditional variables are ignored. \n \nFor more information, see <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appclassification_exportmodeltoworkspace'')">How to predict using an exported model</a>.');

% Perform cross-validation
TVP={};
TR={};
for i=1:1
partitionedModel = crossval(trainedClassifier.ClassificationSVM, 'KFold', 5);
[validationPredictions, ~] = kfoldPredict(partitionedModel);
TVP=[TVP;validationPredictions];
TR=[TR;response];
validationAccuracy(i) = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');
end

if (showplot)
hold off
confusionchart(categorical(categorical(TR)),categorical(TVP),'RowSummary','row-normalized','ColumnSummary','column-normalized');
end
