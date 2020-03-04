function stackedplotPV(obj)

mouse_figure;
hold on
offset=1;
for i=1:size(obj,1)
    of=offset*(i-1);
    t=obj(i,:);
    t=t./max(t);
    plot(t+of)
end