using Gtk
using Sound
using WAV
using Plots
using MAT
using MIRT
using DSP: Windows
using FFTW

# initialize two global variables used throughout
S = 44400 # sampling rate (samples/second) for this low-fi project
song = Float32[] # initialize "song" as an empty vector
Fsong = Float32[]
Csong = Float32[]
FNotetype= Float32[]
CNotetype= Float32[]

#declaring the Envelope relations
NomETime = [0,0.1, 0.2, 0.5, 0.6, 0.7, 0.9, 1] #normal Envelope
NomEValue = [0,0.6,  0.9, 0.8,0.7, 0.4, 0.2, 0]


StacETime = [0,0.03, 0.08, 0.10,0.13, 0.2, 0.23, 0.27, 0.35] #Staccato Envelope
StacEValue = [0,0.6, 1, 0.8,0.6,0.4, 0.2, 0.1, 0]


#Declaring Flute values

Flutec = [0.21, 0.14, 0.07, 0.045, 0.02]*100 # amplitudes
Flutef= [1, 2, 3, 4, 5]

#clarinet values
Clarc = [0.9,0.05, 0.4, 0.04, 0.07, 0.03, 0.04]*100 # amplitudes
Clarf= [1, 2, 3, 4, 5, 6, 7]


octave = 4
BPM=120
BPS=BPM/60
QuarterSamples=S/BPS
Notetype= 2

function NoiseY(noise::Vector, lo::Int64, hi::Int64)
    N = length(noise)
    cutoff_hz = [lo, hi] # frequency range to retain (pass)
    cutoff_index = round.(Int, cutoff_hz/S*N) # k = (f/S)*N
    fx = fft(noise) # spectrum
    fz = zeros(eltype(fx), size(fx))
    pass = (1+cutoff_index[1]):min(1+cutoff_index[2], N)
    fz[pass] .= fx[pass] # pass band
    return 2*real(ifft(fz)) # convert back to time domain
end


function miditone(midi::Int64, Instrument::Int64, Envindex::Int64, Vibamt::Float64, vibSpd::Float64, Tamt::Float64, Trate::Float64, Notetype::Int64, Octave::Int64) 
    if Instrument==1
        x=Audio(midi, Flutef, Flutec, Envindex, Vibamt, vibSpd, Tamt, Trate, Notetype, Octave )
    elseif Instrument==2
        C=Audio(midi, Clarf, Clarc, Envindex, Vibamt, vibSpd, Tamt, Trate, Notetype, Octave )
    end
    #calls the audio function depending on what instrument we are playing
    return nothing
end



function Audio(midi::Int64, F::Vector{Int64}, c::Vector{Float64}, Envindex::Int64, Vibamt::Float64, Vibspd::Float64, Tamt::Float64, Trate::Float64, Notetype::Int64, octave::Int64)
    #converts note type into the relative notetype for usage
    if Notetype==1
        Notetype=1/4 #sixteenth
    elseif Notetype==2
        Notetype=1/2 #eight
    elseif Notetype==3
        Notetype=1 #Quarter
    elseif Notetype==4
        Notetype=2 #half
    elseif Notetype==5
        Notetype=4 #Full
    elseif Notetype==6
        Notetype=0 #Rest
    else
        println("Invalid not duration selcted")
    end
    
    N = Int(floor(Notetype * S / BPS)) # 0.5 sec
    t = (0:N-1)/S # time samples: t = n/S
    
    Noise= 2.5*randn(size(t)) 
    freq =(440 * 2^((midi-69)/12)) * 2^(float(octave)-2) # compute frequency from midi number - FIXED!
  
    f=F*freq #applies frequency to harmonics

    #Vibrato
    lfo = Vibspd*0.0001 * cos.(2π*Vibamt*t) / 4 #the ammount we vibrato by

    z = +([c[k] * sin.(2π * f[k] * t + f[k] * lfo) for k in 1:length(c)]...) #generates the wave and applies vibrato
    
    #Generating Noise
    if c==Flutec #Appends to the indiviual song vectors
        Noise=NoiseY(Noise, FLo, FHi) #Flute Noise
    elseif c==Clarc
        Noise=NoiseY(Noise, CLo, CHi) #Clarinet Noise
    else
        println("Invalid Instrument selected")
    end

    
    
    x = z.+ Noise #applies noise which we pass in

    Duration=BPS*Notetype/4 #duration of note
    #This is to generate the envelope and it will call values that are hard set within the code
    if Envindex ==2
        Envtime=NomETime*Duration
        EnvVal=NomEValue
    elseif Envindex==1
        Envtime=StacETime*Duration
        EnvVal=StacEValue
    else 
        println("You have inputted an invalid articulation")
        env=zeros(size(t), 1)
    end
    env=interp1(Envtime,EnvVal,t) #this uses the envelope values chosen above to generate the envelope

    Z = env .* x #applies the envelope

    #Generating Tremolo
    Tremlfo = (1-Tamt*0.1).- Tamt*0.1 * cos.(2π*Trate*t) # what frequency?
    Music = Tremlfo .* Z

    soundsc(Music, S)# play note so that user can hear it immediately


    
    if c==Flutec #Appends to the indiviual song vectors
        global Fsong= [Fsong ; Music] #Flute
        global FNotetype= [FNotetype; Notetype]
    elseif c==Clarc
        global Csong= [Csong ; Music] #Clarinet
        global CNotetype = [CNotetype; Notetype]
    else
        println("Invalid Instrument selected")
    end
    return nothing
end



#Flute Noise
FLo=500
FHi=10000

CLo=50
CHi=600

#delete function
function delete_clicked(Insturment::Int64)
    if Insturment==1 #if the current instrument selection is a flute
        if length(Fsong)==0 
            println("Song empty")
        else
            global FNotetype
            Note=FNotetype[length(FNotetype)]
            N = Int(floor(Note * S / BPS))
            global Fsong
            SLength=length(Fsong)

            global Fsong=deleteat!(Fsong, (SLength-N+1):SLength )
            pop!(FNotetype)
        end
    elseif Insturment==2 #if the current insturment selection is a clarinet 
        if length(Csong)==0 
            println("Song empty")
        else
            global CNotetype
            Note=CNotetype[length(CNotetype)]
            N = Int(floor(Note * S / BPS))
            global Csong
            SLength=length(Csong)

            global Csong=deleteat!(Csong,(SLength-N+1):SLength )
            pop!(CNotetype)
        end
    else 
        print("Please select an Insturment to delete a note")
    end
end

function Play_button_clicked(w) # callback function for "end" button
  println("The play button")
  global Fsong

  global Csong

  global FinFsong= Fsong #ddeclaring final song vectors
  global FinCsong= Csong

  Fsize=length(Fsong) #getting length of Song vectors
  Csize=length(Csong)
  I=Fsize
  if I<Csize #making song vectors equal length
      I=Csize
      addzero=Csize-Fsize
      addedzeros=zeros(addzero, 1)
      FinFsong=[FinFsong; addedzeros]
  elseif I> Csize
      addzero=Fsize-Csize
      addedzeros=zeros(addzero, 1)
      FinCsong=[FinCsong; addedzeros]
  elseif I==Csize
  end
  song= FinFsong.+FinCsong #adding song vectors together
  soundsc(song, S) # play the entire song when user clicks "end"
  Song=song./100 #adjusts volume for output
  wavwrite(Song,"Proj3audio.WAV"; Fs=44400) # save song to file

end






