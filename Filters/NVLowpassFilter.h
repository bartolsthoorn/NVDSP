//
//  NVLowpassFilter.h
//  NVDSP
//
//  Created by Bart Olsthoorn on 20/05/2012.
//  Copyright (c) 2012 Bart Olsthoorn
//  MIT licensed, see license.txt
//

#import "NVDSP.h"

@interface NVLowpassFilter : NVDSP

- (void) calculateCoefficients;

@property (nonatomic, assign, setter=setCornerFrequency:) float cornerFrequency;
@property (nonatomic, assign, setter=setQ:) float Q;

@end
