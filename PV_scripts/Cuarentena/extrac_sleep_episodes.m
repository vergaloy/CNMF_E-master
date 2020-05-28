function E=extrac_sleep_episodes(mice_sleep,hyp,min_len)
% E=extrac_sleep_episodes(mice_sleep,hyp,300);

E={};
% REM
T=mice_sleep(:,4);
for m=1:size(T,1)
    obj=T{m, 1};
    hypno=hyp(m,:);
    E{m,1}.R=extract_episodes(obj,hypno,1,min_len);
end

% HT
T=mice_sleep(:,5);
for m=1:size(T,1)
    obj=T{m, 1};
    hypno=hyp(m,:);
    E{m,1}.HT=extract_episodes(obj,hypno,0.25,min_len);
end

% LT
T=mice_sleep(:,6);
for m=1:size(T,1)
    obj=T{m, 1};
    hypno=hyp(m,:);
    E{m,1}.LT=extract_episodes(obj,hypno,0,min_len);
end


% N
T=mice_sleep(:,7);
for m=1:size(T,1)
    obj=T{m, 1};
    hypno=hyp(m,:);
    E{m,1}.N=extract_episodes(obj,hypno,0.5,min_len);
end

end



function E=extract_episodes(obj,hypno,val,min_len)

regions = regionprops(hypno==val, hypno, 'PixelValues');
len=cellfun('length',struct2cell(regions));
E={};
t=0;
s=1;
for i=1:length(len)
    if (len(i)>min_len)
    E(:,s)=num2cell(obj(:,t+1:t+len(i)),2);
    s=s+1;
    t=t+len(i);
    end
end
end
    
    
    
    