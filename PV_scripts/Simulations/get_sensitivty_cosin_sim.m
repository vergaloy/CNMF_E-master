function get_sensitivty_cosin_sim(t)

x=linspace(0,1,20);

for i=1:20
       sens(i,:)=bootstrap(t>x(i),1);
end