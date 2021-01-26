function [si,RS]=get_remapping_cells(a,D,Rs,N,hyp,sf,bin)
%   [si,RS]= get_remapping_cells(a,D,Rs,N,hyp,5,1)
div=10;



X=D{1,4};


% A=mean(a(:,[2,3]),2);
% A=A/prctile(A,95);
% A(A>1)=1;

B=means_binned_data(X,div);
B=B./prctile(B,95,1);
B(B>1)=1;

% O=consolidation_remaping2(D,N,hyp,sf,bin);
% B=squeeze(O(6,:,:))';
% B=B./prctile(B,95,1);
% B(B>1)=1;
% 


div=div-2;
x=1:div;

A=B(:,1);
C=B(:,end); 
B=B(:,2:end-1);
% 
% C=mean(a(:,5),2);
% C=C/prctile(C,95);
% C(C>1)=1;



C1=get_cosine_by_element(A,B);
% P=[A,B,C];
% [~,I]=sort(A-C,'descend');
%  plot_heatmap_PV(P,'colormap','hot','GridLines','-');

C2=get_cosine_by_element(C,B);
RS=(C1-C2)./sum(C1+C2,1);
figure;fit_line(x,sum(RS));xlabel('Time bin');ylabel('Remapping score');
% RS=mean(abs(temp(:,[1,2,3])),2)-mean(abs(temp(:,[8,9,10])),2); 




t=max(abs(RS(:,[1,div])),[],2);
[s,~]=sort(t);
I=s(find(cumsum(s)./sum(s)<0.05,1,'last'))<t;

[r0,p]=significant_corr(RS);
[r,~]=significant_corr(abs(RS));
s1=logical((p<0.05).*(r<0).*(r0<0).*I');
s2=logical((p<0.05).*(r>0).*(r0<0).*I');

% s1=logical((p<0.05).*(r<0).*(r0<0));
% s2=logical((p<0.05).*(r>0).*(r0<0));

% s1=RS>median(RS)+mad(RS,1)*3;
% s2=RS<median(RS)-mad(RS,1)*3;

si=s1+s2*2;
sr=si;
sr(sr==0)=[];

At=A(si>0,:);
Bt=B(si>0,:);
Ct=C(si>0,:);
C1=get_cosine_by_element(At,Bt);
C2=get_cosine_by_element(Ct,Bt);
Dr=(C1-C2)./sum(C1+C2,1);
figure;fit_line(x,sum(Dr));xlabel('Time bin');ylabel('Remapping score');
D1=Dr(sr==1,:);
D2=Dr(sr==2,:);

D1=D1./max(D1,[],2);
D2=D2./-min(D2,[],2);
Dp=[D1;D2];





figure;heatmap_PV(Dp,(1:size(Dp,2)),[],[],'Colormap',redbluecmap,'MinColorValue',-1,'MaxColorValue',1,'GridLines','-');
co = colorbar;co.Label.String = 'Remapping contribution';co.Label.FontSize = 12;
xlabel('Time bin')

% fit_line(x,sum(Dr))

At=A(si==0,:);
Bt=B(si==0,:);
Ct=C(si==0,:);
C1=get_cosine_by_element(At,Bt);
C2=get_cosine_by_element(Ct,Bt);
Dnr=(C1-C2)./sum(C1+C2,1);

Dnr=Dnr./max(abs(Dnr),[],2);
figure;heatmap_PV([Dp;Dnr],[],[],[],'Colormap',redbluecmap,'MinColorValue',-1,'MaxColorValue',1);


figure;fit_line(x,sum(Dp));hold on;fit_line(x,sum(Dnr))


cluster_mean_activities(a(si>0,[1,2,3,5]));
cluster_mean_activities(a(si==0,[1,2,3,5]));

All=[A,B,C];
Bo{1}=bootstrap(All(si==0,:));
Bo{2}=bootstrap(All(si==1,:));
Bo{3}=bootstrap(All(si==2,:));

for i=1:size(All,2);
    X=catpad(2,All(si==0,i),All(si==1,i),All(si==2,i));
    [~,p]=bootstrap(X,2);
    P(i,:)=p(1,:);
end
end


function B=means_binned_data(in,bsize)
lin=round(linspace(1,size(in,2),bsize+1));
for i=1:size(lin,2)-1
B(:,i)=mean(in(:,lin(i):lin(i+1)),2);   
end    
end


function [aP,anP,aS]=total_sleep_binned(hypno,P,nP,N,div);
for i=1:size(P)
    temp=P(i,:);
    temp2=nP(i,:);
    h=hypno(N(i),:);
    aP(:,:,i)=get_sleep_binned(temp,h,div);
    anP(:,:,i)=get_sleep_binned(temp2,h,div);
    aS(:,:,i)=get_sleep_binned(ones(1,length(temp)),h,div);
end
end


function S=get_sleep_binned(temp,h,div)
R=temp;R(h~=1)=0;%R=cumsum(R);
H=temp;H(h~=0.25)=0;%W=cumsum(W);
W=temp;W(h~=0)=0;%W=cumsum(W);
N=temp;N(h~=0.5)=0;%N=cumsum(N);
S=temp;S(h<0.5)=0;%N=cumsum(N);
V=temp;V(h>0.4)=0;%N=cumsum(N);
S=[R;H;W;N;S;V];
S=means_binned_data(S,div);
end



function [r,p]=significant_corr(D2);
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



