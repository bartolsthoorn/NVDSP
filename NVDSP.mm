//
//  NVDSP.mm
//  NVDSP
//
//  Created by Bart Olsthoorn on 13/05/2012.
//  Copyright (c) 2012 Bart Olsthoorn
//  MIT licensed, see license.txt
//  http://bartolsthoorn.nl
//

#import "NVDSP.h"

#define MAX_CHANNEL_COUNT 2

@implementation NVDSP

- (id)initWithSamplingRate:(float)sr {
    if (self = [self init]) {
        samplingRate = sr;

        for (int i = 0; i < 5; i++) {
            coefficients[i] = 0.0f;
        }

        for (int i = 0; i < MAX_CHANNEL_COUNT; i++) {
            gInputKeepBuffer[i] = (float *)calloc(2, sizeof(float));
            gOutputKeepBuffer[i] = (float *)calloc(2, sizeof(float));
        }

        zero = 0.0f;
        one = 1.0f;
    }
    return self;
}

- (void)dealloc {
    for (int i = 0; i < MAX_CHANNEL_COUNT; i++) {
        free(gInputKeepBuffer[i]);
        free(gOutputKeepBuffer[i]);
    }
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

#pragma mark - Setters

- (void) setCoefficients {
    // // { b0/a0, b1/a0, b2/a0, a1/a0, a2/a0 }
    coefficients[0] = b0;
    coefficients[1] = b1;
    coefficients[2] = b2;
    coefficients[3] = a1;
    coefficients[4] = a2;
    
    [self stabilityWarning];
}


#pragma mark - Effects

- (void) applyGain:(float *)data length:(vDSP_Length)length gain:(float)gain {
    vDSP_vsmul(data, 1, &gain, data, 1, length);
}

- (void) filterContiguousData: (float *)data numFrames:(UInt32)numFrames channel:(UInt32)channel {
    
    // Provide buffer for processing
    float *tInputBuffer = (float*) malloc((numFrames + 2) * sizeof(float));
    float *tOutputBuffer = (float*) malloc((numFrames + 2) * sizeof(float));
    
    // Copy the data
    memcpy(tInputBuffer, gInputKeepBuffer[channel], 2 * sizeof(float));
    memcpy(tOutputBuffer, gOutputKeepBuffer[channel], 2 * sizeof(float));
    memcpy(&(tInputBuffer[2]), data, numFrames * sizeof(float));
    
    // Do the processing
    vDSP_deq22(tInputBuffer, 1, coefficients, tOutputBuffer, 1, numFrames);
    
    // Copy the data
    memcpy(data, tOutputBuffer, numFrames * sizeof(float));
    memcpy(gInputKeepBuffer[channel], &(tInputBuffer[numFrames]), 2 * sizeof(float));
    memcpy(gOutputKeepBuffer[channel], &(tOutputBuffer[numFrames]), 2 * sizeof(float));
    
    free(tInputBuffer);
    free(tOutputBuffer);
}

- (void)filterData:(float *)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels {
    switch (numChannels) {
        case 1:
            [self filterContiguousData:data numFrames:numFrames channel:0];
            break;
        case 2: {
            float *left = (float *)malloc((numFrames + 2) * sizeof(float));
            float *right = (float *)malloc((numFrames + 2) * sizeof(float));

            [self deinterleave:data left:left right:right length:numFrames];
            [self filterContiguousData:left numFrames:numFrames channel:0];
            [self filterContiguousData:right numFrames:numFrames channel:1];
            [self interleave:data left:left right:right length:numFrames];

            free(left);
            free(right);

            break;
        }
        default:
          NSLog(@"WARNING: Unsupported number of channels %lu", numChannels);
          break;
    }
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
- (void) stabilityWarning {
    if (abs(a1) < (1 + a2)) {
    } else {
        NSLog(@"|a1| < 1 + a2 ");
        NSLog(@"Warning: a1 is unstable\n");
    }
    
    if (abs(a2) < 1) {
    } else {
        NSLog(@"|a2| < 1");
        NSLog(@"Warning: a2 is unstable\n");
    }
}

@end
