//
//  NVBandpassQPeakGainFilter.m
//  NVDSP
//
//  Created by Bart Olsthoorn on 24/05/2012.
//  Copyright (c) 2012 Bart Olsthoorn
//  MIT licensed, see license.txt
//

#import "NVBandpassQPeakGainFilter.h"

@implementation NVBandpassQPeakGainFilter

@synthesize Q;
@synthesize centerFrequency;

- (void) setQ:(float)_Q {
    Q = _Q;
    [self calculateCoefficients];
}

- (void) setCenterFrequency:(float)_centerFrequency {
    centerFrequency = _centerFrequency;
    [self calculateCoefficients];
}

- (void) calculateCoefficients {
    if ((centerFrequency != 0.0f) && (Q != 0.0f)) {
        
        [self intermediateVariables:centerFrequency Q:Q];
        
        a0 = 1 + alpha;
        b0 = ( Q * alpha)           / a0;
        b1 = 0                      / a0;
        b2 = (-Q * alpha)           / a0;
        a1 = (-2 * omegaC)          / a0;
        a2 = (1 - alpha)            / a0;
        
        [super setCoefficients];
    }
}

@end
