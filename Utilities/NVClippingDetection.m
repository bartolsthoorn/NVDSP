//
//  NVClippingDetection.m
//  NVDSP
//
//  Created by Bart Olsthoorn on 22/05/2012.
//  Copyright (c) 2012 Bart Olsthoorn. All rights reserved.
//

#import "NVClippingDetection.h"

@implementation NVClippingDetection

- (float) getClippedPercentage:(float*)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels {
    
    float clippedSamples = [self getClippedSamples:data threshold:1.0f numFrames:numFrames numChannels:numChannels];
    
    if (clippedSamples > 0) {
        return clippedSamples/(numFrames*numChannels);
    } else {
        return 0.0f;
    }
}

- (float) getClippedSamples:(float *)data threshold:(float)threshold numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels {
    float totalSamples = numChannels*numFrames;
    float clippedSamples = 0;
    
    
    for (int i = 0; i < totalSamples; i++) {
        float sampleValue = (float) abs((float) data[i]);
        if (sampleValue > threshold) {
            clippedSamples++;
        }
    }
    return clippedSamples;
}

- (float) getClippingSample:(float *)data threshold:(float)threshold numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels {
    float totalSamples = numChannels*numFrames;
    float clippingValue = 0.0f;
    
    for (int i = 0; i < totalSamples; i++) {
        float sampleValue = (float) abs((float) data[i]);
        if (sampleValue > threshold) {
            if (sampleValue > clippingValue) {
                clippingValue = (double) sampleValue;
            }
        }
    }
    
    return clippingValue;
}

- (void) counterClipping:(float *)outData threshold:(float)threshold numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels {
    while ([self getClippedSamples:outData threshold:threshold numFrames:numFrames numChannels:numChannels] > 0.0f) {
        [super applyGain:outData length:numFrames*numChannels gain:0.8];
    }
}

@end
