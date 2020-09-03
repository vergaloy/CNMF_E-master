function get_SVM_CI(data,x1,x2)
% get_SVM_CI(out,1,2);
d=zeros(size(data,2),3);
for i=1:size(data,2)
    temp=squeeze(data{1, i}(x1,x2,:));
    d(i,:)=[mean(temp),prctile(temp,97.5),prctile(temp,2.5)];
end
   d 
    