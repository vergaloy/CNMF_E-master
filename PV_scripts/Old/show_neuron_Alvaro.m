
A=neuron.A;
Amask = (A>0);

prompt = 'Neuron # to display??    ';
num = input(prompt);
prompt = 'Plot all neurons? 1=yes 0=no     ';
plot_all = input(prompt);

figure
neuron.image(A(:, num).*Amask(:, num));

if plot_all==1
    T(size(A,1),1)=0;
    for i=1:size(A,2)
        T=T+A(:,i) ;
    end
    T=reshape(T,[size(neuron.Cn,1) size(neuron.Cn,2)]);
    figure
    imagesc(T)
end


