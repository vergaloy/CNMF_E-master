function out=creat_wave_random_freq(f)
% out=creat_wave_random_freq(80);

f1_range=randn(1,f)+f;
f1=f1_range(randi([1 size(f1_range,2)],1,size(f1_range,2)));


A=1;
out=0;
for k=1:numel(f1)
    y1c=A*sin(2*pi/f1(k)*(0:0.01:f1(k)));
    out=[out y1c];
end
out=resample(out,1000,numel(out));

end