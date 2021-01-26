function [out,a,at]=bin_mice_sleep(obj,bin,s)
%  out is the binned data
%  a are the activty vectors 
%  at are the activity vectors normalized to 95% percentil.
sf=5;
if ~exist('s','var')
    s=1:size(obj,2);
end

if ~exist('bin','var')
    bin=1;
end


parfor i=1:length(s)
    temp=obj(:,s(i));
    temp{size(temp,1)+1,1}=[];
    temp=cell2mat(temp);
    out{1,i}=bin_data(temp,sf,bin); 
    a(:,i)=nanmean(out{1,i},2);
end

    k=0;
    at=[];
 for i=1:size(obj,1)
    n=size(obj{i, 1},1);   
    temp=a(k+1:k+n,:);
    temp=temp./prctile(temp,95,1);
    at=[at;temp];
    k=n;
end

end

function M=bin_data(A,sf,binsize)
k=binsize*sf;
blockSize = [1,k];
meanFilterFunction = @(theBlockStructure) mean2(theBlockStructure.data(:));
M = blockproc(A, blockSize, meanFilterFunction);
end
