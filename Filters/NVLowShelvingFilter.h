//
//  NVLowShelvingFilter.h
//  NVDSP
//
//  Created by Bart Olsthoorn on 21/07/2012.
//  Copyright (c) 2012 Bart Olsthoorn
//  MIT licensed, see license.txt
//

#import "NVDSP.h"

@interface NVLowShelvingFilter : NVDSP

- (void) calculateCoefficients;

@property (nonatomic, assign, setter=setCenterFrequency:) float centerFrequency;
@property (nonatomic, assign, setter=setQ:) float Q;
@property (nonatomic, assign, setter=setG:) float G;

@end
