function [cir_P,cir_cor,cir_sum,cir_shift]=Functional_conec(data,win,norm,correct_mc)
% cir_P=Functional_conec(sleepdata.mean.wake,300,0);
w=size(data,2)/win;
sim=100;
max_shift=100; %% maximum frame shift between two neurons

combination=nchoosek(1:size(data,1),2);
cir_cor={};
cir_sum={};
cir_P(1:size(data,1),1:size(data,1))=0;
cir_shift(1:size(data,1),1:size(data,1))=0;
disp('Getting correlations...      ')
%st=std(data,[],2);
%data=data./st;
for c=1:size(combination,1)
    fprintf('\b\b\b\b\b\b\b\b..%05.1f%%', 100*c/size(combination,1))
    cR=[];
    for i=1:w
        

        temp1=data(combination(c,1),(i-1)*win+1:i*win);
        temp2=data(combination(c,2),(i-1)*win+1:i*win);
        %stackedplot([temp1;temp2]');
        [temp_c,~]=xcov(temp1,temp2,win/2,'unbiased');  %CXCORR for correlation; for covariance
        cR(:,i)=temp_c';
    end
  
   % cR=circshift(cR,win/2,1);
   % cR=cR(win/2+1-max_shift:win/2+1+max_shift,:);
    
    if (combination(c,1)==2&combination(c,2)==8)
           dummy=2;
    end
    
    
    if (norm==1)
    ma=nanmax(abs(cR),[],1);
    cR=cR./ma;
    cR(isnan(cR))=0;
    end  
    cir_cor{combination(c,1),combination(c,2)}=cR;
    [~,I]=max(nansum(cR,2));
    cir_sum{combination(c,1),combination(c,2)}= nansum(cR,2);
    cir_shift(combination(c,1),combination(c,2))=I-(max_shift+1);
    pks(1:sim)=0;
    for s=1:sim
       [~, pks(s)]=kstest2(nansum(circshift_columns(cR),2),nansum(cR,2));
    end
    pks=sort(1-pks);
    cir_P(combination(c,1),combination(c,2))=pks(floor(0.5*sim));
end
imagesc(cir_P)
colorbar
%caxis([0.95 1])
if (correct_mc==0)
    thres=0.05;
else
    [ ~, thres] = FDR(1-squareform(cir_P'+cir_P,'tovector')', 0.05);
end
cir_P(cir_P<1-thres)=0;
cir_shift=(cir_shift+cir_shift');
if (correct_mc==1)
    figure
    imagesc(cir_P)
    colorbar
    caxis([0.95 1])
end