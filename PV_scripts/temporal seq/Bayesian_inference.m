function [PA,PB]=Bayesian_inference(A,B,order,sim)
%    [PA,PB]=Bayesian_inference(C{1,1}(:,1:150),C{1,1}(:,151:300),1,100);
A=full(A)';
A(A>0)=1;
A=logical(A);
B=full(B)';
B(B>0)=1;
B=logical(B);



cprintf('*blue','Getting %1g order coactivity matrix of data A \n',order)
A=coactivity_matrix(A,order);
cprintf('*blue','Getting %1g order coactivity matrix of data B \n',order)
B=coactivity_matrix(B,order);


clear textprogressbar
warning('off','all')
textprogressbar('Trying different samples of Training and Test data ');
PA=zeros(1,sim);
PB=zeros(1,sim);

for s=1:sim
    textprogressbar(s/sim*100);
    y1 = randsample(size(A,1),floor(size(A,1)*0.9));
    x1=setdiff(1:size(A,1),y1,'stable');
    TrainA=SubscritRef(y1,A);
    
    y2 = randsample(size(B,1),floor(size(B,1)*0.9));
    x2=setdiff(1:size(B,1),y2,'stable');    
    TrainB=SubscritRef(y2,B);
    Total=cat(1,TrainA,TrainB);
    
    if (order<2)
    
    TrainA=squeeze(mean(TrainA,1));
    TrainB=squeeze(mean(TrainB,1));
    Total=squeeze(mean(Total,1));
    
    else     
    TrainA=ND_prob(TrainA,order);   
    TrainB=ND_prob(TrainB,order); 
    Total=ND_prob(Total,order);       
    end
    
%     TrainA(TrainA==0)=nan;
%      TrainB(TrainB==0)=nan;
%      Total(Total==0)=nan;
    
    TestA=SubscritRef(x1,A);
    TestB=SubscritRef(x2,B);
    
    for i=1:size(TestA,1)
        temp=squeeze(SubscritRef(i,TestA));
        
        APr_s=temp.*TrainA+(1-temp).*(1-TrainA);
        APs=0.5;
        APr=temp.*Total+(1-temp).*(1-Total);
        APs_r=(APr_s.*APs)./APr;
        PisinA=nanmean(APs_r,'all');
        
        BPr_s=temp.*TrainB+(1-temp).*(1-TrainB);
        BPs=0.5;
        BPr=temp.*Total+(1-temp).*(1-Total);
        BPs_r=(BPr_s.*BPs)./BPr;
        PisinB=nanmean(BPs_r,'all');

        Aprob(i)=PisinA/(PisinA+PisinB);
  
    end
    for i=1:size(TestB,1)
        temp=squeeze(SubscritRef(i,TestB));
        
        Pr_s=temp.*TrainA+(1-temp).*(1-TrainA);
        Ps=0.5;
        Pr=temp.*Total+(1-temp).*(1-Total);
        Ps_r=(Pr_s.*Ps)./Pr;
        PisinA=nanmean(Ps_r,'all');
        
        Pr_s=temp.*TrainB+(1-temp).*(1-TrainB);
        Ps=0.5;
        Pr=temp.*Total+(1-temp).*(1-Total);
        Ps_r=(Pr_s.*Ps)./Pr;
        PisinB=nanmean(Ps_r,'all');
        
        Bprob(i)=PisinB/(PisinA+PisinB);
    end
    
    PA(s)=nanmean(Aprob);
    PB(s)=nanmean(Bprob);
end
textprogressbar('done');
