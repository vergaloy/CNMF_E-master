function [A,W_raw,W_NMF,H_NMF,pat_cells]=Functional_connectivity_PV(obj,hypno)
%[A,W_raw,W_NMF,H_NMF,pat_cells]=Functional_connectivity_PV(neuron.S,hypno)
min_pat=3;  %minimal amount of cells coactivated
pdfile=strcat('DBNs_connectivity8','.pdf');
obj=full(obj);
obj(obj>0)=1;
obj=moving_mean(obj,5.01,2,1/5.01,0);
%obj=obj./rms(obj,2);
sf=5.01;

%%
j=1;
A{j}=obj(:,1:round(sf*600));

NumberOfAssemblies= get_patterns(A{j});
if (NumberOfAssemblies~=0)
    [W_raw{j},W_NMF{j},~,~]=NMF(A{j},NumberOfAssemblies,min_pat);
else
    W_NMF{j}=zeros(size(obj,1),1);
    W_raw{j}=zeros(size(obj,1),1);
end
if (isempty( W_NMF{j}))
    W_NMF{j}=zeros(size(obj,1),1);
    H_NMF{j}=zeros(1,size(obj,2));
else
    [H_NMF{j}]=get_H(A{j},W_NMF{j},min_pat);
end
kill_inactive=logical(sum(H_NMF{j},2)==0);
H=H_NMF{j};
H(kill_inactive,:)=[];
H_NMF{j}=H;
W=W_NMF{j};
Wraw=W_raw{j};
W(:,kill_inactive)=[];
Wraw(:,kill_inactive)=[];
W_NMF{j}=W;
W_raw{j}=Wraw;
pat_cells{j}=plot_W_connectivity(W_NMF{j});
export_fig(pdfile, '-append');
plot_W_activity(A{j},W_NMF{j},H_NMF{j});
export_fig(pdfile, '-append');
drawnow
%%
j=2;
A{j}=obj(:,round(sf*600+1):round(sf*1200));

NumberOfAssemblies= get_patterns(A{j});
if (NumberOfAssemblies~=0)
    [W_raw{j},W_NMF{j},~,~]=NMF(A{j},NumberOfAssemblies,min_pat);
else
    W_NMF{j}=zeros(size(obj,1),1);
end
if (isempty( W_NMF{j}))
    W_NMF{j}=zeros(size(obj,1),1);
    H_NMF{j}=zeros(1,size(obj,2));
else
    [H_NMF{j}]=get_H(A{j},W_NMF{j},min_pat);
end
kill_inactive=logical(sum(H_NMF{j},2)==0);
H=H_NMF{j};
H(kill_inactive,:)=[];
H_NMF{j}=H;
W=W_NMF{j};
Wraw=W_raw{j};
W(:,kill_inactive)=[];
Wraw(:,kill_inactive)=[];
W_NMF{j}=W;
W_raw{j}=Wraw;
pat_cells{j}=plot_W_connectivity(W_NMF{j});
export_fig(pdfile, '-append');
plot_W_activity(A{j},W_NMF{j},H_NMF{j});
export_fig(pdfile, '-append');
drawnow
%%
j=3;
A{j}=obj(:,round(sf*1200+1):round(sf*1500));
NumberOfAssemblies= get_patterns(A{j});
if (NumberOfAssemblies~=0)
    [W_raw{j},W_NMF{j},~,~]=NMF(A{j},NumberOfAssemblies,min_pat);
else
    W_NMF{j}=zeros(size(obj,1),1);
    W_raw{j}=zeros(size(obj,1),1);
end
if (isempty( W_NMF{j}))
    W_NMF{j}=zeros(size(obj,1),1);
    H_NMF{j}=zeros(1,size(obj,2));
else
    [H_NMF{j}]=get_H(A{j},W_NMF{j},min_pat);
