function [engram,non_engram]=separate_cells_with_significants_W(W,mice_sleep)
% [engram,non_engram]=separate_cells_with_significants_W(out{2,1},mice_sleep);
b=nchoosek(1:size(W,1),2);
out_ref=1;
ref=[8,1,9];
comp=[1,2];

[S,av]=get_significant_weights(W);
S=S(:,out_ref);
av=av(:,out_ref);


D=divide_date_for_SVM(kill_inactive_neurons(mice_sleep,1450,ref),'bin',2);
% m=mean(D{1, comp(2)},2)-mean(D{1, comp(1)},2);
m=mean([D{1,ref(2)},D{1,ref(3)}],2)-mean(D{1, ref(1)},2);
fit_line(av,m,'Weights (SD)','Mean difference')


k=logical(S(:,1));
xd=[D{1, comp(1)},D{1, comp(2)}];
% xd=[D{1, ref(1)},D{1, ref(2)},D{1, ref(3)}];
xd=xd./max(xd,[],2);


figure;
A=xd(k,:);
[o,I]=sort(m(k),'ascend');
o=find(o>0,1)-0.5;
subplot(2,1,1);imagesc(A(I,:));xline(size(D{1, comp(1)},2),'r','LineWidth',2);yline(o,'r','LineWidth',2)

B=xd(~k,:);
[o,I]=sort(m(~k),'ascend');
o=find(o>0,1)-0.5;
subplot(2,1,2);imagesc(B(I,:));xline(size(D{1, comp(1)},2),'r','LineWidth',2); %yline(o,'r','LineWidth',2)

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
% engram_v=engram_v./nanmean(engram_v(:,1));
% non_engram_v=non_engram_v./nanmean(non_engram_v(:,1));
% all_norm=catpad(2,engram_v,non_engram_v);

CI=bootstrap(all,size(mice_sleep,2));
% CIn=bootstrap(all_norm,size(mice_sleep,2));
