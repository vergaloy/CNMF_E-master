function P=sinc_fire_prob(C);

clear textprogressbar
warning('off','all')
textprogressbar('Getting infomration of pairs: ');


for i=1:size(C,2)
    textprogressbar((i/size(C,2))*100);
    temp=C{1,i};
    temp(temp>0)=1;
    b= nchoosek(1:size(temp,1),2);
    p=zeros(size(temp,1),size(temp,1));
    for j=1:size(b,1)
        n1=temp(b(j,1),:);
        n2=temp(b(j,2),:);
        
        p1=[mean(n1),mean(1-n1)]; 
        p2=[mean(n2),mean(1-n2)]; 
        pc=p1'*p2;
        po=[mean(n1.*n2),mean((n1).*(1-n2));mean((1-n1).*(n2)),mean((1-n1).*(1-n2))];
        
        ps=po.*log2(po./pc);
        ps(isnan(ps))=0;
        p(b(j,1),b(j,2))=sum(ps,'all');
    end
    p=p+p';
    %p =p+ diag(ones(1,size(p,1)));
    P(:,:,i)=p;    
end
textprogressbar('done');

