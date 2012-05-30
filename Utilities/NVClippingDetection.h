//
//  NVClippingDetection.h
//  NVDSP
//
//  Created by Bart Olsthoorn on 22/05/2012.
//  Copyright (c) 2012 Bart Olsthoorn
//  MIT licensed, see license.txt
//

#import "NVDSP.h"

@interface NVClippingDetection : NVDSP {
    float threshold;
}

- (float) getClippedPercentage:(float*)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels;
- (UInt32) getClippedSamples:(float *)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels;
- (float) getClippingSample:(float *)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels;

- (void) counterClipping:(float *)outData numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels;

@end
