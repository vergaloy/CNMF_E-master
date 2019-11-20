function [A,W_NMF,H_NMF,pat_cells]=Functional_connectivity_PV(obj,hypno)
%[matrix,W_NMF]=PVD_matrix(temp_bin,hypno)
min_pat=4;  %minimal amount of cells coactivated

obj=full(obj);
obj(obj>0)=1;
obj=moving_mean(obj,5.01,2,1/5.01,0);
obj=obj./rms(obj,2);
sf=5.01;

%%
j=1;
A{j}=obj(:,1:round(sf*600));

NumberOfAssemblies= get_patterns(A{j});
if (NumberOfAssemblies~=0)
[W_NMF{j},~,~]=NMF(A{j},NumberOfAssemblies);
else
    W_NMF{j}=zeros(size(obj,1),1);
end
[H_NMF{j}]=get_H(A{j},W_NMF{j},min_pat);
kill_inactive=logical(sum(H_NMF{j},2)==0);
H=H_NMF{j};
H(kill_inactive,:)=[];
H_NMF{j}=H;
W=W_NMF{j};
W(:,kill_inactive)=[];
W_NMF{j}=W;
pat_cells{j}=plot_W_connectivity(W_NMF{j});
plot_W_activity(A{j},W_NMF{j},H_NMF{j});
drawnow
%%
j=2;
A{j}=obj(:,round(sf*600+1):round(sf*1200));

NumberOfAssemblies= get_patterns(A{j});
if (NumberOfAssemblies~=0)
[W_NMF{j},~,~]=NMF(A{j},NumberOfAssemblies);
else
    W_NMF{j}=zeros(size(obj,1),1);
end
[H_NMF{j}]=get_H(A{j},W_NMF{j},min_pat);
kill_inactive=logical(sum(H_NMF{j},2)==0);
H=H_NMF{j};
H(kill_inactive,:)=[];
H_NMF{j}=H;
W=W_NMF{j};
W(:,kill_inactive)=[];
W_NMF{j}=W;
pat_cells{j}=plot_W_connectivity(W_NMF{j});
plot_W_activity(A{j},W_NMF{j},H_NMF{j});
drawnow
%%
j=3;
A{j}=obj(:,round(sf*1200+1):round(sf*1500));
NumberOfAssemblies= get_patterns(A{j});
if (NumberOfAssemblies~=0)
[W_NMF{j},~,~]=NMF(A{j},NumberOfAssemblies);
else
    W_NMF{j}=zeros(size(obj,1),1);
end
[H_NMF{j}]=get_H(A{j},W_NMF{j},min_pat);
kill_inactive=logical(sum(H_NMF{j},2)==0);
H=H_NMF{j};
H(kill_inactive,:)=[];
H_NMF{j}=H;
W=W_NMF{j};
W(:,kill_inactive)=[];
W_NMF{j}=W;
pat_cells{j}=plot_W_connectivity(W_NMF{j});
plot_W_activity(A{j},W_NMF{j},H_NMF{j});
drawnow
%%
sleepdata=separate_by_sleep(obj(:,round(sf*1500+1):round(sf*10500)),hypno(round(sf*1500+1):round(sf*10500)));
%%
j=4;
A{j}=sleepdata.wake;
NumberOfAssemblies= get_patterns(A{j});
if (NumberOfAssemblies~=0)
[W_NMF{j},~,~]=NMF(A{j},NumberOfAssemblies);
else
    W_NMF{j}=zeros(size(obj,1),1);
end
[H_NMF{j}]=get_H(A{j},W_NMF{j},min_pat);
kill_inactive=logical(sum(H_NMF{j},2)==0);
H=H_NMF{j};
H(kill_inactive,:)=[];
H_NMF{j}=H;
W=W_NMF{j};
W(:,kill_inactive)=[];
W_NMF{j}=W;
pat_cells{j}=plot_W_connectivity(W_NMF{j});
plot_W_activity(A{j},W_NMF{j},H_NMF{j});
drawnow
%%
j=5;
A{j}=sleepdata.rw;
NumberOfAssemblies= get_patterns(A{j});
if (NumberOfAssemblies~=0)
[W_NMF{j},~,~]=NMF(A{j},NumberOfAssemblies);
else
    W_NMF{j}=zeros(size(obj,1),1);
