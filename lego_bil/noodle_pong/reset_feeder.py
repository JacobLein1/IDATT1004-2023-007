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

feeder = Motor(port=Port.C)
feeder.run_angle(175, -1200)
