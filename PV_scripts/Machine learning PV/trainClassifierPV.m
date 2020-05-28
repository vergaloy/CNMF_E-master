function [trainedClassifier, validationAccuracy] = trainClassifierPV(trainingData,showplot)
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
splitMatricesInTableFcn = @(t) [t(:,setdiff(t.Properties.VariableNames, {'neuron'})), array2table(table2array(t(:,{'neuron'})), 'VariableNames', {'neuron_1', 'neuron_2', 'neuron_3', 'neuron_4', 'neuron_5', 'neuron_6', 'neuron_7', 'neuron_8', 'neuron_9', 'neuron_10', 'neuron_11', 'neuron_12', 'neuron_13', 'neuron_14', 'neuron_15', 'neuron_16', 'neuron_17', 'neuron_18', 'neuron_19', 'neuron_20', 'neuron_21', 'neuron_22', 'neuron_23', 'neuron_24', 'neuron_25', 'neuron_26', 'neuron_27', 'neuron_28', 'neuron_29', 'neuron_30', 'neuron_31', 'neuron_32', 'neuron_33', 'neuron_34', 'neuron_35', 'neuron_36', 'neuron_37', 'neuron_38', 'neuron_39', 'neuron_40', 'neuron_41', 'neuron_42', 'neuron_43', 'neuron_44', 'neuron_45', 'neuron_46', 'neuron_47', 'neuron_48', 'neuron_49', 'neuron_50', 'neuron_51', 'neuron_52', 'neuron_53', 'neuron_54', 'neuron_55', 'neuron_56', 'neuron_57', 'neuron_58', 'neuron_59', 'neuron_60', 'neuron_61', 'neuron_62', 'neuron_63', 'neuron_64', 'neuron_65', 'neuron_66', 'neuron_67', 'neuron_68', 'neuron_69', 'neuron_70', 'neuron_71', 'neuron_72', 'neuron_73', 'neuron_74', 'neuron_75', 'neuron_76', 'neuron_77'})];
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
