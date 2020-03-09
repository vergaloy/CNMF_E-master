function M=bin_data(A,sf,binsize);
%sleepdata.mean.wake=moving_mean(sleepdata.wake,5,10,0.5,0);

k=binsize*sf;
blockSize = [1,k];
meanFilterFunction = @(theBlockStructure) mean2(theBlockStructure.data(:));
M = blockproc(A, blockSize, meanFilterFunction);
