function periodicity(mice_sleep)
sf=5;
bin=1;
tiledlayout('flow')
for i=1:size(mice_sleep,2)
    i
    d_temp=mice_sleep(:,i);
    M=[];
    for j=1:size(d_temp,1)
        t1=d_temp{j};
        t1=bin_data(t1,sf,bin);
        t1=double(t1>0);
        M{j}=cirulcar_corr(sum(t1,1));
    end
    M=catpad(1,M{:});
    C=nanmean(M,1);
    
%     [p,f]=FFT_PV(C,1/bin);
[p2,f]=FFT_PV(thr,1/bin);
    
    thr=get_peaks_thr(d_temp,sf,bin);
    nexttile
    plot(C);hold on; plot(thr);
end


end
function thr=get_peaks_thr(in,sf,bin)
sim=1000;
parfor s=1:sim
    C(s,:)=cell2autocorr_random(in,sf,bin);
%     [C(s,:),~]=FFT_PV(a,1/bin);
end
thr=prctile(C,99,1);
end

function a=cell2autocorr_random(in,sf,bin)

for j=1:size(in,1)
    t1=in{j};
    t1=bin_data(t1,sf,bin);
    t1=sample_from_data(t1,size(t1,2),10);
    t1=double(t1>0);
    M{j}=cirulcar_corr(sum(t1,1));
end
M=catpad(1,M{:});
a=nanmean(M,1);
end


function out=cirulcar_corr(t1)

for i=1:size(t1,1)
    t=t1(i,:);
    out(i,:)=CXCORR(t,t);
end
  
end