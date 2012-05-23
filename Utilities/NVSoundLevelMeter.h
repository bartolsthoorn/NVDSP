//
//  NVSoundLevelMeter.h
//  NVDSP
//
//  Copyright (c) 2012 Bart Olsthoorn
//  MIT licensed, see license.txt
//

#import "NVDSP.h"

@interface NVSoundLevelMeter : NVDSP {
    float dBLevel;
}

- (float) getdBLevel:(float *)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels;

@end
