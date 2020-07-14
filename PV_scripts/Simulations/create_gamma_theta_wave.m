function create_gamma_theta_wave()

f=8;   %frequency Hz
v=10;  %frequency modulation in %
a=50;  %amplitude modulation in %

theta=create_wave(f,v,a);
theta=theta*0.5;

f=8;   %frequency Hz
theta_mod=create_wave(f,v,a);
theta_mod=theta_mod-min(theta_mod);
theta_mod=theta_mod/max(theta_mod);
theta_mod=sigmoid(theta_mod*1000,900,0.01)*5+0.5;

f=80;

gamma=create_wave(f,v,a);
gamma=0.5*gamma.*theta_mod;
gamma=gamma/max(abs(gamma))*0.08;


out=theta+gamma+randn(1,numel(theta))*0.05;
o1=out';
gamma1=gamma';

%% CA3
f=6;   %frequency Hz
v=10;  %frequency modulation in %
a=50;  %amplitude modulation in %


theta=create_wave(f,v,a);
theta=theta*0.3;



f=6;   %frequency Hz
theta_mod=create_wave(f,v,a);
theta_mod=theta_mod-min(theta_mod);
theta_mod=theta_mod/max(theta_mod);
theta_mod=sigmoid(theta_mod*1000,900,0.01)*6+0.5;

f=80;

gamma=create_wave(f,v,a);
gamma=0.5*gamma.*theta_mod;
gamma=gamma/max(abs(gamma))*0.15;


out=theta+gamma+randn(1,numel(theta))*0.05;
o2=out';
gamma2=gamma';




plot(o1);hold on;plot(gamma1);
figure;plot(o2);hold on;plot(gamma2);







end

function out=create_wave(f,v,a)

w1=creat_wave_random_freq(f,v);
w2=creat_wave_random_freq(round(f*2/3),a);
w2=(w2+1)/2+0.3;
out=w1.*w2;
m=max(abs(out));
out=out/m;
end

function out=creat_wave_random_freq(f,v)
% out=creat_wave_random_freq(80);

f1_range=randn(1,f)*(f*v/100)+f;
f1=f1_range(randi([1 size(f1_range,2)],1,size(f1_range,2)));


A=1;
out=0;
for k=1:numel(f1)
    y1c=A*sin(2*pi/f1(k)*(0:0.01:f1(k)));
    out=[out y1c];
end
out=resample(out,1000,numel(out));

end