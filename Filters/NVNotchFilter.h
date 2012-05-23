//
//  NVNotchFilter.h
//  NVDSP
//
//  Created by Bart Olsthoorn on 23/05/2012.
//  Copyright (c) 2012 Bart Olsthoorn
//  MIT licensed, see license.txt
//

#import "NVDSP.h"

@interface NVNotchFilter : NVDSP

- (void) calculateCoefficients;

@property (nonatomic, assign, setter=setCenterFrequency:) float centerFrequency;
@property (nonatomic, assign, setter=setQ:) float Q;

@end
