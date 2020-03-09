function plot_W_sequences(W);


figure
s=size(W,2);
for i=1:size(W,2)
    subplot(1,s,i);
    imagesc(squeeze(W(:,i,:)));
end