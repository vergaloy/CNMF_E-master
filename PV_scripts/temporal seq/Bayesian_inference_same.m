function [PA,PB]=Bayesian_inference_same(A,B,order,sim)
%    [PAs,PBs]=Bayesian_inference_same(C{1,3},C{1,8},2,100);

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
U=cat(1,A,B);
for s=1:sim
    textprogressbar(s/sim*100);
 
    y1 = randsample(size(U,1),floor(size(U,1)*0.9));
    x1=setdiff(1:size(U,1),y1,'stable');
    
    Total=SubscritRef(y1,U);
    TestU=SubscritRef(x1,U);
    
    TrainA=SubscritRef(1:floor(size(Total,1)/2),Total);   
    TrainB=SubscritRef(floor(size(Total,1)/2)+1:size(Total),Total);        
    TestA=SubscritRef(1:floor(size(TestU,1)/2),TestU);
    TestB=SubscritRef(floor(size(TestU,1)/2)+1:size(TestU,1),TestU);

    
    if (order<2)
    
    TrainA=squeeze(mean(TrainA,1));
    TrainB=squeeze(mean(TrainB,1));
    Total=squeeze(mean(Total,1));
    
    else     
    TrainA=ND_prob(TrainA,order);   
    TrainB=ND_prob(TrainB,order); 
    Total=ND_prob(Total,order);       
    end
    
%    Total(Total==0)=nan;
  
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
        
        Bprob(i)=PisinB/(PisinB+PisinA);
    end
    
    PA(s)=nanmean(Aprob);
    PB(s)=nanmean(Bprob);
end
textprogressbar('done');
