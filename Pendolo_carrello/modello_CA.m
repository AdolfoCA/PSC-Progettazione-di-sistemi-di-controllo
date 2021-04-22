%% modello in SS
%grandezze fisiche
M=0.5; %massa carrello
m=0.2;  %massa pendolo
b=0.1;  %attrito carrello-pavimento
l=0.3;  %lunghezza pendolo
i=0.006; %inerzia pendolo
g=9.8;

%modello come fdt
q=(M+m)*(i+m*l^2)-(m*l)^2;
num=[m*l/q 0];
den=[1 b*(i+m*l^2)/q -(M+m)*m*g*l/q -b*m*g*l/q];
pend=tf(num,den);

t=[0:0.001:3];
impulse(pend,t)
rlocus(pend)

%% LUOGO RADICI
%plot luogo radici open loop
rlocus(pend)
sigrid(0.92)
axis([-6 6 -6 6])

%rete correttrice per luogo radici
contr_PID=tf(1,[1 0]);
rlocus(contr_PID*pend);
sigrid(0.92)
axis([-10 10 -10 10])

%aggiunta di poli e zeri
z1=3; z2=4; 
p1=0; %polo che compensa zero in origine
p2=60; %polo lontano

% rete correttrice migliorata
numc=conv([1 z2],[1 z1]);
denc=conv([1 p2],[1 p1]);
contr_rlc=tf(numc,denc);
rlocus(contr_rlc*pend)

%prelevo gain per la rete correttrice
[k,poles]=rlocfind(contr_rlc*pend); %scelgie graficamente gain e poli corrispondenti
sys_cl_rlc=feedback(pend,contr_rlc*k);


%% PID
Ki=1;
Kp=100;
Kd=20;
contr_PID=tf([Kd Kp Ki],[1 0]);
sys_cl_PID=feedback(pend,contr_PID);

%% Studio in freq
%riceve da tastiera i valore del controllore
% nc=input('inserire il numeratore del controllore: ');
% dc=input('inserire il denominatore del controllore: ');
% k=input('inserire il guadagno del controllore: ');

%BODE 
contr_freq=k*tf(nc,dc);
sys_cl_freq=pend*contr_freq;
bode(sys_cl_freq);
grid on

%NYQUIST
nyquist(sys_cl_freq)
grid on

%risp impulsiva
sys_cl_freq=feedback(pend,contr_freq);

%% Confronto tra le risposte impulsive

figure;
impulse(sys_cl_rlc,t) %con root locus
hold on
impulse(sys_cl_PID,t) %con PID
impulse(sys_cl_freq,t) %con sintesi in freq
title('Risposta impulsiva');
legend('retro PID','retro root locus','retro freq')
grid on
xlabel('time')
ylabel('\theta (rad)')