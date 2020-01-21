function stackedplotPV(obj)

figure
hold on
offset=std(mean(obj,1))*5;
for i=1:size(obj,1)
    of=offset*(i-1);
    plot(obj(i,:)+of)
end