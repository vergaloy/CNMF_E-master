function [W,H,clean]=pattern_cleaning(order,raw)
W(1:size(raw,1),1:size(order,2))=0;
H(1:size(order,2),1:size(raw,2))=0;
clean(1:size(raw,1),1:size(raw,2))=0;
for i=1:size(order,2)
    temp=raw;
    L=isnan(order(:,i));
    temp(L,:)=[];
    shift=order(~L,i);
    temp=circshift_columns(temp',shift')';
    temp=temp./max(temp,[],2);
    [W_t,H_t,~]=NMF(temp);   
    W(~L,i)=W_t;
    H(i,:)=H_t;
    H_t(H_t<std(H_t)*1)=0;
    W_t=(H_t'\temp')';   
    D=W_t*H_t;
    %Correl(1:size(temp,2))=0;
    %PCorrel(1:size(temp,2))=0;
    %for c=1:size(temp,2)
    % [Correl(c),PCorrel(c)]=corr(W_t,temp(:,c));   
    %end
    %PCorrel(isnan(PCorrel))=1;
    %[ ~, thres] = FDR(PCorrel',0.05);
    %PCorrel(PCorrel>thres)=1;
    %D(:,PCorrel>0.05)=0;
    D=circshift_columns(D',(shift*-1)')';
    clean(~L,:)=clean(~L,:)+D;
end
dummy=1;