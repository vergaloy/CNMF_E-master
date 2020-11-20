function [out,a,at]=bin_mice_sleep(obj,s,bin)
%  [D,a]=bin_mice_sleep(mice_sleep,[4],2);
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
    temp=catpad(1,temp{:});
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

