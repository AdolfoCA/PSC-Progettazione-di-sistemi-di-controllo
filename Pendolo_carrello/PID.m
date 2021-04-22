M=0.5; %massa carrello [Kg]
m=0.2; %massa pendolo [Kg]
b=0.1; %attrito del carrello [N/m/s]
l=0.3; %lunghezza dell'estremità al centro di massa del pendolo [m]
i=0.006; %inerzia del pendolo [Kg*m^2]
g=9.8; %accelerazione gravitazionale [m/s^2]
q=(M+m)*(i+m*l^2)-(m*l)^2; %valore di q

num=[m*l/q 0]; %numeratore della FDT
den=[1 b*(i+m*l^2)/q - (M+m)*m*g*l/q - b*m*g*l/q]; %denominatore della FTD

pend=tf(num,den); %ft da come output la FDT

Ki=1;
Kp=100;
Kd=20;
contr=tf([Kd Kp Ki],[1 0]);
sys_cl=feedback(pend,contr);
t=0:0.005:5;
impulse(sys_cl,t)
axis([0 5 -2 2])