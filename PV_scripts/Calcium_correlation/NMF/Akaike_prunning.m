function Akaike_prunning(W0,X)

min_ensamble=2;
dim=size(W0,1);
AICc(1:dim-min_ensamble)=0;
n(1:dim-min_ensamble)=0;
k(1:dim-min_ensamble)=0;
O(1:dim)=1;
for i=0:dim-min_ensamble
    % calculate RSS (Res) excluding the dim-i cell.
    Wt=W0(1:dim-i);
    if (i>0)
        N(1:i,1)=0;
        Wt=[Wt;N];
    end
    Ht=Wt\X;
    
    E=(X-Wt*Ht).^2;
    E=sum(E,2);
    res=sqrt(sum(E));
    % Estimate akaikes criterion for the current data set and model.
    nt=size(Wt,1)*size(Ht,2);
    kt=dim-i+size(Ht,2);
    
    n(dim-i-min_ensamble+1)=nt;
    k(dim-i-min_ensamble+1)=kt;
    AICc(dim-i-min_ensamble+1)=nt*log(res/nt)+2*kt+(2*kt*(kt+1))/(nt-kt-1);
    if (i>0)
       E=E.*O';
    end
    
    
    [~,I]=max(E);
    O(I)=0;
    W0(I,1)=0;
    
    imagesc(W0);
    l=1;
end

AIC
