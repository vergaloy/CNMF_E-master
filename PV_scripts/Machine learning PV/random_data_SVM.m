function [Ameansim,AAcc,AAcc2]=random_data_SVM()

n=2;
sd=0.1;
zero_p=0.8;
t=300;
sim=30;


for r=1:10
    for s=1:sim
        it=(0.99-zero_p)/sim;
        mean_amp =random('HalfNormal',5,sd,n,1);
        cov_m = randcorr(n);
        data=mvnrnd(mean_amp,cov_m,t*2)';
        d=random('Lognormal',1,0.5,n,1);
        d=d./max(d);
        mean_act=(d./mean(d)).*(1-zero_p);
        
        
        z = rando_binomial(mean_act,n,t);
        A=data(:,1:t);
        A=A.*z;
        A(isnan(A))=0;
        z = rando_binomial(mean_act-it*s,n,t);
        B=data(:,t+1:end);
        B=B.*z;
        B(isnan(B))=0;
        meansim(s)=corr(mean(A,2),mean(B,2),'Type','Spearman');
        C{1,1}=A;
        C{1,2}=B;
        Train=prepare_train_Data(C,[1,2]);
        [~,Acc(s)] = trainClassifierPV(Train,0);
        
        A2=multivariate_bootstrap(A',300)';
        B2=multivariate_bootstrap(B',300)';
        
        I=sum(B2==0,2);
        I=I+sum(isnan(B2),2);
        I=I>0;
        A2(I,:)=[];
        B2(I,:)=[];
        
        A2=zscore(A2);
        B2=zscore(B2);
        
        imagesc([A2,B2]);
        
        D{1,1}=A2;
        D{1,2}=B2;
        train2=prepare_train_Data(D,[1,2]);
        [~,Acc2(s)] = trainClassifierPV(train2,0);
    end
    AAcc(r,:)=Acc;
    AAcc2(r,:)=Acc2;
    Ameansim(r,:)=meansim;
end


end
function z=rando_binomial(M,n,t)
for i=1:n
    z(i,:)=random('Binomial',1,M(i),1,t);
end
end




