function Y=coor_elipses(Yall)


ref=mean(Yall,3);
for i=1:size(Yall,3)
    Y(:,:,i)=align_matrix(ref,Yall(:,:,i));
end

    figure('Position', [400 250 1000 600])     
%     set(gca,'Color','k')
    hold on
    colors = distinguishable_colors(size(Y,1));
    
    if (size(Y,1)==9)
        conditions={'HC','pre-shock','post-shock','rem','High-theta','Low-Theta','NREM','A','C'};
    else
        conditions={'HC','pre-shock','post-shock','rem','High-theta','Low-Theta','A','C'};
    end
    
    for i=1:size(Y,1)
        a=ErrorEllipse(squeeze(Y(i,:,:)));
        h1=plot(a(1,:),a(2,:),'-','color',colors(i,:),'LineWidth',2);
%         legend(conditions)
%         text(Y(i,1)+0.02,Y(i,2)+0.005,conditions(i),'color',colors(i,:),'FontSize',14);
%         uistack(h1(i),'bottom')
    end
    legend(conditions','color','white','Location', 'southoutside','Orientation','Horizontal','AutoUpdate','off')

    
    hold on
    for i=1:size(Y,1)
        scatter(squeeze(Y(i,1,:)),squeeze(Y(i,2,:)),'filled','o','MarkerFaceColor',colors(i,:));
    end
    hold off
    
    