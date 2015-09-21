import spidev
import time
#import RPi.GPIO as GPIO

#GPIO.setmode(GPIO.BOARD)
#GPIO.setwarnings(False)
#GPIO.setup(10,GPIO.OUT)

print 'aaa'
spi = spidev.SpiDev()

spi.open(0, 0)
spi.max_speed_hz = 15*1000*1000
a=0x00
while True:
    to_send = [a]
    
    #spi.xfer(to_send)
    spi.writebytes(to_send)
    s = spi.readbytes(1)
    print s

    a=a+1
    
	#spi.xfer(to_send)
	#spi.xfer("\n")
	#time.sleep(0.1)
    
	#print 
