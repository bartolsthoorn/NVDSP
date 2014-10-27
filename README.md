## Audio Filters on iOS and OSX
[![DOI](https://zenodo.org/badge/6288/bartolsthoorn/NVDSP.png)](http://dx.doi.org/10.5281/zenodo.12415)

Implement high quality audio filters with just a few lines of code and [Novocaine](https://github.com/alexbw/novocaine), or your own audio library of choice.

NVDSP comes with a wide variety of audio filters:

+ All Pass Filter (NVAllpassFilter)
+ Band Pass Filter, 0dB gain (NVBandpassFilter)
+ Band Pass Filter, Q gain (NVBandpassQPeakGainFilter)
+ High Pass Filter (NVHighpassFilter)
+ High Shelving Filter (NVHighShelvingFilter)
+ Low Shelving Filter (NVLowShelvingFilter)
+ Low Pass Filter (NVLowPassFilter)
+ Notch Filter (NVNotchFilter)
+ Peaking EQ Filter (NVPeakingEQFilter)

### Combining it with Novocaine (highpass filter)
To start out I recommend you to get a fresh copy of [Novocaine](https://github.com/alexbw/novocaine) and open Novocaine's excellent example project. Then import NVDSP and the Filters folder and start your filtering journey.
``` objective-c
// ... import Novocaine here ... 
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
Note that NVDSP works with raw audio buffers, so it can also work with other libraries instead of Novocaine.

### More examples
#### Peaking EQ filter
``` objective-c
NVPeakingEQFilter *PEF = [[NVPeakingEQFilter alloc] initWithSamplingRate:audioManager.samplingRate];
PEF.centerFrequency = 1000.0f;
PEF.Q = 3.0f;
PEF.G = 20.0f;
[PEF filterData:data numFrames:numFrames numChannels:numChannels];
```

#### Lowpass filter
``` objective-c
// import Novocaine.h and NVDSP.h
#import "NVDSP/Filter/NVLowpassFilter.h"
NVLowpassFilter *LPF = [[NVLowpassFilter alloc] initWithSamplingRate:audioManager.samplingRate];
LPF.cornerFrequency = 800.0f;
LPF.Q = 0.8f;
[LPF filterData:data numFrames:numFrames numChannels:numChannels];
```

#### Notch filter
``` objective-c
// import Novocaine.h and NVDSP.h
#import "NVDSP/Filter/NVNotchFilter.h"
NVNotchFilter *NF = [[NVNotchFilter alloc] initWithSamplingRate:audioManager.samplingRate];
NF.centerFrequency = 3000.0f;
NF.Q = 0.8f;
[NF filterData:data numFrames:numFrames numChannels:numChannels];
```

#### Bandpass filter
There are two types of bandpass filters:

    * 0 dB gain bandpass filter (NVBandpassFilter.h)
    * Peak gain Q bandpass filter (NVBandpassQPeakGainFilter.h)

``` objective-c
// import Novocaine.h and NVDSP.h
#import "NVDSP/Filter/NVBandpassFilter.h"
NVBandpassFilter *BPF = [[NVBandpassFilter alloc] initWithSamplingRate:audioManager.samplingRate];
BPF.centerFrequency = 2500.0f;
BPF.Q = 0.9f;
[BPF filterData:data numFrames:numFrames numChannels:numChannels];
```

#### Measure dB level (ranging from -51.0f to 0.0f)
``` objective-c
// import Novocaine.h and NVDSP.h
#import "NVDSP/Utilities/NVSoundLevelMeter.h"
NVSoundLevelMeter *SLM = [[NVSoundLevelMeter alloc] init];
float dB = [SLM getdBLevel:outData numFrames:numFrames numChannels:numChannels];
NSLog(@"dB level: %f", dB);
// NSLogging in an output loop will most likely cause hickups/clicky noises, but it does log the dB level!
// To get a proper dB value, you have to call the getdBLevel method a few times (it has memory of previous values)
// You call this inside the input or outputBlock: [audioManager setOutputBlock:^...
```

#### Applying overall gain. 
All sample values (typically -1.0f .. 1.0f when not clipping) are multiplied by the gain value.
``` objective-c
// import Novocaine.h and NVDSP.h
NVDSP *generalDSP = [[NVDSP alloc] init];
[generalDSP applyGain:outData length:numFrames*numChannels gain:0.8];
```

#### Convert stereo (left/right) to mono
This converts a left and right buffer into a mono signal. It takes the average of the samples.
```objective-c
// Deinterleave stereo buffer into seperate left and right
float *left = (float *)malloc((numFrames + 2) * sizeof(float));
float *right = (float *)malloc((numFrames + 2) * sizeof(float));
[generalDSP deinterleave:data left:left right:right length:numFrames];

// Convert left and right to a mono 2 channel buffer
[generalDSP mono:data left:left right:right length:numFrames];

// Free buffers
free(left);
free(right);
```

### Clipping
Multiple peaking EQs with high gains can cause clipping. Clipping is basically sample data that exceeds the maximum or minimum value of 1.0f or -1.0f respectively. Clipping will cause really loud and dirty noises, like a bad overdrive effect. You can use the method `counterClipping` to prevent clipping (it will reduce the sound level).

``` objective-c
// import Novocaine.h and NVDSP.h
#import "NVDSP/Utilities/NVClippingDetection.h"
NVClippingDetection *CDT = [[NVClippingDetection alloc] init];
// ... possible clipped outData ...//
[CDT counterClipping:outData numFrames:numFrames numChannels:numChannels];
// ... outData is now safe ...//

// or get the amount of clipped samples:
 - (float) getClippedSamples:(float *)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels;
// or get the percentage of clipped samples:
 - (float) getClippedPercentage:(float*)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels;
// or get the maximum value of a clipped sample that was found
 - (float) getClippingSample:(float *)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels;
```

### Example project
See `/Examples/NVDSPExample` for a simple iOS XCodeProject example. Please note the Novocaine bundled with it might be outdated.

### A thing to note
The NVDSP class is written in C++, so the classes that use it will have to be Objective-C++. Change all the files that use NVDSP from MyClass.m to MyClass.mm.

### NVDSP powered apps in the wild
[iHearYou](https://itunes.apple.com/us/app/ihearyou/id634880747)
[Swarmy](http://jmoore.me/swarmy/)
Send a pull request and add your app to this list!

### Interested in the story behind this project?
Check [this post at Medium](https://medium.com/what-i-learned-building/1964521efbc7)

### Thanks to
Alex Wiltschko - Creator of [Novocaine](http://alexbw.github.com/novocaine/)

Yasoshima - Writer of [this article](http://objective-audio.jp/2008/02/biquad-filter.html), revealing how vDSP_deq22 works. (and google translate, I don't speak Japanese)

hrnt - Helpful on IRC #iphonedev (freenode)
