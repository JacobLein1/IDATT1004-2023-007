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

motor_left = Motor(port=Port.A)
motor_right = Motor(port=Port.B)
current_color = ColorSensor(port=Port.S2)
destroyer = Motor(port=Port.D)
press_sensor1 = TouchSensor(port=Port.S1)


engine = DriveBase(motor_left, motor_right, wheel_diameter=56, axle_track=100)


def is_black(sensor: ColorSensor) -> bool:
    return sensor.reflection() <= threshold


destroyer_running = False

while True:
    if is_black(current_color):
        engine.drive(speed, -80)
        wait(250)
    else:
        engine.drive(speed, 80)
    wait(10)
    ev3.screen.clear()
    ev3.screen.draw_text(0, 20, "Is black?: " + str(is_black(current_color)))
    ev3.screen.draw_text(0, 40, "Light value: " +
                         str(current_color.reflection()))

    if press_sensor1.pressed():
        destroyer_running = not destroyer_running
        wait(1000)

    if destroyer_running:
        destroyer.run(1000)
    else:
        destroyer.stop()
