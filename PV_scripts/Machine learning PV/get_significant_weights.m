function [S,av]=get_significant_weights(W)
% [S,av]=get_significant_weights(out{2,1});
b=nchoosek(1:size(W,1),2);
S=false(size(W,3),size(b,1));

for i=1:size(b,1)
    temp=squeeze(W(b(i,1),b(i,2),:,:));
    av(:,i)=mean(temp,2);
    m=(0-mean(temp,2))./std(temp,[],2);
    m(m>=0)=0;
    m=normcdf(abs(m),'upper'); 
    S(:,i)=logical(fdr_bh(m));
end

% D=divide_date_for_SVM(kill_inactive_neurons(mice_sleep,1450,[1,2,3]));
% m=mean(D{1, 2},2)-mean(D{1, 1},2);
% fit_line(m,av(:,1))
% 
% 
% 
% %     k=logical(S(:,1).*S(:,2));
%  k=logical(S(:,1));
%  xd=[D{1, 1},D{1, 2}];
% imagesc(xd(~k,:));
%    [~,I]=sort(m(k),'descend');
% 
%    xd=[D{1, 1},D{1, 2},D{1, 3}];
%     
%    xd=xd(k,:);
%   
%    imagesc(xd(I,:));
% 
% A=xd(I,:);
% m=mean(A(:,296:end),2)-mean(A(:,1:295),2);
% w=av(S(:,1),1);
% fit_line(w,m)

