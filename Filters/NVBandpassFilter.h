//
//  NVBandpassFilter.h
//  NVDSP
//
//  Created by Bart Olsthoorn on 23/05/2012.
//  Copyright (c) 2012 Bart Olsthoorn. All rights reserved.
//

#import "NVDSP.h"

// There are two types of Bandpass filters, this is Peak gain = Q

@interface NVBandpassFilter : NVDSP

- (void) calculateCoefficients;

@property (nonatomic, assign, setter=setCenterFrequency:) float centerFrequency;
@property (nonatomic, assign, setter=setQ:) float Q;

@end
