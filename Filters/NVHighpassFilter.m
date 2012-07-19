//
//  NVHighpassFilter.m
//  NVDSP
//
//  Created by Bart Olsthoorn on 18/05/2012.
//  Copyright (c) 2012 Bart Olsthoorn
//  MIT licensed, see license.txt
//

#import "NVHighpassFilter.h"

@implementation NVHighpassFilter

@synthesize Q;
@synthesize cornerFrequency;

- (void) setQ:(float)_Q {
    Q = _Q;
    [self calculateCoefficients];
}

- (void) setCornerFrequency:(float)_cornerFrequency {
    cornerFrequency = _cornerFrequency;
    [self calculateCoefficients];
}
         
- (void) calculateCoefficients {
    if ((cornerFrequency != 0.0f) && (Q != 0.0f)) {
        
        [self intermediateVariables:cornerFrequency Q:Q];
        
        a0 = 1 + alpha;
        b0 = ((1 + omegaC)/2)      / a0;
        b1 = (-1*(1 + omegaC))     / a0;
        b2 = ((1 + omegaC)/2)      / a0;
        a1 = (-2 * omegaC)         / a0;
        a2 = (1 - alpha)           / a0;
        
        [super setCoefficients];
    }
}

@end
