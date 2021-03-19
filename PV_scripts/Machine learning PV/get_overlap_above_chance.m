function CI=get_overlap_above_chance(V1,V2,comp)
if ~exist('comp','var')
    comp=1;
end

V1=reshape(V1,length(V1),1);
V2=reshape(V2,length(V2),1);
sim=10000;
for i=1:sim
v=datasample([V1,V2],size(V1,1),1);
O(i)=get_overlap_chance(v(:,1),v(:,2));
end
CI=[get_overlap_chance(V1,V2),prctile(O,100-(5/comp/2)),prctile(O,(5/comp/2))];

end
function O=get_overlap_chance(V1,V2)
O=mean(V1.*V2)./(mean(V1)*mean(V2)); 
end