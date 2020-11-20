function get_SVM_CI_diff(data1,data2,x1,x2)
% get_SVM_CI_diff(ABNs,DBNs,4,5);
d=zeros(size(data1,2),3);
for i=1:size(data1,2)
    temp=squeeze(data1{1, i}(x1,x2,:))-squeeze(data2{1, i}(x1,x2,:));
    d(i,:)=[mean(temp),prctile(temp,97.5),prctile(temp,2.5)];
end
   d 