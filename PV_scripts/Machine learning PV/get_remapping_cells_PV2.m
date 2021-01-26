function [si,RS]=get_remapping_cells_PV2(a,D,N,hyp,sf,bin)
%   [si,RS]= get_remapping_cells_PV2(a,D,N,hyp,5,1)
div=10;

X=D{1,4}; %get consolidation period
hyp=bin_data(hyp,sf,bin);
dur=round(size(X,2)/60);


% Get remapping score sleep
O=consolidation_remaping2(X,N,hyp,div);
O_S=squeeze(O(1,:,:))';
RS_sleep=get_remapping_score(O_S);

% Get remapping score Wake
O_W=squeeze(O(2,:,:))';
RS_W=get_remapping_score(O_W);

% Get remapping score all data regarding of vigilant state
B=means_binned_data(X,div);
RS=get_remapping_score(B);

% get A, B and C
B=B./prctile(B,95,1);
B(B>1)=1;
A=B(:,1);
C=B(:,end); 

%% plot Pearson correlation
s=dur/div;
x=s*2:s:dur-s;
figure;hold on;
fit_line(x,RS);
fit_line(x,RS_sleep);
fit_line(x,RS_W);
xlabel('Time (min)');ylabel('Remapping score');

%% Plot B
[~,I]=sort(B(:,end)-B(:,1));
 figure;plot_B(B(I,:),x);

%% Get significant remapping cells
RS=B;
[r0,p]=significant_corr(RS);
h=fdr_bh(p);

s1=logical(h.*(r0<0)); %significant (-) correlations
s2=logical(h.*(r0>0)); %significant (+) correlations


si=s1+s2*2;



D1=RS(si==1,:);
D2=RS(si==2,:);
% D1=D1./max(D1,[],2);
% D2=D2./-min(D2,[],2);
Dp=[D1;D2];
Dp=Dp./max(Dp,[],2);




figure;heatmap_PV(Dp,(1:size(Dp,2)),[],[],'Colormap','hot','MinColorValue',0,'MaxColorValue',1,'GridLines','-');
co = colorbar;co.Label.String = 'Remapping contribution';co.Label.FontSize = 12;
xlabel('Time bin')
yline(size(D1,1)+0.5,'-b','LineWidth',3)


cluster_mean_activities(a(si>0,[1,2,3,5]));
cluster_mean_activities(a(si==0,[1,2,3,5]));



Bo{1}=bootstrap(B(si==1,:));
Bo{2}=bootstrap(B(si==2,:));
Bo{3}=bootstrap(B(si==0,:));

for i=1:size(B,2);
    X=catpad(2,B(si==0,i),B(si==1,i),B(si==2,i));
    [~,p]=bootstrap(X,24);
    P(i,:)=p(1,:);
end

% Apre=mean(a(:,[2,3]),2);
Apre=mean(a(:,3),2);
Apre=Apre./prctile(Apre,95,1);
Apre(Apre>1)=1;

Apost=a(:,5);
Apost=Apost./prctile(Apost,95,1);
Apost(Apost>1)=1;

All=[Apre,B,Apost];

Ao{1}=bootstrap(All(si==1,:));
Ao{2}=bootstrap(All(si==2,:));
Ao{3}=bootstrap(All(si==0,:));

for i=1:size(All,2);
    X=catpad(2,All(si==0,i),All(si==1,i),All(si==2,i));
    [~,p]=bootstrap(X,3);
    Pa(i,:)=p(1,:);
end

for i=0:2;
    X=catpad(2,All(si==i,1),All(si==i,2));
    [~,p]=bootstrap(X,3);
    Pa2(i+1,:)=p(1,2);
end


% print # of remapping neurons:
% PreCon.  - postCon. - Non-remapping
[sum(si==1),sum(si==2),sum(si==0)]

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



