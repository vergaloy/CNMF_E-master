%HH PV

clc;clear;close all;
cm= 1;  % membrane capacitance uF

Iext = 10; % current uA
totaltime= 100;
dt = 0.0001; % time step s

vm = -60; % intial membrane voltage
ENa = 55.17; 
EK = -72.14;
El =-49.42;

gNamax = 120; %max conductances m.mho/cm^2
gKmax = 56;
glmax = 0.3;


niter = totaltime/dt; % max number of iterations

% Intial conditions
V(1) = vm;

% calculating alphas abd betas for the intial membrane voltage
    alpn = 0.01*(vm+50)/(1-exp(-(vm+50)/10));
    alpm = 0.1*(vm+35)/(1-exp(-(vm+35)/10));
    alph = 0.07*exp(-0.05*(vm+60));
    betn = 0.125*exp(-(vm+60)/80);
    betm = 4*exp(-0.0556*(vm+60));
    beth = 1/(1+exp(-0.1*(vm+30)));


% intial m,n & h
n = alpn/(alpn+betn);
m = alpm/(alpm+betm);
h = alph/(alph+beth);

 gNa = gNamax*m^3*h;
 gK = gKmax*n^4;
 gl = glmax;

INa = gNa*(vm-ENa);
IK = gK*(vm-EK);
Il = gl*(vm-El);
  INat(1)=INa;
  IKt(1)=IK;
  Ilt(1)=Il;

% the loop for calculation of membrane voltage dynamics is here.
for i = 1:niter,

    dm = dt*(alpm*(1-m)-betm*m);
    dn = dt*(alpn*(1-n)-betn*n);
    dh = dt*(alph*(1-h)-beth*h);

    m = m + dm;
    n = n + dn;
    h = h + dh;


    gNa = gNamax*m^3*h;
    gK = gKmax*n^4;
    gl = glmax;


    INa = gNa*(vm-ENa);
    IK = gK*(vm-EK);
    Il = gl*(vm-El);
    INat(i+1)=INa;
    IKt(i+1)=IK;
    Ilt(i+1)=(INa-IK);
%      Ilt(i+1)=Il;
    GNat(i+1)=gNa;
    GKt(i+1)=gK;
    Glt(i+1)=gl;
    

    vm = vm+(Iext-INa-IK-Il)*(dt/cm);
    V(i+1) = vm;

    alpn = 0.01*(vm+50)/(1-exp(-(vm+50)/10));
    alpm = 0.1*(vm+35)/(1-exp(-(vm+35)/10));
    alph = 0.07*exp(-0.05*(vm+60));
    betn = 0.125*exp(-(vm+60)/80);
    betm = 4*exp(-0.0556*(vm+60));
    beth = 1/(1+exp(-0.1*(vm+30)));


end
IT=INat+IKt+Ilt-Iext;
tim = dt*(1:niter+1);
hold all
plot(tim,V);
xlabel('time in ms');
ylabel('Membrane potential mV');
axis([0 inf -100 100])
yyaxis right
ylabel('Current in uA*cm^2');
plot(tim,INat,'red');
plot(tim,IKt,'blue');
plot(tim,Ilt,'green');
plot(tim,IT,'black');
legend('Membrane potential','Na+ current','K+ current','Leak current ','Ionic current')
hold off

figure
hold all
plot(tim,IT,'black');
yyaxis right
IntIT = cumtrapz(IT);
IntIT=IntIT*-dt;
plot(tim,IntIT,'cyan');

figure
hold all
plot(tim,INat,'red');
yyaxis right
intNa = cumtrapz(INat);
intNa=intNa*-dt;
plot(tim,intNa,'cyan');

figure
hold all
plot(tim,Ilt,'green');
yyaxis right
Intleak = cumtrapz(Ilt);
Intleak=Intleak*-dt;
plot(tim,Intleak,'cyan');

figure
IT=INat+IKt+Ilt-Iext;
tim = dt*(1:niter+1);
hold all
plot(tim,V,'black','LineWidth',2);
xlabel('time in ms');
ylabel('Membrane potential mV');
axis([0 inf -100 100])
yyaxis right
ylabel('Current in uA*cm^2');
plot(tim,GNat,'red','LineWidth',2);
plot(tim,GKt,'blue','LineWidth',2);
plot(tim,Glt,'green','LineWidth',2);

legend('Membrane potential','Na+ G','K+ G','Leak G ')
hold off



