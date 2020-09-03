function [engram,non_engram]=separate_cells_with_significants_W(W,mice_sleep)
% [engram,non_engram]=separate_cells_with_significants_W(out{2,1},mice_sleep);
[S,av]=get_significant_weights(W);

D=divide_date_for_SVM(kill_inactive_neurons(mice_sleep,1450,[1,2,3]),'bin',2);
m=mean(D{1, 2},2)-mean(D{1, 1},2);
fit_line(m,av(:,1))


k=logical(S(:,1));
xd=[D{1, 1},D{1, 2}];
figure;
subplot(2,1,1);imagesc(xd(k,:));xline(size(D{1, 1},2),'r','LineWidth',2)
subplot(2,1,2);imagesc(xd(~k,:));xline(size(D{1, 1},2),'r','LineWidth',2)


for i=1:size(D,2)
    temp=D{1, i}(k,:);
    engram{i}=temp;
    engram_v{i}=temp(:);
    temp=D{1, i}(~k,:);
    non_engram{i}=temp;
    non_engram_v{i}=temp(:);
end
    
engram_v=catpad(2,engram_v{:});
non_engram_v=catpad(2,non_engram_v{:});
all=catpad(2,engram_v,non_engram_v);
engram_v=engram_v./nanmean(engram_v(:,1));
non_engram_v=non_engram_v./nanmean(non_engram_v(:,1));
all_norm=catpad(2,engram_v,non_engram_v);

CI=bootstrap(all,size(mice_sleep,2));
CIn=bootstrap(all_norm,size(mice_sleep,2));