end
kill_inactive=logical(sum(H_NMF{j},2)==0);
H=H_NMF{j};
H(kill_inactive,:)=[];
H_NMF{j}=H;
W=W_NMF{j};
Wraw=W_raw{j};
W(:,kill_inactive)=[];
Wraw(:,kill_inactive)=[];
W_NMF{j}=W;
W_raw{j}=Wraw;
pat_cells{j}=plot_W_connectivity(W_NMF{j});
export_fig(pdfile, '-append');
plot_W_activity(A{j},W_NMF{j},H_NMF{j});
export_fig(pdfile, '-append');
drawnow
%%
sleepdata=separate_by_sleep(obj(:,round(sf*1500+1):round(sf*10500)),hypno(round(sf*1500+1):round(sf*10500)));
%%
j=4;
A{j}=sleepdata.wake;
NumberOfAssemblies= get_patterns(A{j});
if (NumberOfAssemblies~=0)
    [W_raw{j},W_NMF{j},~,~]=NMF(A{j},NumberOfAssemblies,min_pat);
else
    W_NMF{j}=zeros(size(obj,1),1);
    W_raw{j}=zeros(size(obj,1),1);
end
if (isempty( W_NMF{j}))
    W_NMF{j}=zeros(size(obj,1),1);
    H_NMF{j}=zeros(1,size(obj,2));
else
    [H_NMF{j}]=get_H(A{j},W_NMF{j},min_pat);
end
kill_inactive=logical(sum(H_NMF{j},2)==0);
H=H_NMF{j};
H(kill_inactive,:)=[];
H_NMF{j}=H;
W=W_NMF{j};
Wraw=W_raw{j};
W(:,kill_inactive)=[];
Wraw(:,kill_inactive)=[];
W_NMF{j}=W;
W_raw{j}=Wraw;
pat_cells{j}=plot_W_connectivity(W_NMF{j});
export_fig(pdfile, '-append');
plot_W_activity(A{j},W_NMF{j},H_NMF{j});
export_fig(pdfile, '-append');
drawnow
%%
j=5;
A{j}=sleepdata.rw;
NumberOfAssemblies= get_patterns(A{j});
if (NumberOfAssemblies~=0)
    [W_raw{j},W_NMF{j},~,~]=NMF(A{j},NumberOfAssemblies,min_pat);
else
    W_NMF{j}=zeros(size(obj,1),1);
    W_raw{j}=zeros(size(obj,1),1);
end
if (isempty( W_NMF{j}))
    W_NMF{j}=zeros(size(obj,1),1);
    H_NMF{j}=zeros(1,size(obj,2));
else
    [H_NMF{j}]=get_H(A{j},W_NMF{j},min_pat);
end
kill_inactive=logical(sum(H_NMF{j},2)==0);
H=H_NMF{j};
H(kill_inactive,:)=[];
H_NMF{j}=H;
W=W_NMF{j};
Wraw=W_raw{j};
W(:,kill_inactive)=[];
Wraw(:,kill_inactive)=[];
W_NMF{j}=W;
W_raw{j}=Wraw;
pat_cells{j}=plot_W_connectivity(W_NMF{j});
export_fig(pdfile, '-append');
plot_W_activity(A{j},W_NMF{j},H_NMF{j});
export_fig(pdfile, '-append');
drawnow
%%
j=6;
A{j}=sleepdata.rem;
NumberOfAssemblies= get_patterns(A{j});
if (NumberOfAssemblies~=0)
    [W_raw{j},W_NMF{j},~,~]=NMF(A{j},NumberOfAssemblies,min_pat);
else
    W_NMF{j}=zeros(size(obj,1),1);
    W_raw{j}=zeros(size(obj,1),1);
end
if (isempty( W_NMF{j}))
    W_NMF{j}=zeros(size(obj,1),1);
    H_NMF{j}=zeros(1,size(obj,2));
else
    [H_NMF{j}]=get_H(A{j},W_NMF{j},min_pat);
