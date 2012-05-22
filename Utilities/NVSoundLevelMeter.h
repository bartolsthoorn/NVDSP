//
//  NVSoundLevelMeter.h
//  NVDSP
//
//  Created by Bart Olsthoorn on 23/05/2012.
//  Copyright (c) 2012 Bart Olsthoorn. All rights reserved.
//

#import "NVDSP.h"

@interface NVSoundLevelMeter : NVDSP {
    float dBLevel;
}

- (float) getdBLevel:(float *)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels;

@end
