using Gtk
using Sound: sound
using WAV
using Plots
using MAT



# initialize two global variables used throughout
S = 44100 # sampling rate (samples/second) for this low-fi project
song = Float32[] # initialize "song" as an empty vector
octave = 4
BPM=200
BPS=BPM/60
QuarterSamples=S/BPS
function miditone(midi::Int64) 
    local nsample::Int = floor(QuarterSamples)
    f =(440 * 2^((midi-69)/12)) * 2^(float(octave) - 4) # compute frequency from midi number - FIXED!
    x = cos.(2pi*(1:nsample)*f/S) # generate sinusoidal tone
    sound(x, S) # play note so that user can hear it immediately
    global song = [song; x] # append note to the (global) song vector
    return nothing
end

#=
select instrument = (instrument::vector)
function
    instrument = [Flute, Clarinet, Bassoon, Tuba, Violin, Cello]
end 
=#
#=
function Vibrato (instrument::vector)
blablabla



=#

#=
function reverb (instrument::vector)
blablalba


=#

#=
function Volume (instrument::vector)
blablalba


=#

#=

flute= {"Flute", Flute_volume, Flute_reverb, Flute_Vibrato, Flute}



=#




# define the white and black keys and their midi numbers - maybe FIXED (maybe)
white = ["F" 65;"G" 67; "A" 69; "B" 71; "C" 72; "D" 74;"E" 76; "F" 77; "G" 79; "A" 81; "B" 83]
black = ["F" 66 2;"G" 68 4; "A" 70 6; "C" 73 10 ; "D" 75 12 ; "F" 78 16; "G" 80 18; "A" 82 20]


g = GtkGrid() # initialize a grid to hold buttons
set_gtk_property!(g, :row_spacing, 5) # gaps between buttons
set_gtk_property!(g, :column_spacing, 5)
set_gtk_property!(g, :row_homogeneous, true) # stretch with window resize
set_gtk_property!(g, :column_homogeneous, true)


# define the "style" of the black keys
sharp = GtkCssProvider(data="#wb {color:white; background:black;}")
endbutton = GtkCssProvider(data="#eb {color:yellow; background:blue;}")
downbutton = GtkCssProvider(data="#db {color:black; background:white;}")
upbutton = GtkCssProvider(data="#ub {color:black; background:white;}")



for i in 1:size(white,1) # add the white keys to the grid
    key, midi = white[i,1:2]
    b = GtkButton(key) # make a button for this key
    signal_connect((w) -> miditone(midi), b, "clicked") # callback
    g[(1:2) .+ 2*(i-1), 2] = b # put the button in row 2 of the grid
end
for i in 1:size(black,1) # add the black keys to the grid
    key, midi, start = black[i,1:3]
    b = GtkButton(key * "♯") # to make ♯ symbol, type \sharp then hit <tab>
    push!(GAccessor.style_context(b), GtkStyleProvider(sharp), 600)
    set_gtk_property!(b, :name, "wb") # set "style" of black key
    signal_connect((w) -> miditone(midi), b, "clicked") # callback
    g[start .+ (0:1), 1] = b # put the button in row 1 of the grid
end


function end_button_clicked(w) # callback function for "end" button
    println("The end button")
    sound(song, S) # play the entire song when user clicks "end"
    matwrite("/Users/comradereznov/Documents/VS_Code/Engin_100/Project_1/proj1_2.mat", Dict("song" => song); compress=true) # save song to file
end

ebutton = GtkButton("end") # make an "end" button
g[1:4, 3] = ebutton # fill up entire row 3 of grid - why not?
signal_connect(end_button_clicked, ebutton, "clicked") # callback
push!(GAccessor.style_context(ebutton), GtkStyleProvider(endbutton), 600)
set_gtk_property!(ebutton, :name, "eb")


function down_button_clicked(w)
    global octave
    global label
    if octave > 3
        octave -= 1
        set_gtk_property!(label, :label, string("Octave: A", octave))
    end
        
end

function up_button_clicked(w)
    global octave
    global label
    if octave < 5
        octave += 1
        set_gtk_property!(label, :label, string("Octave: A", octave))
    end
        
end
label = GtkButton("Octave: A4")
g[5:8, 3] = label

dbutton = GtkButton("Down")
g[13:16, 3] = dbutton
push!(GAccessor.style_context(dbutton), GtkStyleProvider(downbutton), 600)
set_gtk_property!(dbutton, :name, "db")
signal_connect(down_button_clicked, dbutton, "clicked")


ubutton = GtkButton("Up")
g[9:12, 3] = ubutton
push!(GAccessor.style_context(ubutton), GtkStyleProvider(upbutton), 600)
set_gtk_property!(ubutton, :name, "ub")
signal_connect(up_button_clicked, ubutton, "clicked")

win = GtkWindow("gtk3", 400, 300) # 400×300 pixel window for all the buttons
push!(win, g) # put button grid into the window
showall(win); # display the window full of buttons





