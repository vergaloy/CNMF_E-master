function [V,R,M]=remove_frames_with_exesive_motion(V)
% [V2,R,M]=remove_frames_with_exesive_motion(V);
M=get_motion(V);
R=M>std(M)*8;

for i=1:10
R=(R+circshift(R,1))>0;
R=(R+circshift(R,-1))>0;
end

V=double(V);
V(:,:,R)=nan;
V=fillmissing(V,'linear',3,'EndValues','nearest');
sd=std(V(:,:,1:1000),[],3);
V(:,:,R)=V(:,:,R)+randn(size(V,1),size(V,2),sum(R)).*(sd/10);
end