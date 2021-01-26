function [si,RS]=get_remapping_cells_PV(a,D,N,hyp,sf,bin)
%   [si,RS]= get_remapping_cells_PV(a,D,N,hyp,5,1)
div=10;
X=D{1,4}; %get consolidation period
hyp=bin_data(hyp,sf,bin);



% Get remapping score sleep
O=consolidation_remaping2(X,N,hyp,div);
O_S=squeeze(O(5,:,:))';
RS_sleep=get_remapping_score(O_S);

% Get remapping score Wake
O_W=squeeze(O(6,:,:))';
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
x=30:15:135;
figure;hold on;
fit_line(x,sum(RS));
fit_line(x,sum(RS_sleep));
fit_line(x,sum(RS_W));
xlabel('Time (min)');ylabel('Remapping score');

%% Plot B
[~,I]=sort(B(:,end)-B(:,1));
 figure;plot_B(B(I,:),x);

%% Get significant remapping cells

t=max(abs(RS),[],2);
[s,~]=sort(t);
 I=s(find(cumsum(s)./sum(s)<0.05,1,'last'))<t;
[r0,p]=significant_corr(RS);
[r,~]=significant_corr(abs(RS));
s1=logical((p<0.05).*(r<0).*(r0<0).*I'); %significant (-) correlations
s2=logical((p<0.05).*(r>0).*(r0<0).*I'); %significant (+) correlations
% s1=logical((p<0.05).*(r<0).*(r0<0)); %significant (-) correlations
% s2=logical((p<0.05).*(r>0).*(r0<0)); %significant (+) correlations


si=s1+s2*2;
sr=si;
sr(sr==0)=[];

At=A(si>0,:);
Bt=B(si>0,:);
Ct=C(si>0,:);
C1=get_cosine_by_element(At,Bt);
C2=get_cosine_by_element(Ct,Bt);
Dr=(C1-C2)./sum(C1+C2,1);
Dr=Dr./max(abs(Dr),[],2);

D1=Dr(sr==1,:);
D2=Dr(sr==2,:);
% D1=D1./max(D1,[],2);
% D2=D2./-min(D2,[],2);
Dp=[D1;D2];





figure;heatmap_PV(Dp,(1:size(Dp,2)),[],[],'Colormap',redbluecmap,'MinColorValue',-1,'MaxColorValue',1,'GridLines','-');
co = colorbar;co.Label.String = 'Remapping contribution';co.Label.FontSize = 12;
xlabel('Time bin')


cluster_mean_activities(a(si>0,[1,2,3,5]));
cluster_mean_activities(a(si==0,[1,2,3,5]));

Apre=mean(a(:,[2,3]),2);
Apre=Apre/prctile(Apre,95);
Apre(Apre>1)=1;

Apost=a(:,5);
Apost=Apost/prctile(Apost,95);
Apost(Apost>1)=1;

All=[Apre,B,Apost];
Bo{1}=bootstrap(All(si==0,:));
Bo{2}=bootstrap(All(si==1,:));
Bo{3}=bootstrap(All(si==2,:));

for i=1:size(All,2);
    X=catpad(2,All(si==0,i),All(si==1,i),All(si==2,i));
    [~,p]=bootstrap(X,2);
    P(i,:)=p(1,:);
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
C1=get_cosine_by_element(A,B);
C2=get_cosine_by_element(C,B);
RS=(C1-C2)./sum(C1+C2,1);
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



