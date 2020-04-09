function W=get_pattern_loop_C(Y,hypno)
% W=get_pattern_loop_C(neuron.S,hypno);

Z=1:9;

for i=1:size(Z,2)
i
Z1 = Z(Z~=i);
[W{i},H{i},~]=Get_seqNMF(Y,hypno,Z1,3,0.99,0);
end
% A = cell2mat(W);

end