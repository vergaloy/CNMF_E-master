function [PVM]=PVD_matrix(obj)

b = nchoosek(1:size(obj,2),2);
PVM(1:size(obj,2),1:size(obj,2))=0;
for i=1:size(b,1)
   PVM(b(i,1),b(i,2))= MRPP(obj{b(i,1)},obj{b(i,2)},1000);
end
PVM=PVM+PVM';
end




