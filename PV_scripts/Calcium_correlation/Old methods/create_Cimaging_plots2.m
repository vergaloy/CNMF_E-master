function create_Cimaging_plots2(obj,sf)
% e.g create_Cimaging_plots2(sleepdata,5.02)
if nargin<1
    obj=sleepdata;
end

bin=sf*10;
bin_hist=3;
w=moving_mean(obj.wake,bin,1,size(obj.wake,2)/2000,0);
n=moving_mean(obj.nrem,bin,1,size(obj.nrem,2)/2000,0);
r=moving_mean(obj.rem,1,1,1,0);
S=[w r n];
S(S<0.01)=0;

dw=movmean(sum(w,1),bin_hist);
dn=movmean(sum(n,1),bin_hist);
dr=movmean(sum(r,1),bin*bin_hist);
D=[dw dr dn];
figure;
set(gcf, 'Position',  [200, 500, 1500, 400]);
h1=subplot(2,1,1);
imagesc(S);
caxis([0 1]);
colormap('hot');

hold on
x1=size(w,2);
x2=size(w,2)+size(r,2);
y1=0;
y2=2*size(obj.wake,1)+1;
x = [x1, x2, x2, x1, x1];
y = [y1, y1, y2, y2, y1];
plot(x, y, 'b-', 'LineWidth', 1);
h2=subplot(2,1,2);
area(D);
hold on
x1=size(w,2);
x2=size(w,2)+size(r,2);
y1=0;
y2=max(D);
x = [x1, x2, x2, x1, x1];
y = [y1, y1, y2, y2, y1];
plot(x, y, 'b-', 'LineWidth', 1);
xlim([0 size(D,2)])

%%export_fig Results.pdf -append;