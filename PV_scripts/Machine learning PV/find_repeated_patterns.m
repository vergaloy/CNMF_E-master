function [Rep,Pat,Pid]=find_repeated_patterns(W)
% [Rep,Pat,Pid]=find_repeated_patterns(W);

Pat=cell(size(W,1),1);
Rep=cell(size(W,1),1);
Pid=cell(size(W,1),1);
h=0;
for i=1:size(W,1)
    w=W(i,:);
    [Pat_t,E]=extract_patterns_from_sessions(w);
    
    k=Cluster_data_PV(double(Pat_t>0)','remove_0s',0,...
        'Cmethod','average','Cdist','jaccard','plotme',0,'alpha',0.05);
    [Rep_t,Pid_t]=k2pattern_id(k,E);
    Pat{i}=Pat_t;
    Rep{i}=Rep_t;
    Pid{i}=Pid_t+h;
    h=max(Pid{i});
end
Rep=catpad(1,Rep{:});
Pid=catpad(2,Pid{:});
Pat=reorganize_mice(Pat);

    x=Pat(:,ismember(Pid,1:size(Rep,1)));
    L = order_tree(linkage(double(x>0),'average','jaccard'));
    [~,I]=sort(Pid(ismember(Pid,1:size(Rep,1))));
    figure;imagesc(x(L,I));
    n=0;
    for j=1:max(Pid)
        n=n+sum(Pid==j);
        xline(n+0.5,'r')
    end

end


function out=reorganize_mice(in)
[nrows,ncols] = cellfun(@size,in);

out=zeros(sum(nrows),sum(ncols));
nr=0;
nc=0;
for i=1:size(in,1)
    out(nr+1:nr+nrows(i),nc+1:nc+ncols(i))=in{i, 1};
    nr=nr+nrows(i);
    nc=nc+ncols(i);
end

end



function [M,E]=extract_patterns_from_sessions(W)
M=[];
E=[];
for i=1:size(W,2)
    temp=W{1,i} ;
    M=catpad(2,M,temp);
    E=catpad(2,E,ones(1,size(temp,2))*i);
end
end

function [Rep,Pid]=k2pattern_id(k,E)
t=find(0==sum(k,2));
Pid=k;
c=zeros(size(Pid,1),length(t));
for i=1:length(t)
    c(t(i),i)=1;
end
Pid=catpad(2,Pid,c)';
Pid=sum((1:size(Pid,1))'.*Pid,1);

Rep=zeros(max(Pid),max(E));
for i=1:max(Pid)
    Rep(i,E(i==Pid))=1;
end
end










