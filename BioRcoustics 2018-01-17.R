setwd("~/Documents/BioRcoustics")
install.packages("tuneR")
library(tuneR)


#Open the documentation for tuneR to see what functions it contains
#Loading Wav Files ----

#Let's start by reading in a wav file. I'll use the proc.time
#function to time how long this takes.

x=proc.time()
sound=readWave('Sound1.wav')
proc.time()-x


#You'll notice that took some time, since it's a 10 minute file.
#On my computer it took 2.29 seconds.
#Let's see the other options:
?readWave

#The from and to arguments can be used to specify which 
#parts of the sound file to read. Say we're only interested in
#the first 3 minutes.
x=proc.time()
sound=readWave('Sound1.wav', from=0, to=180, units='seconds')
#specify seconds, otherwise units are in samples. You could 
#do the same thing with from=1, to =1+(180*sample.rate), units='samples'
proc.time()-x

#That took only 0.44 seconds. Shorter bits of file are faster to read.

#Suppose you don't want to read the file at all, only
#get some metadata (sample rate, bit depth, length, etc.)
#use the header command.
x=proc.time()
sound=readWave('Sound1.wav', header=T)
#specify seconds, otherwise units are in samples. You could 
#do the same thing with from=1, to =1+(180*sample.rate), units='samples'
proc.time()-x #it runs even faster. 0.05 seconds.

#Generating, editing, saving wav files----
#Say we want to edit a sound file.
#Jocelyn and I had to do this because in the localization
#array, some recordings are offset by exactly 1 second.
#To bring them into synchronization, we have to add
#one exactly second of noise to the beginning of the file.

#Load the original sound
sound=readWave('Sound1.wav')
bits=sound@bit
pcm=sound@pcm
Fs=sound@samp.rate
#Every setting (sample rate, bit depth, pcm, must be 
#identical if the two sounds are later to be combined)
noise=noise(duration=Fs, samp.rate=Fs, stereo=T, bit=bits,
            pcm=pcm)
#Related functions: silence(), sine(), square(), sawtooth(), etc.

#combine them with the bind function
newsound=bind(noise,sound)

#save the sound with the writeWave function
writeWave(newsound, 'NewSound.wav')
#There's now an extra second tacked onto the beginning.

#Power Spectra----
#Let's see where most of the energy lies in the signal with
#the powspec function
#We'll just work with the first 20 seconds for simplicity.
sound=readWave('Sound1.wav', from=0, to=5, units='seconds')
Fs=sound@samp.rate #Get the sample rate.
Samples=length(sound@left) #get the number of samples
Length=Samples/Fs #calculate recording length.
#Now make a power spectrum for the duration of the recording.
?powspec
power=powspec(sound@left, sr=Fs, wintime=Length) 

#Now plot it.
plot(power, type='l')

#WTF. There is a huge amount of power at the low frequencies
#What could cause that?
#DC offset is one possibility. Plot samples to check
plot(sound@right, type='l')
#Notice how the samples are NOT centered at 0? 
#That's DC offset. Let's remove it.
sound@left=sound@left-mean(sound@left)
plot(sound@left, type='l') #better.

#Let's try the power spectrum again.
power=powspec(sound@left, sr=Fs, wintime=Length)
plot(power, type='l') #Better, but there's still a lot of low
#frequency noise. Let's just change the y limits.
power=powspec(sound@right, sr=Fs, wintime=Length, steptime=Length)
plot(power, type='l', ylim=c(0, 1e11)) 

#Question: what does the x axis represent?

#Took me some time to figure it out:

winpts=Length*Fs
nfft=2^(ceiling(log(winpts)/log(2))) 
sequence=0:(nfft/2-1)
Freqs=sequence/nfft*Fs
plot(Freqs, power, type='l',ylim=c(0, 1e11))

#Let's try the periodogram function
?periodogram
Pgram=periodogram(sound) #Doesn't work with two channels
onechan=mono(sound, which='left')
Pgram=periodogram(onechan)
plot(Pgram) #looks familiar, that's good! Only y scale is changed.
plot(Pgram, ylim=c(0, 0.001))

#Mel Frequency Cepstral Coefficients and deltas----

MFCC=melfcc(sound) #The help file lies!
MFCC=melfcc(onechan)
#Note that the wintime is 0.025, hoptime is 0.01
#So we should get (5-0.025)/0.01 windows.
#Each contains 12 MFCC coefficients.

MFCCDeltas=deltas(t(MFCC))
