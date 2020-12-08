function estimate_ensamble_related_activity_consolidation(ac,D,w,ix);
% estimate_ensamble_related_activity_consolidation(a(:,4:7),D(4:7),Wc,pix);

for i=1:size(D,2)    
    X=D{1,i};
    S=size(X,2);
    a(:,i)=get_mean_activity_clustered_by_patterns(X,w,S);   
end


[CI,P]=compare_cell_ensambles_activity(a,ix,1);
[CI2,P2]=compare_cell_ensambles_activity(ac,ix,0);