function O=consolidation_remaping2(X,N,hyp,div)
for i=1:size(X,1)
if (i==56)
2
end
    temp=X(i,:);
    h=hyp(N(i),:);
    O(:,:,i)=get_sleep_binned(temp,h,div);
end
end




function B=means_binned_data(in,bsize)
lin=round(linspace(1,size(in,2),bsize+1));
for i=1:size(lin,2)-1
B(:,i)=nanmean(in(:,lin(i):lin(i+1)),2);   
end    
end



function O=get_sleep_binned(temp,h,div)
% R=temp;R(h~=1)=nan;%R=cumsum(R);
% H=temp;H(h~=0.25)=nan;%W=cumsum(W);
% W=temp;W(h~=0)=nan;%W=cumsum(W);
% N=temp;N(h~=0.5)=nan;%N=cumsum(N);
S=temp;S(h<0.5)=nan;%N=cumsum(N);
V=temp;V(h>0.4)=nan;%N=cumsum(N);
% O=[R;H;W;N;S;V];
O=[S;V];
O=means_binned_data(O,div);
end



