//
//  ViewController.m
//  NVDSPExample
//
//  Created by Bart Olsthoorn on 25/04/2013.
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    ringBuffer = new RingBuffer(32768, 2);
    audioManager = [Novocaine audioManager];
    float samplingRate = audioManager.samplingRate;
    
    // Audio File Reading
    NSURL *inputFileURL = [[NSBundle mainBundle] URLForResource:@"TLC" withExtension:@"mp3"];        

    HPF = [[NVHighpassFilter alloc] initWithSamplingRate:samplingRate];
    _HPF_cornerFrequency = 2000.0f;
    
    fileReader = [[AudioFileReader alloc]
                  initWithAudioFileURL:inputFileURL 
                  samplingRate:audioManager.samplingRate
                  numChannels:audioManager.numOutputChannels];
    
    [fileReader play];
    fileReader.currentTime = 30.0;
    
    
    [audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
     {
         [fileReader retrieveFreshAudio:data numFrames:numFrames numChannels:numChannels];
         //NSLog(@"Time: %f", fileReader.currentTime);
         
         HPF.cornerFrequency = _HPF_cornerFrequency;
         HPF.Q = 0.5f;
         
         [HPF filterData:data numFrames:numFrames numChannels:numChannels];
     }];
}

- (void)HPFSliderChanged:(UISlider *)sender
{
    _HPF_cornerFrequency = sender.value;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
