function print_results_poster(A,H_NMF,W_NMF)

for i=1:size(A,2)
   activity(:,i)=mean(A{1, i},2)/2;
end

for i=1:size(A,2)
    if(~isempty(H_NMF{1, i}))
        Pattern{i}=mean(H_NMF{1, i},2);
    else
        Pattern{i}=0;
    end
end

for i=1:size(A,2)
    if(~isempty(H_NMF{1, i}))
        total=0;
        pat=0;
        for k=1:size(H_NMF{1, i},1)
            W=W_NMF{1, i};
            H=H_NMF{1, i};
            temp=A{1, i};
            temp=temp(W(:,k)>0,:);
            total=sum(temp,'all');
            pat=sum(temp(:,H(k,:)>0),'all');
            Pattern_temp(k,1)=pat/total;
        end
        Pattern_ratio{i}=Pattern_temp;
    else
        Pattern_ratio{i}=0;
    end
end

for i=1:size(A,2)
    W=W_NMF{1, i};
    W=sum(W,2);
    W(W>0)=1;
    temp=A{1, i};
    pat=temp(logical(W),:);
    no_pat=temp(~logical(W),:);
    if(isempty(pat))
        activity_pat{:,i}=zeros(size(temp,1),1);
    else
        activity_pat{:,i}=mean(pat,2)/2;
    end
    
    if(isempty(no_pat))
        activity_no_pat{:,i}=zeros(size(temp,1),1);
    else
        activity_no_pat{:,i}=mean(no_pat,2)/2;
    end
    
end
Pattern=padcat(Pattern{:});
Pattern_ratio=padcat(Pattern_ratio{:});
activity_pat=padcat(activity_pat{:});
activity_no_pat=padcat(activity_no_pat{:});

activity

Pattern

Pattern_ratio

activity_pat

activity_no_pat




    
    
    
    
    
    
    
    

