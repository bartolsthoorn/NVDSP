//
//  NVClippingDetection.m
//  NVDSP
//
//  Created by Bart Olsthoorn on 22/05/2012.
//  Copyright (c) 2012 Bart Olsthoorn. All rights reserved.
//

#import "NVClippingDetection.h"

@implementation NVClippingDetection

- (id)init {
    if (self = [super init]) {
        threshold = 1.0f;
    }
    return self;
}

- (float) getClippedPercentage:(float*)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels {
    
    float clippedSamples = [self getClippedSamples:data numFrames:numFrames numChannels:numChannels];
    
    if (clippedSamples > 0) {
        return clippedSamples/(numFrames*numChannels);
    } else {
        return 0.0f;
    }
}

- (UInt32) getClippedSamples:(float *)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels {
    float totalSamples = numChannels*numFrames;
    UInt32 clippedSamples = 0;
    
    
    for (int i = 0; i < totalSamples; i++) {
        float sampleValue = fabsf((float)data[i]);
        if (sampleValue >= threshold) {
            clippedSamples++;
        }
    }
    return clippedSamples;
}

- (float) getClippingSample:(float *)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels {
    float totalSamples = numChannels*numFrames;
    float clippingValue = 0.0f;
    
    for (int i = 0; i < totalSamples; i++) {
        float sampleValue = fabsf((float)data[i]);
        if (sampleValue > threshold) {
            if (sampleValue > clippingValue) {
                clippingValue = sampleValue;
            }
        }
    }
    
    return clippingValue;
}

- (void) counterClipping:(float *)outData numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels {
    threshold = 1.0f;
    while ([self getClippedSamples:outData numFrames:numFrames numChannels:numChannels] > 0) {
        [super applyGain:outData length:numFrames*numChannels gain:0.9];
    }
}

@end
