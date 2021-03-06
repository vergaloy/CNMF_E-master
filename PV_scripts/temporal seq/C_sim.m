function [F]=C_sim(C);

P=sinc_fire_prob(C);
F=PtoFnorm(P,10);
imagesc(F);
figure
opts = statset('MaxIter',1000);
[X,stress,disparities]=mdscale(F,2,'Criterion','metricstress','Options',opts);
Shepard_Plot(F,X,disparities,1)

X=X-mean(X,1);

%%
sim=100;  %number of simulations
stress(1:sim)=0;
clear textprogressbar
warning('off','all')
textprogressbar('Bootstraping: ');
for s=1:sim
    textprogressbar((s/sim)*100);
    r=datasample(1:size(P,1),size(P,1));
    bootstrap_sample=PtoFnorm(P(r,r,:),5);
    try
    [temp,stress(s)]=mdscale(bootstrap_sample,2,'Criterion','metricstress','Options',opts);
    catch
        dumm=2;
    end
    Y(:,:,s)=align_matrix(X,temp(:,1:2));
end
textprogressbar('done');

%% Plot data

    figure
    set(gca,'Color','k')
    hold on
    colors = distinguishable_colors(size(Y,1),'k');
    
    if (size(P,3)==9)
        conditions={'HC','pre-shock','post-shock','rem','High-theta','Low-Theta','NREM','A','C'};
    end
    
    if (size(P,3)==7)
        conditions={'HC','pre-shock','post-shock','rem','High-theta','A','C'};
    end
    
    if (size(P,3)==6)
        conditions={'HC','pre-shock','post-shock','rem','A','C'};
    end
    
    if (size(P,3)==5)
        conditions={'HC','pre-shock','post-shock','A','C'};
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
        scatter(squeeze(Y(i,1,:)),squeeze(Y(i,2,:)),'.','MarkerEdgeColor',colors(i,:));
    end
    hold off
    [mean(stress),prctile(stress,95),prctile(stress,5)]

