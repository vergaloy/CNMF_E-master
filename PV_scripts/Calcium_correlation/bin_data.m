function M=bin_data(A,sf,binsize,shift,remove_small_transients)
%sleepdata.mean.wake=bin_data(sleepdata.wake,5,1,0.25,0);

if remove_small_transients==1
    thr=std(A,[],2)*1;
    A(A<thr)=0;
end

k=binsize*round(sf);
M = movmean(A,k,2,'Endpoints',0).*round(k);
n=ceil(shift*sf);
M = (downsample(M',n))';
%M(M<0.01)=0;