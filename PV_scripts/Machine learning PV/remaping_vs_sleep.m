function remaping_vs_sleep(data,active,Wc,pix,a,X,S)

sf=5;
bin=2;

 [out,hypno,N]=get_concantenated_data(data,sf,bin);
 out=out(active,:);
 
 
B=means_binned_data(out,10);
B=[mean(a(:,1:3),2),B];
% B=B(pix==2,:);
B=B./prctile(B,95,1);
B(B>1)=1;
B=B(:,2:11)-B(:,1);



end


function total_sleep_binned(hypno,out,



function B=means_binned_data(in,bsize)
lin=round(linspace(1,size(in,2),bsize+1));
for i=1:size(lin,2)-1
B(:,i)=mean(in(:,lin(i):lin(i+1)),2);   
end    
end




function out=sep_by_sleep(ob,h)
rem=ob;
rem(:,h~=1)=[];
rem=mean(rem,2);
rw=ob;
rw(:,h~=0.25)=[];
rw=mean(rw,2);
wake=ob;
wake(:,h~=0)=[];
wake=mean(wake,2);
nrem=ob;
nrem(:,h~=0.5)=[];
nrem=mean(nrem,2);

sleep=ob;
sleep(:,h<0.5)=[];
sleep=mean(sleep,2);

wake_all=ob;
wake_all(:,h>0.25)=[];
wake_all=mean(wake_all,2);
out=[rem,rw,wake,nrem,wake_all,sleep];
end



