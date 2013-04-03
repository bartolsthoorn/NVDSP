//
//  NVPeakingEQFilter.h
//  NVDSP
//
//  Created by Bart Olsthoorn on 19/05/2012.
//  Copyright (c) 2012 Bart Olsthoorn
//  MIT licensed, see license.txt
//

#import "NVDSP.h"

@interface NVPeakingEQFilter : NVDSP

- (void) calculateCoefficients;

@property (nonatomic, assign, setter=setCenterFrequency:) float centerFrequency;
@property (nonatomic, assign, setter=setQ:) float Q;
@property (nonatomic, assign, setter=setG:) float G;

@end
