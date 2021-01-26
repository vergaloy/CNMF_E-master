function G=get_gradient_spline(D,x)


for i=1:size(D,1);
    
    y=D(i,:);
    spline1 = spap2(1,3,x,y);
    v = fnval(spline1,x);
    G(i,:)=v;
%     plot(x,y,'o');hold on;fnplt(spline1,'-',2);
end