//
//  NVHighpassFilter.h
//  NVDSP
//
//  Created by Bart Olsthoorn on 18/05/2012.
//  Copyright (c) 2012 Bart Olsthoorn. All rights reserved.
//

#import "NVDSP.h"

@interface NVHighpassFilter : NVDSP

- (void) calculateCoefficients;

@property (nonatomic, assign, setter=setCornerFrequency:) float cornerFrequency;
@property (nonatomic, assign, setter=setQ:) float Q;

@end
