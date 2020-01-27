function h5=detrend_PV(h5);
h5=double(h5);
t=imgaussfilt(h5,10);
t=median(median(t,1),2);
t=squeeze(movmedian(t,500));

for i=1:size(h5,3)
    h5(:,:,i)=h5(:,:,i)-t(i);
end

h5=h5-min(h5,[],'all');
h5=(h5./max(h5,[],'all'))*65000;
h5 = cast(h5,'uint16');





