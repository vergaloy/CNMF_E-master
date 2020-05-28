
function [M,P]=get_pwelch_sleep(E)
% [M,P]=get_pwelch_sleep(E);
MR=[];
MHT=[];
MLT=[];
MN=[];
PR=[];
PHT=[];
PLT=[];
PN=[];
for i=1:size(E,1)
    [mt,pt]=get_power(E{i, 1}.R);
    MR=[MR;mt];
    PR=[PR;pt];
    
    [mt,pt]=get_power(E{i, 1}.HT);
    MHT=[MHT;mt];
    PHT=[PHT;pt];
    
    [mt,pt]=get_power(E{i, 1}.LT);
    MLT=[MLT;mt];
    PLT=[PLT;pt];
    
    [mt,pt]=get_power(E{i, 1}.N);
    MN=[MN;mt];
    PN=[PN;pt];   
end
M=[MR,MHT,MLT,MN];
P=[PR,PHT,PLT,PN];
end


function [M,P,C,Cr]=get_power(A)
Fs=5;
bin=2;
for i=1:size(A,1)
    temp=A(i,:);
%     stackedplot(padcat(A{3,1},A{3,2})')
    if (size(temp,2)>1)
    temp=padcat(temp{:});
    else
     temp=temp{:};
    end
    temp=bin_data(temp,Fs,bin);
    
    B=get_xcorr(temp);
    [C(i,:),f]=FFT_PV(B,1/bin);
    
   Cr(i,:)=random_shuff(temp,bin);
  
end
i1=find(f>20,1);
i2=find(f>75,1);
M=nanmax(C(:,i1:i2),[],2)-nanmax(Cr(:,i1:i2),[],2);
P=nansum(C(:,i1:i2),2);
end


function C=get_xcorr(B)

for i=1:size(B,1)
    temp2=B(i,:);
    temp2(isnan(temp2))=[];
    temp2=xcorr(temp2,'normalized');
    temp2=temp2(round(length(temp2)/2)+1:end);
    C{i,1}=temp2;
end
if (size(C,1)>1)
C=padcat(C{:});
else
    C=C{:};
end
C=nanmean(C,1);
end 


function B=random_shuff(x,bin)

    for s=1:100
        len=size(x,2);
        temp=datasample(x,len,2,'Replace',false);
        temp=get_xcorr(temp);
        sur(s,:)=FFT_PV(temp,1/bin);
    end
    B=prctile(sur,95,1);
    B=B./sum(B);
    
end

    