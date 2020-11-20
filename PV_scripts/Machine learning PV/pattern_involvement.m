function CI=pattern_involvement(Rep,Pid,Pat,ind)

I=zeros(size(Pat,1),1);
I(ind)=1;
alpha=5;
for i=1:size(Rep,2)
  ix=find(Rep(:,i));
  A=zeros(size(Pat,1),1);
  for j=1:size(ix,1)
    A=A+median(Pat(:,ismember(Pid,ix(j))),2);
  end
  A=A>0;
  CI(i,:)=overlapping_CI(I,A,alpha);   
end
end



function CI=overlapping_CI(I,A,alpha)
T=[I,A];
parfor s=1:10000
    t=datasample(T,size(T,1),1);
    O(s)=get_overlap_above_chance(t(:,1),t(:,2));
end
CI=[get_overlap_above_chance(I,A),prctile(O,100-alpha/2),prctile(O,alpha/2)];
end


function O=get_overlap_above_chance(I,A);
O=mean(I.*A)/(mean(A)*mean(I));
end
