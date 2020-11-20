function plot_D(D,order)
% plot_D(D,leafOrder)

d2=catpad(2,D{:});
imagesc(d2(order,:))
x=0;
for i=1:size(D,2);
    x=x+size(D{1, i},2);
    xline(x,'r','LineWidth',2)
end