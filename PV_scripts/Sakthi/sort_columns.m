function obj=sort_columns(obj)

for i=1:size(obj,2)
    obj(:,i)=sort(obj(:,i),'descend');
end