from time import sleep
from pynput.mouse import Button, Controller
import sched
import time

event_schedule = sched.scheduler(time.time, time.sleep)

def mouse_move():
    mouse = Controller()
    print('The current pointer position is {0}'.format(mouse.position))
    mouse.move(10, -10)
    sleep(1)
    mouse.move(-10, 10)
    event_schedule.enter(1, 1, mouse_move,)
    


event_schedule.enter(1, 1, mouse_move,)
event_schedule.run()

