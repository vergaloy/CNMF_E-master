function MS=get_overlaping_cell_MS(obj,hyp);
% MS=get_overlaping_cell_MS(neuron.S,hypno);

[C]=Separate_by_behaviour(obj,hyp,50);

parfor i=1:size(C,2)

[W,H,~]=Get_seqNMF(C,setdiff(1:size(C,2),i),5,1);
ind(:,i)=mean(W*H,2);
end
% ind=ind./max(ind,[],1);

dim=size(ind,2);
b=nchoosek(1:dim,2);
MS=zeros(dim,dim);
for i=1:size(b,1)
        id1=b(i,1);
        id2=b(i,2);
        t1=double(ind(:,id1));
        t2=double(ind(:,id2));
        MS(id1,id2)=dot(t1,t2)/(norm(t1)*norm(t2));  
end
MS=(MS+MS')+diag(ones(1,dim));

dummy=1;