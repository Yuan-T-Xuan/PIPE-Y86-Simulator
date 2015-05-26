//
//  PIPE.m
//  PIPE-Y86
//
//  Created by XuanYuan on 15/5/26.
//  Copyright (c) 2015年 XuanYuan. All rights reserved.
//

#import "PIPE.h"

@implementation PIPE
@synthesize insList;
@synthesize breakpoints;
@synthesize switch_stop;
@synthesize F_predPC;
@synthesize D_register;
@synthesize E_register;
@synthesize M_register;
@synthesize W_register;
@synthesize sys_log;

- (id) init {
	if (self = [super init]) {
		
	}
	return self;
}

- (void) loadImage: (NSString*) ifilePath {
	
}

- (void) singleStepForward {
	
}

- (void) singleStepBackward {
	
}

- (void) setBreakpointAt: (int) iaddress {
	
}

- (void) removeBreakpointFrom: (int) iaddress {
	
}

- (void) runSlowly {
	
}

- (void) run {
	
}

- (void) Pause {
	
}
@end









