clc
clear all
close all

%Pendolo linearizzato range di lavoro 0°%13°, 0rad%0.23rad
x=0.10; %NB:max 0.23rad
x_=0;
x__=0;
d=1; %asta più corta difficile da controllare, quindi bisogna aumentare il guadagno
pos=[x d];
g=9.81;
h=0.025; %passo discretizzazione
kp=20; %costante proporzionale da regolare in base alla lunghezza dell'asta e l'angolo iniziale
ki=5; %costante integrativa
e=0; %errore
intgr=0; %memoria
rif=0; %asta in su


for t=0:h:300
   e=rif-x;
   intgr=intgr+e*h;
   x__=g*x/d + kp*e - ki*intgr;
   x_=x_ + x__*h;
   x=x+x_*h;
   pos=[x d];
   plot([0 pos(1,1)], [0 pos(1,2)],'r-')
   xlim([-2*d 2*d]);
   ylim([-2*d 2*d]);
   drawnow
   if abs(x_)<= 0.018 && abs(e)<=0.1 %potenziometro precisione
       intgr=0;
   end
   %disturbo
   if t==10 || t==15 || t== 20 ||...
       t==25 || t==30 || t== 35 ||...
       t==40 || t==45 || t== 50
       x_=x_+0.25;
       print="DISTURBO"
   end    
end
