// Example: 10-band Equalizer
// Please note: this code is not 100% click and run. 
// You have to copy/paste these in the parts in your app where you want to use them, but if you know Novocaine, 
// this makes sense! I recommend you to take a look at how Novocaine works first, it's easy!

// For example, init the filters and run Novocaine in the app delegate and communicate with the app delegate to
// set the gain for the filters (PEQ[bandIndex].G = someValue). Well just read through this:

#import <UIKit/UIKit.h>

#import "Novocaine.h"
#import "RingBuffer.h"
#import "AudioFileReader.h"
#import "AudioFileWriter.h"

#import "NVDSP/NVDSP.h"
#import "NVDSP/NVPeakingEQFilter.h"
#import "NVDSP/NVSoundLevelMeter.h"

// init ringbuffer and novocaine
ringBuffer = new RingBuffer(32768, 2); 
audioManager = [Novocaine audioManager];

float sr = audioManager.samplingRate;

// define center frequencies of the bands
float centerFrequencies[10];
centerFrequencies[0] = 60.0f;
centerFrequencies[1] = 170.0f;
centerFrequencies[2] = 310.0f;
centerFrequencies[3] = 600.0f;
centerFrequencies[4] = 1000.0f;
centerFrequencies[5] = 3000.0f;
centerFrequencies[6] = 6000.0f;
centerFrequencies[7] = 12000.0f;
centerFrequencies[8] = 14000.0f;
centerFrequencies[9] = 16000.0f;

// define Q factor of the bands
QFactor = 2.0f;

// define initial gain
initialGain = 0.0f;

// init PeakingFilters
// You'll later need to be able to set the gain for these (as the sliders change)
// So define them somewhere global using NVPeakingEQFilter *PEQ[10];
for (int i = 0; i < 10; i++) {
   PEQ[i] = [[NVPeakingEQFilter alloc] initWithSamplingRate:sr];
   PEQ[i].Q = QFactor;
   PEQ[i].centerFrequency = centerFrequencies[i];
   PEQ[i].G = initialGain;
}

// init SoundLevelMeters
inputWatcher = [[NVSoundLevelMeter alloc] init];
outPutWatcher = [[NVSoundLevelMeter alloc] init];

// init fileReader with HappyUpThere.mp3
NSURL *inputFileURL = [[NSBundle mainBundle] URLForResource:@"HappyUpThere" withExtension:@"mp3"];        
    
    fileReader = [[AudioFileReader alloc] 
                  initWithAudioFileURL:inputFileURL 
                  samplingRate:audioManager.samplingRate
                  numChannels:audioManager.numOutputChannels];
    
    [fileReader play];

[audioManager setOutputBlock:^(float *outData, UInt32 numFrames, UInt32 numChannels) {
	// pull data from the filereader
	[fileReader retrieveFreshAudio:outData numFrames:numFrames numChannels:numChannels];
	
	// measure input level
	inputLevelBuffer = [inputWatcher getdBLevel:outData numFrames:numFrames numChannels:numChannels];
	
	// apply the filter
	for (int i = 0; i < 10; i++) {
		[PEQ[i] filterData:outData numFrames:numFrames numChannels:numChannels];
	}
	
	// measure output level
	outputLevelBuffer = [outPutWatcher getdBLevel:outData numFrames:numFrames numChannels:numChannels];
}];


// Now while the above setOutputBlock code runs use:
PEQ[0].G = 10.0f;
PEQ[9].G = 10.0f;
// to set the first and last band to 10dB gain.

// A smart way to do this is to use the tag of the slider to match the EQ band and the value to match the gain!
- (IBAction)sliderChanged:(UISlider *)sender {
    PEQ[sender.tag].sender.value
}