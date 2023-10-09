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

white = 50
black = 10
threshold = (white + black) / 2

speed = -300
turn_speed = -450


# Write your program here.

motor_left = Motor(port=Port.A)
motor_right = Motor(port=Port.B)
current_color = ColorSensor(port=Port.S2)


engine = DriveBase(motor_left, motor_right, wheel_diameter=56, axle_track=100)


def is_black(sensor: ColorSensor) -> bool:
    return sensor.reflection() <= threshold


while True:
    if is_black(current_color):
        motor_right.run(speed)
        motor_left.run(-500)
        wait(20)
    else:
        motor_left.run(speed)
        motor_right.run(turn_speed)
    wait(10)
