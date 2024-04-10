using Gtk
using GTK3_jll

#Grid decleration
g = GtkGrid() # initialize a grid to hold buttons
set_gtk_property!(g, :row_spacing, 5) # Spacing between rows 
set_gtk_property!(g, :row_homogeneous, true) # stretch rows with window resize
set_gtk_property!(g, :column_spacing, 5) #Spacing between columns
set_gtk_property!(g, :column_homogeneous, false) #stretch columns with window resize 

#When the column homogeneous is set to true, I run into a weird thing where the GUI freaks out and makes the keyboard keys super wide to the point where the 
#window for the GUI itself is distorted to no longer fit on the screen and is unable to be resized widith wise. Not sure how to fix this or what our options are from here. 
#My best guess is that the combination of elements (drop down menus, sliders, and buttons) works in a vertical orientation, but freaks out when you try to combine them horizontally
#which is why we get the weird distrotion. 


#Instrument drop down decleration
instrument = GtkComboBoxText() #create the drop down box
choices = ["Insturment Selection", "Flute", "Clarinet", "Basson","Tuba", "Violin", "Cello"] #define options for the drop down
#for loop to put each option into the drop down box
for choice in choices  
  push!(instrument,choice)
end
set_gtk_property!(instrument,:active,0) #set the "active element" (element shown in the drop down on the GUI) to be "insturment selection"
g[1,1]=instrument #place the drop down box in the first row and first column of the grid 

# Function for the change in drop downs
signal_connect(instrument, "changed") do widget, others...
  idx = get_gtk_property(instrument, "active", Int) # get the active index
  str = Gtk.bytestring( GAccessor.active_text(instrument) ) #get the string (insturment choice in array choices) corresponding to the index
  println("Active element is \"$str\" at index $idx") #print in terminal which element and which string is active
  #TO ADD: function call to the modeling function for selected insturment
end
#End of insturment drop down decleration

   
#Note duration drop down decleration
note = GtkComboBoxText() #create the drop down box
choices = ["Note Duration", "Sixteenth", "Eigth", "Quarter","Half", "Whole"] #define options for the drop down
#for loop to put each option into the drop down box
for choice in choices
  push!(note,choice)
end
set_gtk_property!(note,:active,0) #set the "active element" (element shown in the drop down on the GUI) to be "Note Duration"
g[1,2]=note #place the drop down in the first column and second row of the grid

# Function for the change in drop downs
signal_connect(note, "changed") do widget, others... 
  idx = get_gtk_property(note, "active", Int) # get the active index
  str = Gtk.bytestring( GAccessor.active_text(note) ) #get the string (note choice in array choices) corresponding to the index
  println("Active element is \"$str\" at index $idx") #print in terminal which element and which string is active
  #TO ADD: function call to the modeling function for selected note duration
end
#End of note duration drop down decleration


#Artuclations drop down decleration
#This drop down decleration follows the same format as the previous two only with changed variable names 
#See comments on note and instrument decleration for what each line does
Articulations = GtkComboBoxText() 
choices = ["Articulations", "Accent", "Staccato", "Trill", "Fermata","Slur"]
for choice in choices
  push!(Articulations,choice)
end
set_gtk_property!(Articulations,:active,0)
g[1,3]=Articulations

signal_connect(Articulations, "changed") do widget, others...
  # get the active index
  idx = get_gtk_property(Articulations, "active", Int)
  # get the active string 
  # We need to wrap the GAccessor call into a Gtk bytestring
  str = Gtk.bytestring( GAccessor.active_text(Articulations) ) 
  println("Active element is \"$str\" at index $idx")
end
#End articulations drop down decleration


#Dynamics drop down decleration
#This drop down decleration follows the same format as the previous two only with changed variable names 
#See comments on note and instrument decleration for what each line does
Dynamics = GtkComboBoxText()
choices = ["Dynamics", "Forte", "Mezzo Piano", "Mezzo Forte","Crescendo", "Decrescendo"]
for choice in choices
  push!(Dynamics,choice)
end
# Lets set the active element to be "please pick an insturment"
set_gtk_property!(Dynamics,:active,0)
g[1,4]=Dynamics

