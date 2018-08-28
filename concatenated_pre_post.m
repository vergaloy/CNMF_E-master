%pre_vid=h5read('C:\Users\SSG Lab\Desktop\lab\recording_20180307_091625.hdf5','/images');
%post_vid=h5read('C:\Users\SSG Lab\Desktop\lab\recording_20180307_091625.hdf5','/images')


for i=1:size(pre_vid,1)
    for r=1:size(pre_vid,2)
    trace=pre_vid(i,r,:);
    trace=double(trace);
    temp=medfilt1(trace,200);
    trace=(trace-temp);
    trace=mat2gray(trace);
    trace=trace*30000;
    trace=uint16(trace);
    pre_vid2(i,r,1:size(pre_vid,3))=trace;
    end
end
    