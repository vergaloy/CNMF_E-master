A=neuron.A;
Amask = (A>0);
ctr = neuron.estCenter();
v=[1;9;4;6;14;17];
gSiz=5;
for i=1:6
subplot(3,2,7-i)
neuron.image(A(:, v(i)).*Amask(:, v(i)));
colormap('gray');
    x0 = ctr(v(i), 2);
    y0 = ctr(v(i), 1);
    if ~isnan(x0)
        xlim(x0+[-gSiz, gSiz]*2);
        ylim(y0+[-gSiz, gSiz]*2);
    end
end