signal_connect(Dynamics, "changed") do widget, others...
    # get the active index
    idx = get_gtk_property(Dynamics, "active", Int)
    # get the active string 
    # We need to wrap the GAccessor call into a Gtk bytestring
    str = Gtk.bytestring( GAccessor.active_text(Dynamics) ) 
    println("Active element is \"$str\" at index $idx")
end
#End dynamics drop down decleration


# #Virbrato slider decleration
# virbrato=GtkLabel("Virbrato") #create a label for the slider
# g[1,5]=virbrato #place the label in column one row five of the grid
  
# virbratoslide=GtkScale(false, 0:10) #create the slider

# #Function to get the value of the slider
# signal_connect(virbratoslide, "value-changed") do widget, others...
#     value = GAccessor.value(virbratoslide) #get the numeric value the slider is currently at
#     println("slider value is $value") #print the slider value to the terminal
#     #TO ADD: Function call for adding virbrato
# end
  
# g[1,5]=virbratoslide #place the slider in column one row five of the grid
# #End virbrato slider decleration


# #Reverb slider decleration
# #This slider follows the same format as the virbrato slider only with changed variable names 
# #See comments on virbrato slider for what each line does
# reverb=GtkLabel("Reverb")
# g[1,6]=reverb

# reverbslide=GtkScale(false, 0:10)

# signal_connect(reverbslide, "value-changed") do widget, others...
#     value = GAccessor.value(reverbslide)
#     println("slider value is $value")
# end
  
# g[1,6]=reverbslide
# #End reverb slider decleration


# #Tremolo slider decleration
# #This slider follows the same format as the virbrato slider only with changed variable names 
# #See comments on virbrato slider for what each line does
# tremolo=GtkLabel("Tremolo")
# g[1,7]=tremolo

# tremoloslide=GtkScale(false, 0:10)

# signal_connect(tremoloslide, "value-changed") do widget, others...
#   value = GAccessor.value(tremoloslide)
#   println("slider value is $value")
# end

# g[1,7]=tremoloslide
# #End tremolo slider decleration


#Delete button decleration
delete=GtkButton("Delete") #define the button
deletebutton=GtkCssProvider(data="#eb {color:white; background:red;}") #set the style for the button
g[1,8]=delete #place the button in column one row eight in the grid
set_gtk_property!(delete, :name, "eb") #apply the style to the button
#TO ADD: function to recognize when the button is pressed and act accorrdingly
push!(GAccessor.style_context(delete),GtkStyleProvider(deletebutton),600) #apply the style to the button in the grid
#End delete button decleration


#Play button decleration
#This button follows the same format as the delete button only with changed variable names 
#See comments on delete button for what each line does
play=GtkButton("Play")
playbutton=GtkCssProvider(data="#eb {color:white; background:green;}")
g[1,9]=play
set_gtk_property!(play, :name, "eb")
#add in function to recgonize when the delete button is pressed
push!(GAccessor.style_context(play),GtkStyleProvider(playbutton),600)
#End play button decleration


#Keyboard decleration
sharpbutton= GtkCssProvider(data="#wb {color:white; background:black;}") #set style for sharp keys

white=["C" 2; "D" 4; "E" 6; "F" 8; "G" 10; "A" 12; "B" 14] #array contaning each note's name and its column position
black = ["C" 2; "D" 4; "F" 8; "G" 10; "A" 12] #array containing each sharp's name and its column start position


for i in 1:size(white, 1) # add the white keys to the grid
  Name, col = white[i, 1:2] 
  b = GtkButton(Name) # make a button for current key
  g[1 .+ (1:2) .+ 2*(i-1), (6:9)] = b # put the button in rows 6 through 9 of the grid
end

for i in 1:size(black,1) # add the black keys to the grid
  key, start = black[i,1:2]
  b = GtkButton(key * "♯") #make a button for current key
  push!(GAccessor.style_context(b), GtkStyleProvider(sharpbutton), 600) #apply the style to the key 
  set_gtk_property!(b, :name, "wb") # set "style" of black key
  g[start .+ (0:1) .+ 1, (1:5)] = b # put the button in rows 1 through 5 of the grid
  end

#End keyboard decleration 


win = GtkWindow("Orchestral Synthesizer",400,300) #define the pop up window by setting the title and size (pixel by pixel)
push!(win, g) #push the grid into the window
showall(win) #show the window
