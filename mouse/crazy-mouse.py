#Import the required libraries
from tkinter import *
from tkinter import ttk


from time import sleep
import tkinter
from pynput.mouse import Button, Controller
import sched
import time

event_schedule = sched.scheduler(time.time, time.sleep)


#Create an instance of Tkinter Frame
win = Tk(className="\Crazy Mouse")

#Set the geometry
win.geometry("250x150+200+40")

mouse = Controller()
# Define function to get the information about the Button




def mouse_move():
    mouse = Controller()
    print('The current pointer position is {0}'.format(mouse.position))
    mouse.move(1, -1)
    sleep(newvar)
    mouse.move(-1, 1)
    win.after(1000, mouse_move,)


  

#Create Button Object
b1= ttk.Button(win, text= "ON", command=mouse_move)
b1.place(relx= .30, rely= .9, anchor= CENTER)

b2= ttk.Button(win, text= "OFF", command=win.destroy)
b2.place(relx= .60, rely= .9, anchor= CENTER)



#####

# Define a function
def sel():
   selection= "Mouse Move set to " + str(var.get() + " Seconds")
   label.config(text=selection)
   print(int(var.get()))
   global newvar
   newvar = int(var.get())

# Create a scale widget
var=StringVar()
my_scale=Scale(win, variable=var, orient=HORIZONTAL,from_ = 1, to = 60)
my_scale.pack(anchor = CENTER)

# Create a label widget
label=Label(win, font='Helvetica 8 bold')
label.pack()

# Create a button to get the value at the scale
button=ttk.Button(win, text="Set", command=sel)
button.pack()




win.mainloop()
