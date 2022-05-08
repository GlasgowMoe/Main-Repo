from tkinter import *
window=Tk()
# lbl=Label(window, text="Jiggle mouse", fg='red', font=("Helvetica", 16))
# lbl.place(x=60, y=50)
btn=Button(window, text="On/Off", fg='blue')
btn.place(x=240, y=170)
#btn.bind('<Button-1>', MyButtonClicked)
# txtfld=Entry(window, text="This is Entry Widget", bg='white',fg='black', bd=5,) #show='*' - to covert the text to password field
# txtfld.place(x=80, y=150)
window.title('Crazy Mouse')
window.geometry("300x200+800+400")
window.mainloop()
