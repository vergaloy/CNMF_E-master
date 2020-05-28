function out=create_mask(obj)
% all=create_mask(neuron);
[d1,d2]=size(obj.Cn);
obj.Coor=[];
 Coor = get_contours(obj, 0.6);
for i=1:size(Coor,1)
test=Coor{i, 1};    
bw(:,:,i) = poly2mask(test(1,:),test(2,:),d1,d2);
end

out=sum(bw,3);

 contour(out)