from time import sleep
from pynput.mouse import Button, Controller
import sched
import time
from tkinter import *

event_schedule = sched.scheduler(time.time, time.sleep)

class MyWindow:
        def mouse_move():
            mouse = Controller()
            print('The current pointer position is {0}'.format(mouse.position))
            mouse.move(10, -10)
            sleep(1)
            mouse.move(-10, 10)
            event_schedule.enter(1, 1, mouse_move,)
            
event_schedule.run()



   
window=Tk()
btn=Button(window, text="On/Off", fg='blue') #test
btn.place(x=240, y=170) #test
mywin=MyWindow()
window.title('Crazy Mouse')
window.geometry("300x200+800+400")
window.mainloop()

