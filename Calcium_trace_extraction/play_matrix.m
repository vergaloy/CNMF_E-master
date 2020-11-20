function play_matrix(vid,t)
% play_matrix(V,M);
dx=100;
t=[min(t).*ones(1,dx),t,min(t).*ones(1,dx)];
dummy=1;
videofig(size(vid,3), @(f) redraw(f,vid,t));
redraw(1,vid,t)
end


function redraw(f,vid,t)

dx=(length(t)-size(vid,3))/2;

temp=vid(:,:,f);
s1=prctile(temp(:),5);
s2=prctile(temp(:),99);
n1=size(temp,1);
n2=round(n1*0.25);

temp=cat(1,temp,zeros(n2,size(temp,2)));
imshow(temp,[s1 s2]);hold on
t=rescale(-1*t)*n2+n1;
t=t(f:f+2*dx);
t=interp1(t,linspace(1,201,size(vid,2))); 
% x=linspace(1,201,length(t));
plot(t);
xline(ceil(size(vid,2)/2));
hold off
end


