function [A,B,h,P]=sparse_boostrap(A,B,paired,use_median,correct_mc,divide_plot);
%[A,B,h,P]=sparse_boostrap(C{1,1},C{1,2},1);
sim=10000;
n=size(A,1);
bootstrap=zeros(n,sim);

if (paired==0)
for s=1:sim  
    Ab = datasample(A,size(A,2),2,'Replace',true);
    Bb = datasample(B,size(B,2),2,'Replace',true);
    if (use_median==1)
     bootstrap(:,s)=median(Ab,2)-median(Bb,2);   
    else
    bootstrap(:,s)=mean(Ab,2)-mean(Bb,2);
    end
end

else  %if data is paired
    At=A-B;
    Bb=At*0;
    for s=1:sim
        Ab = datasample(At,size(A,2),2,'Replace',true);
        if (use_median==1)
            bootstrap(:,s)=median(Ab,2)-median(Bb,2);
        else
            bootstrap(:,s)=mean(Ab,2)-mean(Bb,2);
        end
    end
end    
z=(bootstrap==0);
z=mean(z,2);
z=z>0.05;   
    
    

clear textprogressbar
warning('off','all')
textprogressbar('Getting density kernel of boostrap samples: ');
for i=1:n
    textprogressbar(i/n*100);
    temp=abs(bootstrap(i,:));
    if (z(i)~=1)
        [density,xmesh] = ksdensity(temp,linspace(-0.1,max(temp),10000));
        density=density/max(density);
        try
            P(i)=density(find(xmesh>0,1));
        catch
            dummy=1
        end
    else
        P(i)=1;
    end
end
textprogressbar('done');


P(z)=1;

if (correct_mc==1)
 [ind,~] = FDR(P,0.05,0);
else
    ind=find(P<0.05);
end

h=zeros(1,n); h(ind)=1;h=logical(h);
M=mean(bootstrap,2);M(M>0)=1;M(M<0)=-1;
M=M.*(1-P)';
[~,I]=sort(M);
h=h(I);
A=A(I,:);
B=B(I,:);
% P=P(I);

if (divide_plot==0)
imagesc([A,B]);
hold on
x1=0;
x2=size(A,2)+size(B,2)+1;
y1=find(h==0,1)-0.5;
y2=find(h==0,1,'last')+0.5;
x = [x1, x2, x2, x1, x1];
y = [y1, y1, y2, y2, y1];
plot(x, y, 'b-', 'LineWidth', 1);
colormap('hot')
else
imagesc([A(:,1:size(A,2)/2),B,A(:,size(A,2)/2+1:size(A,2))]);
colormap('hot')
hold on
x1=0;
x2=size(A,2)+size(B,2)+1;
y1=find(h==0,1)-0.5;
y2=find(h==0,1,'last')+0.5;
x = [x1, x2, x2, x1, x1];
y = [y1, y1, y2, y2, y1];
plot(x, y, 'b-', 'LineWidth', 1);  

x1=size(A,2)/2+0.5;
x2=size(A,2)/2+size(B,2)+0.5;
y1=0;
y2=size(A,1);
x = [x1, x2, x2, x1, x1];
y = [y1, y1, y2, y2, y1];
plot(x, y, 'w-', 'LineWidth', 1);  

end





