function[]=frequenza()

%definisco la funzione di trasferimento
M=0.5; %massa carrello [Kg]
m=0.2; %massa pendolo [Kg]
b=0.1; %attrito del carrello [N/m/s]
l=0.3; %lunghezza dell'estremità al centro di massa del pendolo [m]
i=0.006; %inerzia del pendolo [Kg*m^2]
g=9.8; %accelerazione gravitazionale [m/s^2]

q=(M+m)*(i+m*l^2)-(m*l)^2; %valore di q

um=[m*l/q 0]; %numeratore della FDT
den=[1 b*(i+m*l^2)/q - (M+m)*m*g*l/q - b*m*g*l/q]; %denominatore della FTD

pend=tf(num,den); %ft da come output la FDT
figure(1)

%riceve da tastiera i valore del controllore
nc=input('inserire il numeratore del controllore: ')
dc=input('inserire il denominatore del controllore: ')
k=input('inserire il guadagno del controllore: ');

%visualizza il diagramma di boe del sistema compensato
contr=k*tf(nc,dc)
siscon=pend*contr;
bode(siscon);

%visualizza in un'altra finestra il diagramma di nyquist
figure(2)
nyquist(siscon)

%visualizza in una terza finestra la risposta impulsiva in retroazione
figure(3)
sys_cl=feedback(pend,contr);
impulse(sys_cl)
axis([0 5 0 100])

