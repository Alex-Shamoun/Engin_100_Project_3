using Sound
using FFTW
using Plots
# S = 44100
# N = Int(2.0 * S)
# t = (0:N-1)/S # time samples: t = n/S
# I = 0 .+ 9*t/maximum(t) # slowly increase modulation index
# x =sin.(2π*100*t + I .* sin.(2π*100*t))+ 0.5*sin.(2π*600*t + I .* sin.(2π*600*t))+0.3*sin.(2π*500*t + I .* sin.(2π*500*t))
# +sin.(2π*200*t + I .* sin.(2π*200*t))+ 0.5*sin.(2π*400*t + I .* sin.(2π*400*t))+0.3*sin.(2π*800*t + I .* sin.(2π*800*t)) + sin.(2π*900*t + I .* sin.(2π*100*t))+ 0.5*sin.(2π*600*t + I .* sin.(2π*600*t))+0.3*sin.(2π*500*t + I .* sin.(2π*500*t))
# +sin.(2π*1050*t + I .* sin.(2π*1200*t))+ 0.5*sin.(2π*1300*t + I .* sin.(2π*1400*t))+0.3*sin.(2π*1800*t + I .* sin.(2π*150*t))

# sound(x,S)
# plot(x, marker=:circle)




#creating model of flute
S = 44100
N = Int(1 * S) # 0.5 sec
t = (0:N-1)/S # time samples: t = n/S
c = [1522.4, 611.3, 412.6, 195.7, 66.1 ] # amplitudes
# f = [526.205, 1051.5, 1579.7, 2103.2, 2633.1] # frequencies
f= [1, 2, 3, 4, 5] *526.205
z = cos.(2π * t * f'*2^(24/12)).+0.1*randn(size(t))
x = z * c
env = (1 .- exp.(-10*t)) # fast attack; slow decay
y = env .* x .*reverse(env)
soundsc(y, S)
plot(y)







# m=N

# soundsc(x,S)
# plot(x, marker=:circle)




# S = 44100
# N = Int(1 * S)
# t = (0:N-1)/S
# c = 1 ./ (1:8) # amplitudes
# f = (1:2:15) * 400 # frequencies
# I = 0 .+ 40*t/maximum(t)
# for k in 1:length(c)
#     global x = +(c[k] * cos.(2π * f[k] * t + I .* cos.(2π*400*t))) 
# end
# env = (1 .- exp.(-20*t)) .* exp.(-5*t) # fast attack; slow decay
# y = env .* x
# sound(y, S)
# plot(y)


