function plot_NMF_results(X,W,H)

W=squeeze(mean(W,3));

Z=linkage(W);
indSort = flip(order_tree(Z));

ind=sum(W,2);
[~,indSort] = sort(ind,'descend');
    figure; SimpleWHPlot(W(indSort,:,:),H,X(indSort,:)); title('SeqNMF factors, with raw data')
    axdrag
