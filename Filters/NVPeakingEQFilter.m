//
//  NVPeakingEQFilter.m
//  NVDSP
//
//  Created by Bart Olsthoorn on 19/05/2012.
//  Copyright (c) 2012 Bart Olsthoorn
//  MIT licensed, see license.txt
//

#import "NVPeakingEQFilter.h"

@implementation NVPeakingEQFilter

@synthesize Q;
@synthesize centerFrequency;
@synthesize G;

- (void) setQ:(float)_Q {
    Q = _Q;
    [self calculateCoefficients];
}

- (void) setG:(float)_G {
    G = _G;
    [self calculateCoefficients];
}

- (void) setCenterFrequency:(float)_centerFrequency {
    centerFrequency = _centerFrequency;
    [self calculateCoefficients];
}

- (void) calculateCoefficients {
    if ((centerFrequency != 0.0f) && (Q != 0.0f)) {
        
        [self intermediateVariables:centerFrequency Q:Q];
        
        float A = sqrt(pow(10.0f, (G/20.0f)));
        
        a0 = (1  + (alpha / A));
        b0 = (1 + (alpha * A))     / a0; 
        b1 = (-2 * omegaC)         / a0; 
        b2 = (1 - (alpha * A))     / a0;
        a1 = (-2 * omegaC)         / a0; 
        a2 = (1 - alpha / A)       / a0;
        
        [super setCoefficients];
    }
}

@end
