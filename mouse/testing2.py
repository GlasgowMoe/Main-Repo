from tkinter import *
import tkinter
from time import sleep
from pynput.mouse import Button, Controller
import sched
import time
 
running = True # Global flag 
window_main = tkinter.Tk(className='Crazy Mouse')
window_main.geometry("300x50+800+400")
event_schedule = sched.scheduler(time.time, time.sleep)



def mouse_move():
    if running:
        mouse = Controller()
        print('The current pointer position is {0}'.format(mouse.position))
        mouse.move(10, -10)
        sleep(1)
        mouse.move(-10, 10)
        event_schedule.enter(1, 1, mouse_move,)
        event_schedule.run()
        window_main.after(1000, mouse_move)

def start():
    """Enable scanning by setting the global flag to True."""
    global running
    running = True

def mouse_stop():
    global running
    running = False


    
    
button_on = tkinter.Button(window_main, text ="On", command=mouse_move)
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