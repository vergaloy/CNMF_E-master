function matrix2avi(matrix,fr,nam)
%matrix2avi(matrix,fr,nam)
b = size(matrix,3);
%figure(1)%open a figure
%pause(5); %adjust the figure size dont change the figure size in between displays
for j = 1:b
    imagesc(mat2gray(matrix(:,:,j)));
    colormap parula
    F(j) = getframe;    
end
movie(F)
v = VideoWriter(nam);
v.FrameRate=fr;
open(v)
writeVideo(v,F)
close(v)
close all
end
