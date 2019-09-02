function [E,Out,P,pattern]=Find_correlated_cells(X,min_nei)

sim=1000;
disp('Finding correlated cells...')

disp('Estimating significant correlations by random permutations of bins...')
[Rcor] =corr(X');
Rcor_sim(1:sim)=0;
fprintf('..0%%')

for i=1:sim
    if (i/(sim/10)==floor(i/(sim/10)))       
        fprintf('..%d%%', i/(sim/10)*10)
    end
    rsample=reshape(X,[1,size(X,1)*size(X,2)]);
    rsample=randsample(rsample,2*size(X,2));
    rsample=reshape(rsample,[2,size(X,2)]);
    temp=corr(rsample');
    Rcor_sim(i)=temp(2,1);
end
Rcor_sim=sort(Rcor_sim);

Pcor=Rcor*0;
for i=1:size(Rcor,2)
    for j=1:size(Rcor,2)
        if (~isnan(Rcor(i,j)))
            try
                if (Rcor(i,j)>0)
                    Pcor(i,j)= find(Rcor(i,j)>=Rcor_sim(:),1,'last');
                else
                    Pcor(i,j)= 0;%  find(Rcor(i,j)*-1>=flip(Rcor_sim(i,j,:)*-1),1,'last'); %
                end
            catch                
                error=1
            end
        else
            Pcor(i,j)=0;
        end
    end
end
Pcor=Pcor/sim;
Pcor(Pcor<0.95)=0;

fprintf('\n ');
fprintf('\n ');
disp('Estimating significant correlations by shifting temporal traces...')

disp('Cells done:...')
P=Pcor*0;
for i=1:size(X,1)
    fprintf('..%d ', i);
    if ((i/20)==ceil(i/20))
        fprintf('\n ');
    end
    for j=1:size(X,1)
        if(Pcor(i,j)~=0)
            [~,r]=CXCORR(X(i,:),X(j,:));
            sample = datasample(r,sim);
            sample=sort(sample);
            if (i==j)
                P(i,j)=0;
            else
                try
                P(i,j)=find(r(1)>=sample,1,'last')/sim;
                catch
                    error=2
                end
            end
        end
 
    end
end

F=P.*Pcor;
F(F<0.95)=0;

%[ ~, thres] = FDR(1-squareform(F,'tovector'), 0.1);

F=graph(F,'lower');
fprintf('\nDeleting inconsistent correlation across neighbors...\n')
[~,pattern_neu,~,E,pattern]=Node_neighbors(F,min_nei);

Out=X;
Out(pattern_neu==0,:)=[]; %kill non pattern neurons
pattern(pattern_neu==0,:)=[];

figure
h=plot(E);
h.NodeColor = 'k';

h.LineWidth=2;
Edges=table2array(E.Edges(:,2));
Edges_num=unique(Edges);

L(1:length(Edges_num),1:size(E.Edges,1))=0;
L=logical(L)';
colors = distinguishable_colors(length(Edges_num));
for i=1:length(Edges_num)     
        L(Edges_num(i)==Edges(:),i)=1;   
        highlight(h,'Edges',L(:,i),'EdgeColor',colors(i,:));
end













