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
		//instantiate five parts & registers
		FetchUnit = [[FetchPart alloc] init];
		DecodeUnit = [[DecodePart alloc] init];
		ExecuteUnit = [[ExecutePart alloc] init];
		MemoryUnit = [[MemoryPart alloc] initWithMemory: FetchUnit.iMemory];
		WriteUnit = [WritePart new];
		D_register = [NSMutableDictionary new];
		E_register = [NSMutableDictionary new];
		M_register = [NSMutableDictionary new];
		W_register = [NSMutableDictionary new];
		//initiate pipeline registers
		F_predPC = 0;
		[D_register setObject:[NSNumber numberWithInt:SAOK] forKey:@"stat"];
		[D_register setObject:[NSNumber numberWithInt:INOP] forKey:@"icode"];
		[D_register setObject:[NSNumber numberWithInt:CA] forKey:@"ifun"];
		[E_register setObject:[NSNumber numberWithInt:SAOK] forKey:@"stat"];
		[E_register setObject:[NSNumber numberWithInt:INOP] forKey:@"icode"];
		[E_register setObject:[NSNumber numberWithInt:CA] forKey:@"ifun"];
		[M_register setObject:[NSNumber numberWithInt:SAOK] forKey:@"stat"];
		[M_register setObject:[NSNumber numberWithInt:INOP] forKey:@"icode"];
		[M_register setObject:[NSNumber numberWithInt:CA] forKey:@"ifun"];
		[W_register setObject:[NSNumber numberWithInt:SAOK] forKey:@"stat"];
		[W_register setObject:[NSNumber numberWithInt:INOP] forKey:@"icode"];
		[W_register setObject:[NSNumber numberWithInt:CA] forKey:@"ifun"];
		//initiate some special values used by forwarding
		[M_register setObject:[NSNumber numberWithInt:0] forKey:@"Cnd"];
		[M_register setObject:[NSNumber numberWithInt:0] forKey:@"valA"];
		[W_register setObject:[NSNumber numberWithInt:0] forKey:@"valM"];
		[M_register setObject:[NSNumber numberWithInt:RNONE] forKey:@"dstE"];
		[M_register setObject:[NSNumber numberWithInt:0] forKey:@"valE"];
		[M_register setObject:[NSNumber numberWithInt:RNONE] forKey:@"dstM"];
		[W_register setObject:[NSNumber numberWithInt:RNONE] forKey:@"dstM"];
		[W_register setObject:[NSNumber numberWithInt:0] forKey:@"valM"];
		[W_register setObject:[NSNumber numberWithInt:RNONE] forKey:@"dstE"];
		[W_register setObject:[NSNumber numberWithInt:0] forKey:@"valE"];
		
		//insList, breakpoints and sys_log always get renewed when loading images
	}
	return self;
}

- (void) loadImage: (NSString*) ifilePath {
	//to be continued
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









