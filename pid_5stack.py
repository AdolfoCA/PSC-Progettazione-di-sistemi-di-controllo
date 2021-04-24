from m5stack import *
from m5ui import *
from uiflow import *
import imu
from servo import Servo
from datetime import datetime

setScreenColor(0x111111)

imu0 = imu.IMU()    

theta0 = 0  #valore asintotico voluto
# coefficenti PID calcolati
kp = 
ki = 
#kd = 
tempo_ora = 0
tempo_preced = 0
tempo_trascorso = 0
ultimoError = 0
integraleError = 0
derivError = 0


#funzione che calcola l'uscita per PWM a partire da
#lettura angolo su giroscopio

def calcola_PID(ingresso):
    tempo_ora = datetime.now()
    tempo_trascorso = tempo_ora - tempo_preced
    error = theta0 - ingresso
    integraleError = integraleError + error*tempo_trascorso
    #derivError = (error - ultimoError)/tempo_trascorso
    uscita = kp*error + ki*integraleError # + kd*derivError
    ultimoError = error
    tempo_preced = tempo_ora
    return uscita
    
    
    
    
while True:
    thetaIN = imu0.gyro[0]
    outPWM = calcola_PID(thetaIN)
    # delay 100 ms
    servo0.write_angle(outPWM)
    
    