end
kill_inactive=logical(sum(H_NMF{j},2)==0);
H=H_NMF{j};
H(kill_inactive,:)=[];
H_NMF{j}=H;
W=W_NMF{j};
Wraw=W_raw{j};
W(:,kill_inactive)=[];
Wraw(:,kill_inactive)=[];
W_NMF{j}=W;
W_raw{j}=Wraw;
pat_cells{j}=plot_W_connectivity(W_NMF{j});
export_fig(pdfile, '-append');
plot_W_activity(A{j},W_NMF{j},H_NMF{j});
export_fig(pdfile, '-append');
drawnow
%%
j=7;
A{j}=sleepdata.nrem;
NumberOfAssemblies= get_patterns(A{j});
if (NumberOfAssemblies~=0)
    [W_raw{j},W_NMF{j},~,~]=NMF(A{j},NumberOfAssemblies,min_pat);
else
    W_NMF{j}=zeros(size(obj,1),1);
    W_raw{j}=zeros(size(obj,1),1);
end
if (isempty( W_NMF{j}))
    W_NMF{j}=zeros(size(obj,1),1);
    H_NMF{j}=zeros(1,size(obj,2));
else
    [H_NMF{j}]=get_H(A{j},W_NMF{j},min_pat);
end
kill_inactive=logical(sum(H_NMF{j},2)==0);
H=H_NMF{j};
H(kill_inactive,:)=[];
H_NMF{j}=H;
W=W_NMF{j};
Wraw=W_raw{j};
W(:,kill_inactive)=[];
Wraw(:,kill_inactive)=[];
W_NMF{j}=W;
W_raw{j}=Wraw;
pat_cells{j}=plot_W_connectivity(W_NMF{j});
export_fig(pdfile, '-append');
plot_W_activity(A{j},W_NMF{j},H_NMF{j});
export_fig(pdfile, '-append');
drawnow
%%
j=8;
A{j}=obj(:,round(sf*10500+1):round(sf*11100));
NumberOfAssemblies= get_patterns(A{j});
if (NumberOfAssemblies~=0)
    [W_raw{j},W_NMF{j},~,~]=NMF(A{j},NumberOfAssemblies,min_pat);
else
    W_NMF{j}=zeros(size(obj,1),1);
    W_raw{j}=zeros(size(obj,1),1);
end
if (isempty( W_NMF{j}))
    W_NMF{j}=zeros(size(obj,1),1);
    H_NMF{j}=zeros(1,size(obj,2));
else
    [H_NMF{j}]=get_H(A{j},W_NMF{j},min_pat);
end
kill_inactive=logical(sum(H_NMF{j},2)==0);
H=H_NMF{j};
H(kill_inactive,:)=[];
H_NMF{j}=H;
W=W_NMF{j};
Wraw=W_raw{j};
W(:,kill_inactive)=[];
Wraw(:,kill_inactive)=[];
W_NMF{j}=W;
W_raw{j}=Wraw;
pat_cells{j}=plot_W_connectivity(W_NMF{j});
export_fig(pdfile, '-append');
plot_W_activity(A{j},W_NMF{j},H_NMF{j});
export_fig(pdfile, '-append');
drawnow
%%
j=9;
A{j}=obj(:,round(sf*11100+1):round(sf*11700));
NumberOfAssemblies= get_patterns(A{j});
if (NumberOfAssemblies~=0)
    [W_raw{j},W_NMF{j},~,~]=NMF(A{j},NumberOfAssemblies,min_pat);
else
    W_NMF{j}=zeros(size(obj,1),1);
    W_raw{j}=zeros(size(obj,1),1);
end
if (isempty( W_NMF{j}))
    W_NMF{j}=zeros(size(obj,1),1);
    H_NMF{j}=zeros(1,size(obj,2));
else
    [H_NMF{j}]=get_H(A{j},W_NMF{j},min_pat);
end
kill_inactive=logical(sum(H_NMF{j},2)==0);
H=H_NMF{j};
H(kill_inactive,:)=[];
H_NMF{j}=H;
W=W_NMF{j};
Wraw=W_raw{j};
W(:,kill_inactive)=[];
Wraw(:,kill_inactive)=[];
W_NMF{j}=W;
W_raw{j}=Wraw;
pat_cells{j}=plot_W_connectivity(W_NMF{j});
export_fig(pdfile, '-append');
plot_W_activity(A{j},W_NMF{j},H_NMF{j});
export_fig(pdfile, '-append');
drawnow
close all
