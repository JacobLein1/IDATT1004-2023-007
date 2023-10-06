#!/usr/bin/env pybricks-micropython

from time import sleep

from pybricks.ev3devices import (ColorSensor, GyroSensor, Motor, TouchSensor,
                                 UltrasonicSensor)
from pybricks.hubs import EV3Brick
from pybricks.media.ev3dev import ImageFile, SoundFile
from pybricks.parameters import Button, Color, Direction, Port, Stop
from pybricks.robotics import DriveBase
from pybricks.tools import DataLog, StopWatch, wait

ev3 = EV3Brick()
current_color = ColorSensor(port=Port.S2)


def calibrate_colors():
    ev3.screen.draw_text(0, 0, "Current value: " +
                         str(current_color.reflection()))

    wait(50)
    ev3.screen.clear()


while True:
    calibrate_colors()
