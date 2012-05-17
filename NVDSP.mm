//
//  NVDSP.mm
//  NVDSP
//
//  Created by Bart Olsthoorn on 13/05/2012.
//  Copyright (c) 2012 Bart Olsthoorn. All rights reserved.
//  http://bartolsthoorn.nl
//

#import "NVDSP.h"

#define DEFAULT_CHANNEL_COUNT 2

@implementation NVDSP

- (id) init
{
    if ( self = [super init] )
    {
        for(int i = 0; i < 5; i++) {
            coefficients[i] = 0.0f;
        }
        
        for(int i = 0; i < DEFAULT_CHANNEL_COUNT; i++) {
            gInputKeepBuffer[i] = (float*) calloc(2, sizeof(float));
            gOutputKeepBuffer[i] = (float*) calloc(2, sizeof(float));
        }
        
        zero = 0.0f;
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
    
    free(gInputKeepBuffer);
    free(gOutputKeepBuffer);
}

#pragma mark - Getters

- (float *) getCoefficients {
    return coefficients;
}
- (float) getSamplingRate {
    return samplingRate;
}

#pragma mark - Setters

- (void) setChannelCount:(NSUInteger)channels {
    if (channels > 2) {
        for(int i = 2; i < channels; i++) {
            gInputKeepBuffer[i] = (float*) calloc(2, sizeof(float));
            gOutputKeepBuffer[i] = (float*) calloc(2, sizeof(float));
        }
    }
}

- (void) setSamplingRate:(float)input {
    samplingRate = input;
}


- (void) setPeakingEQ:(float)Fc Q:(float)Q gain:(float)G {
   
    [self intermediateVariables:Fc Q:Q];
    
    float A = sqrt(pow(10.0f, (G/20.0f)));
    
    a0 = (1  + (alpha / A));
    b0 = (1 + (alpha * A))     / a0; 
    b1 = (-2 * omegaC)         / a0; 
    b2 = (1 - (alpha * A))     / a0;
    a1 = (-2 * omegaC)         / a0; 
    a2 = (1 - alpha / A)       / a0;
    
    [self setCoefficients];
}

- (void) setHPF:(float)Fc Q:(float)Q {
    
    [self intermediateVariables:Fc Q:Q];
    
    a0 = 1 + alpha;
    b0 = ((1 + omegaC)/2)      / a0;
    b1 = (-1*(1 + omegaC))     / a0;
    b2 = ((1 + omegaC)/2)      / a0;
    a1 = (-2 * omegaC)         / a0;
    a2 = (1 - alpha)           / a0; 
    
    [self setCoefficients];
}

- (void) setCoefficients {
    // // { b0/a0, b1/a0, b2/a0, a1/a0, a2/a0 }
    coefficients[0] = b0;
    coefficients[1] = b1;
    coefficients[2] = b2;
    coefficients[3] = a1;
    coefficients[4] = a2;
}


#pragma mark - Effects

- (void) applyGain:(float *)data length:(vDSP_Length)length gain:(float)gain {
    vDSP_vsmul(data, 1, &gain, data, 1, length);
}

- (void) applyInterleavedFilter: (float*) data length:(NSUInteger)length {
    float left[length/2];
    float right[length/2];
    [self deinterleave:data left:left right:right length:length/2];
    [self applyFilter:left length:length/2 channel:0];
    [self applyFilter:right length:length/2 channel:1];
    [self interleave:data left:left right:right length:length/2];
}

- (void) applyFilter: (float *)data length:(NSUInteger)length channel:(NSUInteger)channel {
    
    // Provide buffer for processing
    float *tInputBuffer = (float*) malloc((length + 2) * sizeof(float));
    float *tOutputBuffer = (float*) malloc((length + 2) * sizeof(float));
    
    // Copy the data
    memcpy(tInputBuffer, gInputKeepBuffer[channel], 2 * sizeof(float));
    memcpy(tOutputBuffer, gOutputKeepBuffer[channel], 2 * sizeof(float));
    memcpy(&(tInputBuffer[2]), data, length * sizeof(float));
    
    // Do the processing
    vDSP_deq22(tInputBuffer, 1, coefficients, tOutputBuffer, 1, length);
    
    // Copy the data
    memcpy(data, tOutputBuffer, length * sizeof(float));
    memcpy(gInputKeepBuffer[channel], &(tInputBuffer[length]), 2 * sizeof(float));
    memcpy(gOutputKeepBuffer[channel], &(tOutputBuffer[length]), 2 * sizeof(float));
    
    free(tInputBuffer);
    free(tOutputBuffer);
}

#pragma mark - Etc

- (void) deinterleave: (float *)data left: (float*) left right: (float*) right length: (vDSP_Length)length {
    vDSP_vsadd(data, 2, &zero, left, 1, length);   
    vDSP_vsadd(data+1, 2, &zero, right, 1, length); 
}

- (void) interleave: (float *)data left: (float*) left right: (float*) right length: (vDSP_Length)length {
    vDSP_vsadd(left, 1, &zero, data, 2, length);   
    vDSP_vsadd(right, 1, &zero, data+1, 2, length); 
}

- (void) intermediateVariables: (float)Fc Q: (float)Q {
    omega = 2*M_PI*Fc/samplingRate;
    omegaS = sin(omega);
    omegaC = cos(omega);
    alpha = omegaS / (2*Q);
}

#pragma mark - Debug
- (void) logCoefficients {
    NSLog(@"------------\n");
    NSLog(@"Coefficients:\n");
    
    NSLog(@"b0: %f\n", b0);
    NSLog(@"b1: %f\n", b1);
    NSLog(@"b2: %f\n", b2);
    NSLog(@"a1: %f\n", a0);
    NSLog(@"a1: %f\n", a1);
    NSLog(@"a2: %f\n", a2);
    
    NSLog(@"\n");
    
    NSLog(@"|a1| < 1 + a2 ");
    if (abs(a1) < (1 + a2)) {
        NSLog(@"a1 is stable\n");
    } else {
        NSLog(@"a1 is unstable\n");
    }
    
    NSLog(@"|a2| < 1");
    if (abs(a2) < 1) {
        NSLog(@"a2 is stable\n");
    } else {
        NSLog(@"a2 is unstable\n");
    }
    
    NSLog(@"------------\n");
}

@end