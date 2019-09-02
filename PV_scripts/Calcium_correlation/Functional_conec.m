function [cir_P,cir_cor,cir_sum,cir_shift]=Functional_conec(data,win,norm)
% cir_P=Functional_conec(sleepdata.mean.wake,300,0);
w=size(data,2)/win;
sim=1000;
max_shift=20; %% maximum frame shift between two neurons

combination=nchoosek(1:size(data,1),2);
cir_cor={};
cir_sum={};
cir_P(1:size(data,1),1:size(data,1))=0;
cir_shift(1:size(data,1),1:size(data,1))=0;
disp('Getting correlations...      ')

for c=1:size(combination,1)
    fprintf('\b\b\b\b\b\b\b\b..%05.1f%%', 100*c/size(combination,1))
    cR=[];
    for i=1:w
        
        if (combination(c,1)==10&combination(c,2)==11)
           dummy=2;
        end
        temp1=data(combination(c,1),(i-1)*win+1:i*win);
        temp2=data(combination(c,2),(i-1)*win+1:i*win);
        [~,temp_c]=CXCORR(temp1,temp2);
        cR(:,i)=temp_c';
    end
    cR=circshift(cR,win/2,1);
    cR=cR(win/2+1-max_shift:win/2+1+max_shift,:);
    if (norm==1)
        ma=max(cR,[],1);
        cR=cR./ma;
    end
    cir_cor{combination(c,1),combination(c,2)}=cR;
    max_cor=max(nansum(cR,2));
    cir_sum{combination(c,1),combination(c,2)}= nansum(cR,2);
    T(1:sim)=0;
    for s=1:sim
        T(s)=max(nansum(circshift_columns(cR),2));
    end
    T=sort(T);
    try
        if (max_cor>max(T))
            Prob=1-1/sim;
        else
            Prob=find(T>=max_cor,1)/sim;
        end
        
        if (isempty(Prob))
            Prob=0;
        end
        cir_P(combination(c,1),combination(c,2))=Prob;
        cir_shift(combination(c,1),combination(c,2))=find(max_cor==nansum(cR,2),1)-(max_shift+1);
    catch
        dummy=1
    end
end
imagesc(cir_P)
colorbar
caxis([0.95 1])
[ ~, thres] = FDR(1-squareform(cir_P'+cir_P,'tovector'), 0.05);
cir_P(cir_P<1-thres)=0;
cir_shift(cir_P<1-thres)=-10*max_shift;
cir_shift=cir_shift+10*max_shift;
cir_shift=(cir_shift+cir_shift')-10*max_shift;
cir_shift = cir_shift - diag(diag(cir_shift));
cir_shift(cir_shift==-10*max_shift)=nan;
figure
imagesc(cir_P)
colorbar
caxis([0.95 1])