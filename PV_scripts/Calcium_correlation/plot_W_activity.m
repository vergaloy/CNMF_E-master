function plot_W_activity(X,W,H)

t=size(W,2);
figure
set(gcf, 'Position',  [200, 100, 1500, 900]);
for i=1:t
    temp=X(logical(W(:,i)>0),:);
    h1=subplot(t*2,1,i*2-1);
    imagesc(temp)
    h1=subplot(t*2,1,i*2);
    plot(H(i,:))
    xlim([0 length(H)])
    ylim([0 1])
end