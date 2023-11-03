#!/usr/bin/env pybricks-micropython

from time import sleep

from pybricks.ev3devices import (ColorSensor, GyroSensor, Motor, TouchSensor,
                                 UltrasonicSensor)
from pybricks.hubs import EV3Brick
from pybricks.media.ev3dev import ImageFile, SoundFile
from pybricks.parameters import Button, Color, Direction, Port, Stop
from pybricks.robotics import DriveBase
from pybricks.tools import DataLog, StopWatch, wait

# This program requires LEGO EV3 MicroPython v2.0 or higher.
# Click "Open user guide" on the EV3 extension tab for more information.


# Create your objects here.
ev3 = EV3Brick()

# white = 60
# black = 0
threshold = 15

speed = -250


# Write your program here.
destroyer = Motor(port=Port.D)
destroyer2 = Motor(port=Port.C)
press_sensor1 = TouchSensor(port=Port.S1)

destroyer_running = False

while True:
    if press_sensor1.pressed():
        destroyer_running = not destroyer_running
        wait(1000)

    if destroyer_running:
        destroyer.run(-1000)
        destroyer2.run(-1000)
    else:
        destroyer.stop()
        destroyer2.stop()
