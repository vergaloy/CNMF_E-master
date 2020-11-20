function [sim,pnr,cn,missed_neuron_batch,spatial_similarity,temporal_corr]=compare_batches(neuron,batches)
% [sim,pnr,cn,missed_neuron_batch,spatial_similarity,temporal_corr]=compare_batches(neuron2,batches);

frames=neuron.frame_range(1:2:end,:);
[d1,d2]=size(neuron.Cn);
for i=1:size(frames,1)
    %% Get neuron mask
    a=logical(sum(neuron.S(:,frames(i,1):frames(i,2)),2)>0);  %get active neurons
    A=neuron.A(:,a);
    Ac=neuron.C(a,frames(i,1):frames(i,2));
    if ~isempty(batches{i, 1})
        B=batches{i, 1}.neuron.A;
        Bc=batches{i, 1}.neuron.C;
        PNR=batches{i, 1}.neuron.PNR;
        Cn=batches{i, 1}.neuron.Cn;
        [pnr(i,1),cn(i,1),missed_neuron_batch(i,1),spatial_similarity(i,1),temporal_corr(i,1)]=get_similar_neurons(A,Ac,B,Bc,PNR,Cn,d1,d2);
    else
        B=zeros(size(neuron.Cn,1)*size(neuron.Cn,2),1);
    end
    
    %% get mean similarity
    sim(i,1)=get_spatial_similarity(A.*mean(Ac,2)',B.*mean(Bc,2)',d1,d2);    
end
end

function [pnr,Cn,missed_neuron_batch,spatial_similarity,temporal_corr]=get_similar_neurons(A,Ac,B,Bc,PNR,coor,d1,d2)

M=get_spatial_sim_matrix(A,B);
R=corr(Ac',Bc');
S=(M>0.8).*R;
S=S.*(S==max(S,[],1));
missed_neuron_batch=~sum(S,2)>0;
[~,pnr,Cn,~] = get_contoursPV(A(:,missed_neuron_batch),d1,d2,PNR,coor);
% [~,pnr,Cn,~] = get_contoursPV(A,d1,d2,PNR,coor);
A_t=sum(A(:,sum(S,2)>0),2);
B_t=sum(B(:,sum(S,1)>0),2);


spatial_similarity=get_cosine_sim(A_t,B_t);
pnr=nanmean(pnr);
Cn=nanmean(Cn);
missed_neuron_batch=mean(missed_neuron_batch);

% 
% PNR(PNR<7)=0;
% coor(coor<0.77)=0;
% temp=PNR.*coor;
% spatial_similarity=get_cosine_sim(full(sum(A.*mean(Ac,2)',2)),temp(:));
% % imagesc(reshape(full(sum(A.*mean(Ac,2)',2)),[d1 d2]));
temporal_corr=mean(R(logical(S)));
end



function M=get_spatial_sim_matrix(A,B)
M=zeros(size(A,2),size(B,2));
for i=1:size(A,2)
    for j=1:size(B,2)
        M(i,j)=get_cosine_sim(A(:,i),B(:,j));
    end
end
end

function S=get_temporal_sim_matrix(Ac,Bc)
        [R,P]=corr(Ac',Bc');
end


function sim=get_spatial_similarity(A,B,d1,d2)
A=reshape(sum(A,2),[d1 d2]);
B=reshape(sum(B,2),[d1 d2]);
sim=get_cosine_sim(A,B);
end

function out=get_cosine_sim(v1,v2)
v1=full(v1(:));
v2=full(v2(:));
out=dot(v1,v2)/(norm(v1)*norm(v2));

end