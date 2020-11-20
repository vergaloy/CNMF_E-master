function [CI,P,P2]=compare_cell_ensambles_activity(ix,a);


for i=1:size(a,2)
   X=a(:,i); 
   ac=separate_activities(X,ix); 
   [CI(:,:,i),P(:,:,i),NP(:,i)]=bootstrap_proportion(ac,1);
end
P=squeeze(P(2,3,:));
P2=NP2p(NP,9);



% for i=1:size(D,2)
%    X=D{1,i}; 
%    ac=separate_activities(X,ix); 
%    [CI(:,:,i),P(:,:,i),NP(:,i)]=bootstrap_proportion(ac,1);
% end
% 
% [~,P2]=bootstrap(NP);
% 

end

function a=separate_activities(X,ix);
a=[];
for i=0:max(ix)
    temp=X(ix==i,:);
    a=catpad(2,a,temp(:));
end
    
end



function P=NP2p(NP,c)

if ~exist('c','var')
    c=(size(NP,2)^2-size(NP,2))/2;
end

alpha=5/c/2;
col=size(NP,2);

if (size(NP,2)>1)
    b=nchoosek(1:col,2);
    P=zeros(col);
    comp=size(b,1);
    for i=1:comp
        t1=NP(:,b(i,1));
        t2=NP(:,b(i,2));
        P(b(i,1),b(i,2))=(prctile(t1-t2,alpha)*prctile(t1-t2,100-alpha))>0;
    end
    P=P+P';
end
end
