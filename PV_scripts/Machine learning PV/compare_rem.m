function [si,RS]=compare_rem(D,N,hyp,sf,bin,si)
%   [si,RS]= compare_rem(D,N,hyp,5,1,si)
div=2;

X=D{1,4}; %get consolidation period
hyp=bin_data(hyp,sf,bin);
dur=round(size(X,2)/60);


% Get remapping score sleep
O=consolidation_remaping2(X,N,hyp,div);
O_S=squeeze(O(1,:,:))';
B=means_binned_data(O_S,div);



end

function plot_B(B,x);
le=length(x)+2;
subplot(1,le,1);
plot_heatmap_PV(B(:,1),'colormap','hot','GridLines','-');
xlabel('15');
subplot(1,le,2:le-1);
plot_heatmap_PV(B(:,2:le-1),'colormap','hot','GridLines','-','y_labels',{'30','45','60','75','90','105','120','135'});
subplot(1,le,le);
plot_heatmap_PV(B(:,le),'colormap','hot','GridLines','-');
xlabel('150');
end

function B=means_binned_data(in,bsize)
lin=round(linspace(1,size(in,2),bsize+1));
for i=1:size(lin,2)-1
B(:,i)=mean(in(:,lin(i):lin(i+1)),2);   
end    
end



function RS=get_remapping_score(T)
T=T./prctile(T,95,1);
T(T>1)=1;
A=T(:,1);
C=T(:,end); 
B=T(:,2:end-1);
RS=-((1-get_cosine(A,B))-(1-get_cosine(C,B)))./((1-get_cosine(A,B))+(1-get_cosine(C,B)));

end


function [r,p]=significant_corr(D2)
x=1:size(D2,2);
for i=1:size(D2,1)
[r(i),p(i)]=corr(x',D2(i,:)');
end
end


function out=get_cosine_by_element(A,B)
for i=1:size(B,2)
    b=B(:,i);
    a=A;
    I=isnan(b);
    b(I)=0;
    a(I)=0;
    temp=(a.*b)/(norm(a)*norm(b));
    out(:,i)=temp;
end

end



