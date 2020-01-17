function [out]=remove_single_spikes(active_set,m_iei)

s=diff(active_set(:,3));
n=1;
while (n<=size(active_set,1)-1)
    
    
    if (active_set(n,1)<0.5 && s(n)>m_iei)
        if (active_set(n+1,1)<0.5)
            active_set(n,:)=[];
            s(n)=[];
        else
            n=n+1;
        end
    else
        n=n+1;
    end
end
out=active_set;