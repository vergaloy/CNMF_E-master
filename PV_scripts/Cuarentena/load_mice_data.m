function data=load_mice_data()
filePattern = fullfile(uigetdir, 'DM*.mat');
theFiles = dir(filePattern);

for i=1:size(theFiles,1)
 data{i,1} = load(fullfile(theFiles(i).folder, theFiles(i).name));
end