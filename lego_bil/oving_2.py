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

speed = -300
turn_speed = -500


# Write your program here.

motor_left = Motor(port=Port.A)
motor_right = Motor(port=Port.B)
current_color = ColorSensor(port=Port.S2)
destroyer = Motor(port=Port.D)
on_off_sensor = TouchSensor(port=Port.S1)
press_sensor = TouchSensor(port=Port.S4)


engine = DriveBase(motor_right, motor_left, wheel_diameter=56, axle_track=100)


is_running = False

while True:
    if on_off_sensor.pressed() and not is_running:
        is_running = True
        ev3.speaker.say("Excercize 2")
        wait(2000)
        engine.drive(-400, 0)
    if press_sensor.pressed() and is_running:
        engine.straight(-200)
        engine.stop()
        engine.turn(180)
        engine.straight(-400)
        engine.turn(-180)
        engine.drive(-400, 0)
    if is_running and on_off_sensor.pressed():
        engine.stop()
        ev3.speaker.say("Excercize 2 done")
        break


""" 
while True:
    if is_black(current_color):
        engine.drive(speed, -5)
        wait(10)
    else:
        engine.drive(speed, 5)
    wait(10)
    ev3.screen.clear()
    ev3.screen.draw_text(0, 20, "Is black?: " + str(is_black(current_color)))
    ev3.screen.draw_text(0, 40, "Light value: " +
                         str(current_color.reflection()))

    if press_sensor1.pressed() or press_sensor2.pressed():
        break
 """
