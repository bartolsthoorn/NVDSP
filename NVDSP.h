//
//  NVDSP.h
//  NVDSP
//
//  Created by Bart Olsthoorn on 13/05/2012.
//  Copyright (c) 2012 Bart Olsthoorn
//  MIT licensed, see license.txt
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>

@interface NVDSP : NSObject {
    float zero, one;
    
    float samplingRate;
    
    float *gInputKeepBuffer[2];
    float *gOutputKeepBuffer[2];
    
    float omega, omegaS, omegaC, alpha;
    
    float coefficients[5];
    
    float a0, a1, a2, b0, b1, b2;
}

- (id) initWithSamplingRate:(float)sr;

#pragma mark - Setters
- (void) setCoefficients;


#pragma mark - Effects
- (void) filterContiguousData: (float *)data numFrames:(UInt32)numFrames channel:(UInt32)channel;
- (void) filterData:(float *)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels;

- (void) applyGain:(float *)data length:(vDSP_Length)length gain:(float)gain;


#pragma mark - Etc
- (void) intermediateVariables: (float)Fc Q: (float)Q;
- (void) deinterleave: (float *)data left: (float*) left right: (float*) right length: (vDSP_Length)length;
- (void) interleave: (float *)data left: (float*) left right: (float*) right length: (vDSP_Length)length;

#pragma mark - Debug
- (void) logCoefficients;
- (void) stabilityWarning;

@end
