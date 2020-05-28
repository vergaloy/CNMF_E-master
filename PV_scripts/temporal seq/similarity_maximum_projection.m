function performance=similarity_maximum_projection(X1,X2)
% performance=similarity_maximum_projection(X3,X4)
thr=0.7*7;
M1=single(X1>=thr);
M2=single(X2>=thr);

sim_concatenated=dot(M1(:),M2(:))/(norm(M1(:))*norm(M2(:))+eps);

options_rigid = NoRMCorreSetParms('d1',size(X1,1),'d2',size(X2,2),'max_shift',30,'init_batch',1);
[M,~,~,~] = normcorre_test(cat(3,M1,M2),options_rigid);
MC1=M(:,:,1);
MC2=M(:,:,2);

sim_MC=dot(MC1(:),MC2(:))/(norm(MC1(:))*norm(MC2(:))+eps);

performance=sim_concatenated/sim_MC;