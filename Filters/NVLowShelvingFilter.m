//
//  NVLowShelvingFilter.m
//  NVDSP
//
//  Created by Bart Olsthoorn on 21/07/2012.
//  Copyright (c) 2012 Bart Olsthoorn
//  MIT licensed, see license.txt
//

#import "NVLowShelvingFilter.h"

@implementation NVLowShelvingFilter

@synthesize Q;
@synthesize G;
@synthesize centerFrequency;

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
				float beta = sqrt(A / Q);

        a0 = (A + 1) + ((A - 1) * omegaC) + (beta * omegaS);
        b0 = (A * ((A + 1) - ((A - 1) * omegaC) + (beta * omegaS)))			/ a0; 
        b1 = (2 * A * ((A - 1 ) - ((A + 1) * omegaC)))          				/ a0; 
        b2 = (A * ((A + 1) - ((A - 1) * omegaC) - (beta * omegaS)))    	/ a0;
        a1 = (-2 * ((A - 1) + ((A + 1) * omegaC)))          						/ a0; 
        a2 = ((A + 1) + ((A - 1) * omegaC) - (beta * omegaS))        		/ a0;
        
        [super setCoefficients];
    }
}

@end
