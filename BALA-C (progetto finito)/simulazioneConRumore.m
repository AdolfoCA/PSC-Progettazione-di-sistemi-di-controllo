clear all
close all
clc

M = 0.055;
m = 0.044;
g = 9.8;
d = 0.083;
r = 0.0315;
l = 0.083; %[m]
Ip = (m*l^3)/3; %inerzia asta
l1 = 0.0315;
l2 = 0.0215;
Ir = M*(l1^2+l2^2); %inerzia ruote
f=Ip*(Ir+M*r^2+m*r^2);

A= [0 1 0 0;
    0 0 -r^2*g*d^2*m^2/f 0;
    0 0 0 1;
    0 0 (d*M*g)/Ip 0];

B= [0;
    (r^2*d*m+Ip)/f;
    0;
    -1/Ip];

C= [1 0 0 0;  %misura posizione del carretto
    0 0 1 0]; %misura angolo del pendolo  

D= [0;
    0];

pendolo = ss(A,B,C,D);
R = ctrb(A,B);
O = obsv(A,C);
rank(R);
rank(O);

%Controllore
K=place(A,B,[-15 -15.1 -15.2 -15.3]);


%% Consideriamo il sistema soggetto ad un WN 
Ts = 0.1;
t = 1:Ts:2;

w = wgn(length(t),1,3);
v = wgn(length(t),2,3);

Q = cov(w);
R = cov(v);

% Sistema con retroazione dallo stato
sys = ss(A-B*K,[B,B],C, zeros(2,2),'InputName',{'u','w'},'OutputName','y');

% Costruisco il filtro di Kalman
[kalmf,L,~,Mx,Z] = kalman(sys,Q,R);

kalmf = kalmf(1:2,:);

sys.InputName = {'u','w'};
sys.OutputName = {'yt1','yt2'};

vIn1 = sumblk('y1 = yt1+v1');
vIn2 = sumblk('y2 = yt2+v2');

kalmf.InputName = {'u','y1','y2'};
kalmf.OutputName = {'ye1','ye2'};

% Sistema a circuito chiuso 
SimModel = connect(sys,vIn1,vIn2,kalmf,{'u','w','v1','v2'},{'yt1','yt2','ye1','ye2'});

% Evoluzione libera catena chiusa
x0=[0;0;0.1;0;0.2;0.1;0.3;0.06];
out=initial(SimModel,x0,t);
figure(2)
plot(t,out(:,2),'LineWidth',1)
hold on
plot(t,out(:,4),'LineWidth',1)
grid
hold off
legend('\theta effettivo', '\theta stimato')
title('Angolo effettivo e angolo stimato')

figure(3)
err = (out(:,2)-out(:,4)).^2;
plot(t,err,'LineWidth',3)
grid
title('Errore di stima su \theta');
