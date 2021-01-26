function [ix,a]=get_pattern_cell_ix(X,w,S)
a=get_mean_activity_clustered_by_patterns(X,w,S);
ix=cluster_mean_activities(a);
end



