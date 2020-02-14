function [Y]=PVD_bootstrap(C,sim)
%    [PVD]=PVD_bootstrap(C,1000);

MS=PVD_matrix(C);
X=cmdscale(MS,2);
X=X(:,1:2);
X=X-mean(X);


for s=1:sim
r=datasample(1:size(C{1, 1},1),size(C{1, 1},1));
for i=1:size(C,2)
    sur{i}=C{1, i}(r,:);
end
bootstrap_sample=PVD_matrix(sur);
try
temp=cmdscale(bootstrap_sample,2);
catch
    
    dummy=1
end
Y(:,:,s)=align_matrix(X,temp(:,1:2));
end


figure
set(gca,'Color','k')
hold on
colors = distinguishable_colors(size(Y,1),'k');
conditions={'HC','Pre-Shock','Post-Shock','REM','A','C'};
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

    
    
    








