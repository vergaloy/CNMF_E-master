tic
sim=1000;
type_I(1:sim)=0;
parfor n=1:sim
    s1=Simulated_calcium_trace(0.01);
    s2=Simulated_calcium_trace(0.01);
    type_I(n)=Block_boostrap(s1,s2,100,1000);
end
toc