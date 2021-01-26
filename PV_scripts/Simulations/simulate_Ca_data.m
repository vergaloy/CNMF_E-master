function [T,W]=simulate_Ca_data(varargin)
% [T,W]=simulate_Ca_data('mice_sleep',mice_sleep);
[amp,burst_decay,mice_sleep,P0,L,bin,pat_rep,noise,N,pat_n]=parameters_in(varargin{:});


if (pat_n~=0)
 for i=1:length(pat_n)  
   n_t=pat_n(i); 
 [P_t{i,1},Pat_t{i,1}]=make_patterns(L,pat_rep,P0,burst_decay,n_t,bin,noise);
 end
 P=catpad(1,[],P_t{:});
 Pat=catpad(1,[],Pat_t{:});
else
Pat=[];
P=[];
end

B=datasample(P0,N-sum(pat_n));
other_neurons=double(rand(N-sum(pat_n),L)<B);
other_neurons=add_burstiness(other_neurons,burst_decay,B);

T=[Pat;other_neurons];

% a=rand(N,L);
% a=interp1(amp(:,2),amp(:,1),a, 'linear');
% 
% T=a.*T;
% P=a(1:pat_n,:).*P;

T=bin_data(T,bin,1); 
W=[P;zeros(N-sum(pat_n),L/bin)];
W(isnan(W))=0;
T(isnan(T))=0;
end


function [P,Pat]=make_patterns(L,pat_rep,P0,burst_decay,pat_n,bin,noise)
t=datasample(1:L,pat_rep);  %% pattern occurance
P=zeros(1,L);
P(t)=1;

P0=sort(P0);
B=mean(P0); %get mean average activities
P=add_burstiness(P,burst_decay,B);
P=ones(pat_n,1)*P;
activity_prob=(pat_rep*pat_n)/numel(P);
noise_activity=double(rand(pat_n,L)<activity_prob*noise);

noise_activity=add_burstiness(noise_activity,burst_decay,B);
Pat=noise_activity+P;
P=bin_data(P,bin,1);
end

function out=add_burstiness(P,burst_decay,B)
n=size(P,1);
L=size(P,2);
w = conv2(1,(burst_decay-1),P);
w=w.*B;
out=double((P+(w(:,1:L)-rand(n,L)))>0);

end


function [amp,burst_decay,mice_sleep,P0,L,bin,pat_rep,noise,N,pat_n]=parameters_in(varargin)
inp = inputParser;
valid_v = @(x) isnumeric(x);


addParameter(inp,'amp',[])  
addParameter(inp,'burst_decay',[])  
addParameter(inp,'P0',[])
addParameter(inp,'mice_sleep',cell(4,9))  %
addParameter(inp,'L',3000,valid_v)  %
addParameter(inp,'bin',10,valid_v)  %frames per bin
addParameter(inp,'pat_rep',5,valid_v)  
addParameter(inp,'noise',1,valid_v)  %alpha
addParameter(inp,'N',30,valid_v)  %alpha
addParameter(inp,'Pat_n',5,valid_v)  %alpha


inp.KeepUnmatched = true;
parse(inp,varargin{:});
warning off
amp=inp.Results.amp;
burst_decay=inp.Results.burst_decay;
mice_sleep=inp.Results.mice_sleep;
P0=inp.Results.P0;
L=inp.Results.L;
bin=inp.Results.bin;
pat_rep=inp.Results.pat_rep;
noise=inp.Results.noise;
N=inp.Results.N;
pat_n=inp.Results.Pat_n;

if (isempty(amp)||isempty(burst_decay)||isempty(P0))
cprintf('*blue','Amp,burst_decay, or P0 not provided \n')    
cprintf('*blue','Estimating them from data... \n')       
    if (isempty(mice_sleep))
    error('Data "mice_sleep" was not provided. Cannot estimate parametes \n')
    else       
       [amp,burst_decay,P0]=estimate_parameters_from_neurons(mice_sleep);
    end
end

end






