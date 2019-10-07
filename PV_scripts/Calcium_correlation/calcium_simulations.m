function [NcT,MST,patT,NcSDV,MSSDV,patSDV]=calcium_simulations()
%[NcT,MST,patT,NcSDV,MSSDV,patSDV]=calcium_simulations();
tic
sims=5;
NcT(1:2,1:sims)=0;
MST(1:2,1:sims)=0;
patT(1:2,1:sims)=0;
NcSDV(1:2,1:sims)=0;
MSSDV(1:2,1:sims)=0;
patSDV(1:2,1:sims)=0;

try
    for s=1:sims
        s
        loop=5;
        Nc(1:2,1:loop)=0;
        MS(1:2,1:loop)=0;
        pat(1:2,1:loop)=0;
        for i=1:loop
            T = 30000;
            N = s*10;              % number of cells
            patterns=round(N/10);
            cellperpattern=[4 8];
            pattern_rate=0.0009;   %per frame
            non_pattern_rate=0.001;%per frame
            other_Cells_rate=0.002;%per frame
            Spike_per_burst=15;%per frame
            
            [trace,pattern]=make_spikes(N,T,patterns,cellperpattern,pattern_rate,non_pattern_rate,Spike_per_burst,other_Cells_rate);
            
            Wreal(1:size(trace,1),1:size(pattern,2))=0;
            for p=1:size(pattern,2)
                Wreal(pattern{p},p)=1;
            end
            
            NumberOfAssemblies = get_patterns(trace);
            
            [W_NMF,~]=NMF(trace,NumberOfAssemblies);
            W_NMF_clean=get_pattern_cells_from_NMF(W_NMF,3);
            Nc(1,i)=size(pattern,2)-size(W_NMF_clean,2);
            MS(1,i)=get_MS(Wreal,W_NMF_clean);
            pat(1,i)=get_MS(max(Wreal,[],2),max(W_NMF,[],2));
            
            [~,W_PCA,~,~,~]=functional_connectivty(trace,trace,3,0);
            Nc(2,i)=size(pattern,2)-size(W_PCA,2);
            MS(2,i)=get_MS(Wreal,W_PCA);
            pat(2,i)=get_MS(max(Wreal,[],2),max(W_PCA,[],2));
        end
        NcSDV(:,s)=std(Nc,0,2);
        MSSDV(:,s)=std(MS,0,2);
        patSDV(:,s)=std(pat,0,2);
        NcT(:,s)=mean(Nc,2);
        MST(:,s)=mean(MS,2);
        patT(:,s)=mean(pat,2);
        
    end
catch
    dummy=1
end
toc

