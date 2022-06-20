#Import the required libraries
from shutil import register_unpack_format
from tkinter import *
from tkinter import ttk
from time import sleep
from pynput.mouse import Button, Controller
import sys
import sched
import time
from sys import argv



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
    sleep(0.5)
    mouse.move(-1, 1)
    win.after(seconds, mouse_move)


#Create Button Object
b1= ttk.Button(win, text= "ON", command=mouse_move)
b1.place(relx= .30, rely= .9, anchor= CENTER)

b2= ttk.Button(win, text= "OFF", command=win.destroy)
b2.place(relx= .60, rely= .9, anchor= CENTER)



# def defaul_value():
#    global seconds1
#    if sys.argv[1:]:
#       seconds1 = sys.argv[1]
#    return 5

#defaul_value(seconds)
# seconds = sys.argv[1]


# Define a function
def sel():
   selection= "Mouse Move set to " + str(var.get() + " Seconds")
   label.config(text=selection)
   #print(int(var.get()))
   global newvar,seconds
   newvar = int(var.get())
   seconds = newvar* 1000


# #command line paramters
# seconds1 = '5'
# if sys.argv[1:]:
#    seconds1 = sys.argv[1]

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


# if sys.argv[1:] != True:
#    win.mainloop()
# else:
#    print("this is a test")

# seconds = '5'
# if sys.argv[1:]:
#    seconds = sys.argv[1]
#    mouse = Controller()
#    print('The current pointer position is {0}'.format(mouse.position))
#    mouse.move(1, -1)
#    sleep(0.5)
#    mouse.move(-1, 1)
#    win.after(seconds, mouse_move)
#    print(seconds)
#    #seconds.update ({seconds})
# else:
#    print("this is a test")
#    win.mainloop()

#command line paramters



# if sys.argv[1:] == guivalue:
#    win.mainloop()
#    print (guivalue)
# else:
#    print(sys.argv[1:])

# seconds = "5"
# if sys.argv[1:]:
#    seconds = sys.argv[1]
#    mouse_move()
# else:
#     blah = 'blah'
#     win.mainloop()


# if seconds == '10':
#    print("1")
#    win.after(seconds, mouse_move)
# else: 
#    print("2")