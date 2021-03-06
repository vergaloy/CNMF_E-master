function [P]=Block_boostrap(DataC,DataT,window,sims,tails)
%[P]=Block_boostrap(neuron.S(:,1:600*5.01),neuron.S(:,5.01*981:5.01*1580),300,1000,1)
P(1:size(DataC,1))=0;
for n=1:size(DataC,1)
    Data1=DataC(n,:);
    Data2=DataT(n,:);
    
    means(1:sims)=0;
    temp1=0;
    temp2=0;
    for i=1:sims
        i0=1;
        for w=1:size(Data1,2)/window
            s=ceil(rand*size(Data1,2));
            f=ceil(geornd(1/window));
            if (f+s>size(Data1))
                f=size(Data1,2)-s;
            end
            temp1(i0:f+i0)=Data1(s:s+f);
            i0=f+i0;
        end
        i0=1;
        for w=1:size(Data2,2)/window
            s=ceil(rand*size(Data2,2));
            f=ceil(geornd(1/window));
            if (f+s>size(Data2,2))
                f=size(Data2,2)-s;
            end
            temp2(i0:f+i0)=Data2(s:s+f);
            i0=f+i0;
        end
        means(i)=mean(temp1)-mean(temp2)+rand(1)/100000000;
        temp1=[];
        temp2=[];
    end
    means=sort(means,'descend');
    
    
    x=find(means<0,1);
    if (isempty(x))
        x=sims;
    end
    
    if (tails==2)
        p=1-abs(x-1-sims/2)/(sims/2);
        
        if (p==0)
            p=2/sims;
        end
        P(n)=p;
    end
    
    if (tails==1)
        p=(x-1)/sims;
        if (p==0)
            p=1/sims;
        end
        P(n)=p;
    end
    
end