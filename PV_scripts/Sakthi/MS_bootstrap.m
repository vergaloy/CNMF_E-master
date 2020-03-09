function [Y,stress,MS,X]=MS_bootstrap(W,sim,getMS,boots)  %getMS=0:Forbenius distance, getMS=1: % of patterns with significant MS
%    [Y,stress,MS]=MS_bootstrap(W,100,0,0);
%    [Y_nosleep,stress_nosleep,MS_nosleep]=MS_bootstrap(W_nosleep,100,0);

clear textprogressbar

[F]=MS_matrix(W,getMS);
[MS]=MS_matrix(W,0);
opts = statset('MaxIter',1000);
[X,stress,disparities]=mdscale(F,2,'Criterion','stress','Options',opts);
Shepard_Plot(F,X,disparities,0)
X=X(:,1:2);
X=X-mean(X);
if (boots==1)
    stress(1:sim)=0;
    textprogressbar('Bootstraping: ');
    for s=1:sim
        textprogressbar((s/sim)*100);
        r=datasample(1:size(W{1, 1},1),size(W{1, 1},1));
        for i=1:size(W,2)
            sur{i}=W{1, i}(r,:);
        end
        [bootstrap_sample]=MS_matrix(sur,getMS);
        try
            [temp,stress(s)]=mdscale(bootstrap_sample,2,'Criterion','stress','Options',opts);
        catch
            dummy=1
        end
        Y(:,:,s)=align_matrix(X,temp(:,1:2));
        
    end
    textprogressbar('done');
    
    
    
    figure
    set(gca,'Color','k')
    hold on
    colors = distinguishable_colors(size(Y,1),'k');
    
    if (size(W,2)==9)
        conditions={'HC','pre-shock','post-shock','rem','High-theta','Low-Theta','NREM','A','C'};
    else
        conditions={'HC','pre-shock','post-shock','rem','High-theta','A','C'};
    end
    
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
        scatter(squeeze(Y(i,1,:)),squeeze(Y(i,2,:)),'o','MarkerEdgeColor',colors(i,:));
    end
    hold off
else
    Y=X;
end











