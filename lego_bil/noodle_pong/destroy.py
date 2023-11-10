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
destroyer = Motor(port=Port.A)
destroyer2 = Motor(port=Port.B)
launcher = Motor(port=Port.C)
rotator = Motor(port=Port.D)
press_sensor1 = TouchSensor(port=Port.S1)


#rotator.run_angle(175, 60)
rot_angle = 45
rotator.run_angle(175, -rot_angle)

power = -750
ratio = 1.0

destroyer.run(power)
destroyer2.run(power * ratio)

launch_angle = 1200
spd = 175
launcher.run_angle(spd, launch_angle)
destroyer.stop()
destroyer2.stop()
launcher.run_angle(spd, -launch_angle)

rotator.run_angle(175, rot_angle)

