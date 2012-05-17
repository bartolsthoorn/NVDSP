//
//  NVDSP.h
//  NVDSP
//
//  Created by Bart Olsthoorn on 13/05/2012.
//  Copyright (c) 2012 Bart Olsthoorn. All rights reserved.
//  http://bartolsthoorn.nl
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>

@interface NVDSP : NSObject {
    float zero;
    
    float samplingRate;
    
    float *gInputKeepBuffer[2];
    float *gOutputKeepBuffer[2];
    
    float omega, omegaS, omegaC, alpha;
    
    float coefficients[5];
    float a0, a1, a2, b0, b1, b2;
    
    float channelCount;
}

#pragma mark - Getters
- (float *) getCoefficients;
- (float) getSamplingRate;

#pragma mark - Setters
- (void) setChannelCount:(NSUInteger)channels;
- (void) setSamplingRate: (float)   input;
- (void) setPeakingEQ:(float)Fc Q:(float)Q gain:(float)G;
- (void) setHPF:(float)Fc Q:(float)Q;
- (void) setCoefficients;

#pragma mark - Effects
- (void) applyFilter: (float *)data length:(NSUInteger)length channel:(NSUInteger)channel;
- (void) applyInterleavedFilter: (float*) data length:(NSUInteger)length;
- (void) applyGain:(float *)data length:(vDSP_Length)length gain:(float)gain;

#pragma mark - Etc
- (void) intermediateVariables: (float)Fc Q: (float)Q;
- (void) deinterleave: (float *)data left: (float*) left right: (float*) right length: (vDSP_Length)length;
- (void) interleave: (float *)data left: (float*) left right: (float*) right length: (vDSP_Length)length;

#pragma mark - Debug
- (void) logCoefficients;

@end