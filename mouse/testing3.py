from multiprocessing.connection import wait
from tkinter import *
import tkinter
from time import sleep
from pynput.mouse import Button, Controller
import sched
import time
from threading import Thread
 
#running = True # Global flag 

window_main = tkinter.Tk(className='Crazy Mouse')
window_main.geometry("300x50+800+400")
event_schedule = sched.scheduler(time.time, time.sleep)



def mouse_move():
    while True:
        mouse = Controller()
        print('The current pointer position is {0}'.format(mouse.position))
        mouse.move(10, -10)
        #time.sleep(2)
        mouse.move(-10, 10)
        event_schedule.enter(10, 10, mouse_move,)
        event_schedule.run()
        if stop == 1:
            break


def start_thread():
        # Assign global variable and initialize value
        global stop
        stop = 0

        # Create and launch a thread 
        t = Thread (target = mouse_move)
        t.start()


def mouse_stop():
        # Assign global variable and set value to stop
        global stop
        stop = 1


    
    
button_on = tkinter.Button(window_main, text ="On", command=start_thread)
button_on.config(width=6, height=1)
button_on.place(x=240, y=170)

button_off = tkinter.Button(window_main, text ="Off", command=mouse_stop)
button_off.config(width=6, height=2)
button_off.place(x=100, y=70)

# root = Tk()
# app = Frame(root)
# app.grid()

button_on.pack()
button_off.pack()
window_main.mainloop()

window_main.after(1000, mouse_move)  # After 1 second, call scanning
window_main.mainloop()