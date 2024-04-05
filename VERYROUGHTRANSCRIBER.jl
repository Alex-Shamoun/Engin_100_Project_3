using MAT
using Plots; default(markerstrokecolor=:auto, label="")


song = matread("/Users/comradereznov/Documents/VS_Code/Engin_100/Project_1/proj1_2.mat")["song"]
y=reshape(song, 2000, :)

n = 500

F= (7999/(2pi)) * acos.((y[n + 1, :] + y[n - 1, :]) ./ (2y[n, :]))
# F=[440, 464]
midi = 69 .+ round.(Int, 12 * log2.(F/440))

V = [0 .25 .5 .75 1 1.25 1.5 2 2.25 2.5 2.75 3 3.5 3.75 4 4.25 4.5 4.75 5 5.5 5.75 6 6.25 6.5 7 7.25 7.5 7.75 8 8.25 8.5 9 9.25 9.5 9.75 10 10.5 10.25 10.5 ]

v = V[midi .- 52]

plot(v, line=:stem, marker=:circle, markersize = 8, color=:black)
plot!(size = (800,400)) # size of plot
plot!(widen=true) # try not to cut off the markers
plot!(xticks = [], ylims = (-0.1,10.7)) # for staff
yticks!(0:12, ["F3","A3","C4","E4", "G4", "B4", "D4", "F4", "A4", "C5", "E5", "G5"]) # helpful labels for staff lines
#plot!(axis=nothing, border=:none) # ignore this
plot!(yforeground_color_grid = :blue) # blue staff, just for fun
plot!(foreground_color_border = :white) # make border "invisible"
plot!(gridlinewidth = 1.5) # try commenting out each of these to see what they do!!!!
plot!(gridalpha = 0.9) # make grid lines more visible

savefig("/Users/comradereznov/Documents/VS_Code/Engin_100/Project_1/Custom.png")
