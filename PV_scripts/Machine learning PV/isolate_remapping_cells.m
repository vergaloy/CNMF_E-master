function si=isolate_remapping_cells(D,a2);

Pre=[D{1,2},D{1,3}];
Post=[D{1,5}];
n1=size(Pre,2);
n2=size(Post,2);

m1=mean(Pre,2);
m1=m1/prctile(m1,95);
m1(m1>1)=1;

m2=mean(Post,2);
m2=m2/prctile(m2,95);
m2(m2>1)=1;

C=get_cosine_by_element(m1,m2);

sim=1000;
S=zeros(size(Pre,1),sim);
parfor s=1:sim
    temp=datasample([Pre,Post],n1+n2,2);
    t1=mean(temp(:,1:n1),2);
    t2=mean(temp(:,n1+1:end),2); 
    t1=t1/prctile(t1,95);
    t1(t1>1)=1;
    t2=t2/prctile(t2,95);
    t2(t2>1)=1;
    S(:,s)=get_cosine_by_element(t1,t2);
end

si=prctile(S,5,2)>C;



cluster_mean_activities(a2(si,:));
cluster_mean_activities(a2(~si,:));

end

function out=get_cosine_by_element(A,B)
for i=1:size(B,2)
    out(:,i)=(A.*B(:,i))/(norm(A)*norm(B(:,i)));
end

end









