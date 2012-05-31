//
//  NVSoundLevelMeter.m
//  NVDSP
//
//  Created by Bart Olsthoorn on 23/05/2012.
//  Copyright (c) 2012 Bart Olsthoorn. All rights reserved.
//

#import "NVSoundLevelMeter.h"

@implementation NVSoundLevelMeter

- (id)init {
    self = [super init];
    if (self) {
        dBLevel = 0.0f;
    }
    return self;
}

- (float) getdBLevel:(float *)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels {
    float copyData[numFrames*numChannels];
    
    vDSP_vsq(data, 1, copyData, 1, numFrames*numChannels);
    float meanVal = 0.0;
    vDSP_meanv(copyData, 1, &meanVal, numFrames*numChannels);
    
    vDSP_vdbcon(&meanVal, 1, &one, &meanVal, 1, 1, 0);
    one = 1.0f;
    
    dBLevel = dBLevel + 0.2*(meanVal - dBLevel);
    
    if (dBLevel != dBLevel) {
        // nan
        dBLevel = -50.0f;
    }
    
    return dBLevel;
}
@end
