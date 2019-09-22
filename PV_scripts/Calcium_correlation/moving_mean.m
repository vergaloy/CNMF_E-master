function M=moving_mean(A,binsize,sf,shift,remove_small_transients)
%sleepdata.mean.wake=moving_mean(sleepdata.wake,5,0.25,1,0);

if remove_small_transients==1
    thr=std(A,[],2)*1;
    A(A<thr)=0;
end

k=binsize*sf;
M = movmean(A,k,2);
n=ceil(shift*sf);
M = (downsample(M',n))';
%M(M<0.01)=0;