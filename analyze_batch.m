function analyze_batch()
myFolder = 'C:\Users\Galoy\Desktop\Baseline Data\DS\All files';
cd(myFolder)

% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end

filePattern = fullfile(myFolder, '*.mat'); % Change to whatever pattern you need.
theFiles = dir(filePattern);
for k=1:length(theFiles)
  tic
  clearvars -except filePattern theFiles k myFolder
  close all
  baseFileName = theFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  path = get_fullname(fullFileName); 
  load(path);
  clc;
  Get_CaImaging_stats(neuron,hypno,baseFileName(1:end-4));
  
end