end
[H_NMF{j}]=get_H(A{j},W_NMF{j},min_pat);
kill_inactive=logical(sum(H_NMF{j},2)==0);
H=H_NMF{j};
H(kill_inactive,:)=[];
H_NMF{j}=H;
W=W_NMF{j};
W(:,kill_inactive)=[];
W_NMF{j}=W;
pat_cells{j}=plot_W_connectivity(W_NMF{j});
plot_W_activity(A{j},W_NMF{j},H_NMF{j});
drawnow
%%
j=6;
A{j}=sleepdata.rem;
NumberOfAssemblies= get_patterns(A{j});
if (NumberOfAssemblies~=0)
[W_NMF{j},~,~]=NMF(A{j},NumberOfAssemblies);
else
    W_NMF{j}=zeros(size(obj,1),1);
end
[H_NMF{j}]=get_H(A{j},W_NMF{j},min_pat);
kill_inactive=logical(sum(H_NMF{j},2)==0);
H=H_NMF{j};
H(kill_inactive,:)=[];
H_NMF{j}=H;
W=W_NMF{j};
W(:,kill_inactive)=[];
W_NMF{j}=W;
pat_cells{j}=plot_W_connectivity(W_NMF{j});
plot_W_activity(A{j},W_NMF{j},H_NMF{j});
drawnow
%%
j=7;
A{j}=sleepdata.nrem;
NumberOfAssemblies= get_patterns(A{j});
if (NumberOfAssemblies~=0)
[W_NMF{j},~,~]=NMF(A{j},NumberOfAssemblies);
else
    W_NMF{j}=zeros(size(obj,1),1);
end
[H_NMF{j}]=get_H(A{j},W_NMF{j},min_pat);
kill_inactive=logical(sum(H_NMF{j},2)==0);
H=H_NMF{j};
H(kill_inactive,:)=[];
H_NMF{j}=H;
W=W_NMF{j};
W(:,kill_inactive)=[];
W_NMF{j}=W;
pat_cells{j}=plot_W_connectivity(W_NMF{j});
plot_W_activity(A{j},W_NMF{j},H_NMF{j});
drawnow
%%
j=8;
A{j}=obj(:,round(sf*10500+1):round(sf*11100));
NumberOfAssemblies= get_patterns(A{j});
if (NumberOfAssemblies~=0)
[W_NMF{j},~,~]=NMF(A{j},NumberOfAssemblies);
else
    W_NMF{j}=zeros(size(obj,1),1);
end
[H_NMF{j}]=get_H(A{j},W_NMF{j},min_pat);
kill_inactive=logical(sum(H_NMF{j},2)==0);
H=H_NMF{j};
H(kill_inactive,:)=[];
H_NMF{j}=H;
W=W_NMF{j};
W(:,kill_inactive)=[];
W_NMF{j}=W;
pat_cells{j}=plot_W_connectivity(W_NMF{j});
plot_W_activity(A{j},W_NMF{j},H_NMF{j});
drawnow
%%
j=9;
A{j}=obj(:,round(sf*11100+1):round(sf*11700));
NumberOfAssemblies= get_patterns(A{j});
if (NumberOfAssemblies~=0)
[W_NMF{j},~,~]=NMF(A{j},NumberOfAssemblies);
else
    W_NMF{j}=zeros(size(obj,1),1);
end
[H_NMF{j}]=get_H(A{j},W_NMF{j},min_pat);
kill_inactive=logical(sum(H_NMF{j},2)==0);
H=H_NMF{j};
H(kill_inactive,:)=[];
H_NMF{j}=H;
W=W_NMF{j};
W(:,kill_inactive)=[];
W_NMF{j}=W;
pat_cells{j}=plot_W_connectivity(W_NMF{j});
plot_W_activity(A{j},W_NMF{j},H_NMF{j});
drawnow

    