## High-performance DSP for audio on iOS and OSX with Novocaine.

While Novocaine allows you to easily read/play audio, it is still quite hard to apply filters to the audio. This (Objective-C++) class will allow you to apply all sorts of filters (high-pass, band-pass, peaking EQ, shelving EQ etc.) in just a few lines of code.

### Quick introduction/example (highpass filter)
``` objective-c
// ... import Novocaine and audioFilerReader
#import "NVDSP/NVDSP.h"
#import "NVDSP/Filters/NVHighpassFilter.h"

// init Novocaine audioManager
audioManager = [Novocaine audioManager];
float samplingRate = audioManager.samplingRate;

// init fileReader which we will later fetch audio from
NSURL *inputFileURL = [[NSBundle mainBundle] URLForResource:@"Trentemoller-Miss-You" withExtension:@"mp3"];

fileReader = [[AudioFileReader alloc] 
                  initWithAudioFileURL:inputFileURL 
                  samplingRate:audioManager.samplingRate
                  numChannels:audioManager.numOutputChannels];

// setup Highpass filter
NVHighpassFilter *HPF;
HPF = [[NVHighpassFilter alloc] initWithSamplingRate:samplingRate];

HPF.cornerFrequency = 2000.0f;
HPF.Q = 0.5f;

// setup audio output block
[fileReader play];
[audioManager setOutputBlock:^(float *outData, UInt32 numFrames, UInt32 numChannels) {
    [fileReader retrieveFreshAudio:outData numFrames:numFrames numChannels:numChannels];
    
    [HPF filterData:outData numFrames:numFrames numChannels:numChannels];
}];
```

### More examples
Peaking EQ filter
``` objective-c
NVPeakingEQFilter *PEF = [[NVPeakingEQFilter alloc] initWithSamplingRate:audioManager.samplingRate];
PEF.centerFrequency = 1000.0f;
PEF.Q = 3.0f;
PEF.G = 20.0f;
[PEF filterData:data numFrames:numFrames numChannels:numChannels];
```

### A thing to note: 
The NVDSP class is written in C++, so the classes that use it will have to be Objective-C++. Change all the files that use NVDSP from MyClass.m to MyClass.mm.

### Thanks to
Alex Wiltschko - Creator of [Novocaine](http://alexbw.github.com/novocaine/)

Yasoshima - Writer of [this article](http://objective-audio.jp/2008/02/biquad-filter.html), revealing how vDSP_deq22 works.

hrnt - Helpful on IRC #iphonedev (freenode)