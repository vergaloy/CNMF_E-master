function [Y,stress]=PVD_bootstrap(C,sim)
%    [PVD,s]=PVD_bootstrap(C,100);

MS=PVD_matrix(C);
X=mdscale(MS,2);



X=X(:,1:2);
X=X-mean(X);

stress(1:sim)=0;
for s=1:sim
    s
    r=datasample(1:size(C{1, 1},1),size(C{1, 1},1));
    for i=1:size(C,2)
        sur{i}=C{1, i}(r,:);
    end
    bootstrap_sample=PVD_matrix(sur);
    try
        [temp,stress(s)]=mdscale(bootstrap_sample,2);
    catch
        dummy=1
    end
    try
        Y(:,:,s)=align_matrix(X,temp(:,1:2));
    catch
        dummy=2;
    end
end


figure
set(gca,'Color','k')
hold on
colors = distinguishable_colors(size(Y,1),'k');
conditions={'HC','pre-shock','post-shock','A','C'};
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












