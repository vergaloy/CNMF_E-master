function print_sim_results(ward,average,complete,centroid)
cprintf('*blue','Ward \n')
M=ward{1, 2}; M=M(1:5,:)>0;O(1,:)=1-bootstrap(M(:));
M=ward{1, 2}; M=M(6:9,:)>0;O(2,:)=1-bootstrap(M(:));
M=ward{1, 2}; M=M(10:12,:)>0;O(3,:)=1-bootstrap(M(:));
M=ward{1, 2}; M=M(13:14,:)>0;O(4,:)=1-bootstrap(M(:));
M=ward{1, 2}; M=M(15:end,:)>0;O(5,:)=bootstrap(M(:));
M=ward{1, 2};M=[M(1:14,:)==0;M(15:end,:)>0];O(6,:)=bootstrap(M(:));
M=ward{1, 2};M=[M(1:12,:)==0;M(15:end,:)>0];O(7,:)=bootstrap(M(:));
O


cprintf('*blue','Average \n')
M=average{1, 2}; M=M(1:5,:)>0;O(1,:)=1-bootstrap(M(:));
M=average{1, 2}; M=M(6:9,:)>0;O(2,:)=1-bootstrap(M(:));
M=average{1, 2}; M=M(10:12,:)>0;O(3,:)=1-bootstrap(M(:));
M=average{1, 2}; M=M(13:14,:)>0;O(4,:)=1-bootstrap(M(:));
M=average{1, 2}; M=M(15:end,:)>0;O(5,:)=bootstrap(M(:));
M=average{1, 2};M=[M(1:14,:)==0;M(15:end,:)>0];O(6,:)=bootstrap(M(:));
M=average{1, 2};M=[M(1:12,:)==0;M(15:end,:)>0];O(7,:)=bootstrap(M(:));
O


cprintf('*blue','complete \n')
M=complete{1, 2}; M=M(1:5,:)>0;O(1,:)=1-bootstrap(M(:));
M=complete{1, 2}; M=M(6:9,:)>0;O(2,:)=1-bootstrap(M(:));
M=complete{1, 2}; M=M(10:12,:)>0;O(3,:)=1-bootstrap(M(:));
M=complete{1, 2}; M=M(13:14,:)>0;O(4,:)=1-bootstrap(M(:));
M=complete{1, 2}; M=M(15:end,:)>0;O(5,:)=bootstrap(M(:));
M=complete{1, 2};M=[M(1:14,:)==0;M(15:end,:)>0];O(6,:)=bootstrap(M(:));
M=complete{1, 2};M=[M(1:12,:)==0;M(15:end,:)>0];O(7,:)=bootstrap(M(:));
O

cprintf('*blue','centroid \n')
M=centroid{1, 2}; M=M(1:5,:)>0;O(1,:)=1-bootstrap(M(:));
M=centroid{1, 2}; M=M(6:9,:)>0;O(2,:)=1-bootstrap(M(:));
M=centroid{1, 2}; M=M(10:12,:)>0;O(3,:)=1-bootstrap(M(:));
M=centroid{1, 2}; M=M(13:14,:)>0;O(4,:)=1-bootstrap(M(:));
M=centroid{1, 2}; M=M(15:end,:)>0;O(5,:)=bootstrap(M(:));
M=centroid{1, 2};M=[M(1:14,:)==0;M(15:end,:)>0];O(6,:)=bootstrap(M(:));
M=centroid{1, 2};M=[M(1:12,:)==0;M(15:end,:)>0];O(7,:)=bootstrap(M(:));
O

end

