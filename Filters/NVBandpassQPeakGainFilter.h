//
//  NVBandpassQPeakGainFilter.h
//  NVDSP
//
//  Created by Bart Olsthoorn on 24/05/2012.
//  Copyright (c) 2012 Bart Olsthoorn. All rights reserved.
//

#import "NVDSP.h"

@interface NVBandpassQPeakGainFilter : NVDSP

- (void) calculateCoefficients;

@property (nonatomic, assign, setter=setCenterFrequency:) float centerFrequency;
@property (nonatomic, assign, setter=setQ:) float Q;

@end
