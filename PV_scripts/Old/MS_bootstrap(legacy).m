function [MS]=MS_bootstrap(Wmatrix,sim)
%[MS]=MS_bootstrap(W,1000)

CM=get_CM(Wmatrix);
MS=CM2MS(CM);
X=cmdscale(MS,2);
X=X(:,1:2);
X=X-mean(X);


for s=1:sim
r=datasample(1:size(CM,1),size(CM,1));
bootstrap_sample=CM2MS(CM(r,r,:));
temp=cmdscale(bootstrap_sample,2);
Y(:,:,s)=align_matrix(X,temp(:,1:2));
end


figure
set(gca,'Color','k')
hold on
colors = distinguishable_colors(size(Y,1),'k');
conditions={'Hc','training','A','C','B'};
for i=1:size(Y,1)
    a=ErrorEllipse(squeeze(Y(i,:,:)));
    h1=patch(a(1,:),a(2,:),colors(i,:));
    alpha(h1,0.5)
    text(Y(i,1)+0.02,Y(i,2)+0.005,conditions(i),'color',colors(i,:),'FontSize',14);
    uistack(h1,'bottom')
end   

figure
hold on
for i=1:size(Y,1)
scatter(squeeze(Y(i,1,:)),squeeze(Y(i,2,:)),'.');
end   

    
    
    








