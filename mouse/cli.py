#Import the required libraries
from ast import arg
from tkinter import *
from tkinter import ttk
from time import sleep
from pynput.mouse import Button, Controller
from sys import argv 
import sys 
import sched
import time

event_schedule = sched.scheduler(time.time, time.sleep)
mouse = Controller()

seconds = '5'
if sys.argv[1:]:
   seconds = sys.argv[1]


def mouse_move():
    mouse = Controller()
    print('The current pointer position is {0}'.format(mouse.position))
    mouse.move(1, -1)
    sleep(0.5)
    mouse.move(-1, 1)
    event_schedule.enter(int(seconds), int(seconds), mouse_move,)

event_schedule.enter(int(seconds), int(seconds), mouse_move,)
event_schedule.run()


