function CI=compare_cell_ensambles_activity_proportion(a,ix,kill_0);
% [CI,P]=compare_cell_ensambles_activity(mice_sleep,ix,a,7);
ac=separate_activities(a,ix); 

for i=1:size(ac,2)
   X=ac{i}; 
    sim{i}=sim_data(X);
end


if (kill_0==1)
sim=sim(2:3);
end

prop=sim2prop(sim);
% prop=sim;

pro=(prop{1, 1}-prop{1, 2})./(prop{1, 1}+prop{1, 2}) ;
CI=get_CI(pro,1);


end

function a=separate_activities(X,ix)
a=[];
for i=0:max(ix)
    temp=X(ix==i,:);
    a{i+1}=temp;
end   
end


function sim=sim_data(obj)
sims=10000;
col=size(obj,2);
sim=zeros(sims,col);
parfor s=1:sims
    for i=1:col
        temp=obj(:,i);
        temp(isnan(temp))=[];
        temp=datasample(temp,size(temp,1));
        sim(s,i)= mean(temp);
    end
end
end

function prop=sim2prop(sim);

X=0*sim{1,1};
for i=1:size(sim,2)
    X=X+sim{1,i};
end

for i=1:size(sim,2)
    prop{i}=sim{1,i}./X;
end
end


function P=get_P(X,c)
if ~exist('c','var')
    c=(size(X,2)^2-size(X,2))/2;
end

alpha=5/c/2;
col=size(X,2);

if (size(X,2)>1)
    b=nchoosek(1:col,2);
    P=zeros(col);
    comp=size(b,1);
    for i=1:comp
        t1=X(:,b(i,1));
        t2=X(:,b(i,2));
        P(b(i,1),b(i,2))=(prctile(t1-t2,alpha)*prctile(t1-t2,100-alpha))>0;
    end
    P=P+P';
end
end

function CI=get_CI(X,c)
alpha=5/c/2;
for i=1:size(X,2)
    CI(i,:)=[mean(X(:,i)),prctile(X(:,i),100-alpha),prctile(X(:,i),alpha)].*100;
end
    
end

