function [Y,stress,diff]=Bootstrap_pattern_similarity(W,criteria)


% [Y,stress,diff]=Bootstrap_pattern_similarity(Wall,'stress');
% export_fig('patterns_act_with_NREM_norm.pdf', '-append');

clear textprogressbar
warning('off','all')

MS=multiple_pattern_MS(W);

opts = statset('MaxIter',1000,'TolFun',1e-8,'TolX',1e-8);
[X,stress,disparities]=mdscale(MS,2,'Criterion',criteria,'Options',opts);
diff=Shepard_Plot(MS,X,disparities,criteria,1);

X=X(:,1:2);
X=X-mean(X);

sim=100;
stress(1:sim)=0;
textprogressbar('Bootstraping: ');
er=0;
for s=1:sim
    textprogressbar((s/sim)*100);
    isok=0;
  while (isok==0)
    
    sur=cell_surrogate(W);
    bootstrap_sample=multiple_pattern_MS(sur);
    MSs(:,:,s)=bootstrap_sample;
    try
        [temp,stress(s),disparities]=mdscale(bootstrap_sample,2,'Criterion',criteria,'Options',opts);
         diff(s,:)=Shepard_Plot(MS,temp,disparities,criteria,0);   
        isok=1;
    catch
        er=er+1;
    end
  end
    Y(:,:,s)=align_matrix(X,temp);   
end
Y=align_to_mean(Y);
er
textprogressbar('done');
[M,lc,uc]=MSs_CI(MSs);


    figure('Position', [400 250 1000 600])     
%     set(gca,'Color','k')
     set(gca,'units','pix')
    hold on
    colors = distinguishable_colors(size(Y,1));
    if (size(Y,1)==9)
        conditions={'HC','pre-shock','post-shock','REM','High-theta','Low-Theta','NREM','A','C'};
    else
        conditions={'HC','pre-shock','post-shock','REM','High-theta','Low-Theta','NREM'};
    end 
    for i=1:size(Y,1)
        a=ErrorEllipse(squeeze(Y(i,:,:)),0.5);
        plot(a(1,:),a(2,:),'-','color',colors(i,:),'LineWidth',2);
%         text(i/9,0,conditions(i),'Units','normalized','color',colors(i,:),'FontSize',14);
        uistack(gca,'bottom')
    end

   legend(conditions,'Location', 'southoutside','Orientation','Horizontal','AutoUpdate','off');

    
    hold on
    for i=1:size(Y,1)
        scatter(squeeze(Y(i,1,:)),squeeze(Y(i,2,:)),'filled','o','MarkerFaceColor',colors(i,:),'MarkerFaceAlpha',.5);  %
    end

    diff=mean(diff,1);
    
    figure
    hold on
    for i=1:size(Y,1)
        scatter(squeeze(Y(i,1,:)),squeeze(Y(i,2,:)),'filled','o','MarkerFaceColor','b','MarkerFaceAlpha',.5);  %
    end
    hold off