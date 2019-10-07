function [Y, truth, trueSpikes] = gen_data_PV(gam, noise, T, b, N,trace)

trueSpikes=trace;
truth = double(trueSpikes);

p = length(gam); 
gam = [flipud(reshape(gam, [], 1)); 1]; 

for t=(p+1):T    
    truth(:, t) = truth(:, (t-p):t) * gam;
end 

Y = b + truth + noise * randn(N, T); 
        




















