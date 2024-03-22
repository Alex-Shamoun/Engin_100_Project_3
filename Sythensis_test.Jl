using Sound
using FFTW
S = 44100
N = Int(2.0 * S)
t = (0:N-1)/S # time samples: t = n/S
I = 0 .+ 9*t/maximum(t) # slowly increase modulation index
x =sin.(2π*100*t + I .* sin.(2π*100*t))+ 0.5*sin.(2π*600*t + I .* sin.(2π*600*t))+0.3*sin.(2π*500*t + I .* sin.(2π*500*t))
+sin.(2π*200*t + I .* sin.(2π*200*t))+ 0.5*sin.(2π*400*t + I .* sin.(2π*400*t))+0.3*sin.(2π*800*t + I .* sin.(2π*800*t)) + sin.(2π*900*t + I .* sin.(2π*100*t))+ 0.5*sin.(2π*600*t + I .* sin.(2π*600*t))+0.3*sin.(2π*500*t + I .* sin.(2π*500*t))
+sin.(2π*1050*t + I .* sin.(2π*1200*t))+ 0.5*sin.(2π*1300*t + I .* sin.(2π*1400*t))+0.3*sin.(2π*1800*t + I .* sin.(2π*150*t))

sound(x,S)
plot(x, marker=:circle)


# S = 44100
# N = Int(0.02 * S) # 0.5 sec
# t = (0:N-1)/S # time samples: t = n/S
# c = [2, 0.2, 0.1, 0.3, 3, 4, 0.1, 0.4, 0.6, 1] # amplitudes
# f = [1, 2, 5, 10, 12, 14, 16, 3, 4, 6] * 100 # frequencies
# z = cos.(2π * t * f')
# x = z * c
# m=N

# sound(x,S)
# plot(x, marker=:circle)