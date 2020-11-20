function par_test()

ppm = ParforProgressbar(1000*1000);
parfor i=1000
  in_par(ppm)   
end
end



function in_par(ppm)
for i=1:1000
pause(0.5)
ppm.increment();
end

end