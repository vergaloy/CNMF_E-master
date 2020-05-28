function Sshift=shift_video()
% Sshift=shift_video();
HC=h5read('C:\Users\BigBrain\Desktop\Tracking neuron\HC.h5','/Object');

comb=[0,1;1,1;1,0;1,-1;0,-1;-1,-1;-1,0;-1,-1];
M=HC(:,:,1:1500);
[Cn, PNR] = correlation_image_endoscope_PV2(M,5);
M=Cn.*PNR;
Sshift=zeros(size(comb,1),20);
upd = textprogressbar(20); 
for s=1:1:20    
    combtemp=comb.*s;
    A=M(1+s:end-s,1+s:end-s);
    sim=zeros(size(comb,1),1);
    for c=1:size(comb,1)
        Bv=HC(:,:,1501:end);
        Bv=circshift(Bv,combtemp(c,1),1);
        Bv=circshift(Bv,combtemp(c,2),2);
        Bv=Bv(1+s:end-s,1+s:end-s,:);
        [CnB, PNRB] = correlation_image_endoscope_PV2(Bv,5);
        B=CnB.*PNRB;
        sim(c)=similarity_maximum_projection(A,B);      
    end
Sshift(:,s)=sim;
upd(s);
end