## High-performance DSP for audio on iOS and OSX with Novocaine.

While Novocaine allows you to easily read/play audio, it is still quite hard to apply filters to the audio. This (Objective-C++) class will allow you to apply all sorts of filters (high-pass, band-pass, peaking EQ, shelving EQ etc.) in just a few lines of code.

### Quick introduction/example
``` objective-c
audioManager = [Novocaine audioManager];
generalDSP = [[NVDSP alloc] init];

Novocaine *audioManager = [Novocaine audioManager];
[audioManager setOutputBlock:^(float *outData, UInt32 numFrames, UInt32 numChannels) {
    [fileReader retrieveFreshAudio:outData numFrames:numFrames numChannels:numChannels];
    // Audio comes in interleaved
    
    // SamplingRate is required for filter calculation so set it first
    [generalDSP setSamplingRate:audioManager.samplingRate];
    
    // Prepare for a HPF (high-pass filter)
    float cornerFrequency = 1000.0f;
    [generalDSP setHPF:cornerFrequency Q:0.5f];
    
    // Apply HPF to the audio data
    [generalDSP applyInterleavedFilter:outData length:numFrames*numChannels];
    
    // Prepare for another filter, a peaking EQ
    float centerFrequency = 4000.0f;
    [generalDSP setPeakingEQ:centerFrequency Q:4.0f gain:20];
    
    // Apply peaking EQ filter
    [generalDSP applyInterleavedFilter:outData length:numFrames*numChannels];
    
    // Audio is now filtered by two types of filters and still interleaved :)
}];
```

### More examples
Coming soon...

### A thing to note: 
The NVDSP class is written in C++, so the classes that use it will have to be Objective-C++. Change all the files that use NVDSP from MyClass.m to MyClass.mm.

### Thanks to
Alex Wiltschko - Creator of [Novocaine](http://alexbw.github.com/novocaine/)
Yasoshima - Writer of [this article](http://objective-audio.jp/2008/02/biquad-filter.html), revealing how vDSP_deq22 works.

hrnt - Helpful on IRC #iphonedev (freenode)