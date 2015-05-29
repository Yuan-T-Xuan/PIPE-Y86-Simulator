//
//  PIPE.m
//  PIPE-Y86
//
//  Created by XuanYuan on 15/5/26.
//  Copyright (c) 2015年 XuanYuan. All rights reserved.
//

#import "PIPE.h"

static int str2int(NSString* instr) {
	int result = 0, length = 0;
	length = (int)[instr length];
	int i;
	for (i = 0; i < length; i++) {
		if ([instr characterAtIndex:i] >= '0' && [instr characterAtIndex:i] <= '9')
			result = result * 16 + [instr characterAtIndex:i] - '0';
		else if ([instr characterAtIndex:i] >= 'A' && [instr characterAtIndex:i] <= 'F')
			result = result * 16 + [instr characterAtIndex:i] + 10 - 'A';
		else
			result = result * 16 + [instr characterAtIndex:i] + 10 - 'a';
	}
	return result;
}

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
		[W_register setObject:[NSNumber numberWithInt:SAOK] forKey:@"stat"];
		[W_register setObject:[NSNumber numberWithInt:INOP] forKey:@"icode"];
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
		//initiate the rest pipeline stored values
		[D_register setObject:[NSNumber numberWithInt:RNONE] forKey:@"rA"];
		[D_register setObject:[NSNumber numberWithInt:RNONE] forKey:@"rB"];
		[D_register setObject:[NSNumber numberWithInt:0] forKey:@"valC"];
		[D_register setObject:[NSNumber numberWithInt:0] forKey:@"valP"];
		[E_register setObject:[NSNumber numberWithInt:0] forKey:@"valC"];
		[E_register setObject:[NSNumber numberWithInt:0] forKey:@"valA"];
		[E_register setObject:[NSNumber numberWithInt:0] forKey:@"valB"];
		[E_register setObject:[NSNumber numberWithInt:RNONE] forKey:@"dstE"];
		[E_register setObject:[NSNumber numberWithInt:RNONE] forKey:@"dstM"];
		[E_register setObject:[NSNumber numberWithInt:REAX] forKey:@"srcA"];
		[E_register setObject:[NSNumber numberWithInt:REAX] forKey:@"srcB"];
		
		//insList, breakpoints and sys_log always get renewed when loading images
	}
	return self;
}

- (void) loadImage: (NSString*) ifilePath {
	//prepare insList, breakpoints and sys_log
	insList = [NSMutableArray new];
	breakpoints = [NSMutableSet new];
	sys_log = [NSMutableArray new];
	//read file
	FILE* fp;
	fp = fopen([ifilePath cStringUsingEncoding: NSASCIIStringEncoding], "r");
	char tmp[100];
	int i, address;
	NSMutableString *inst = nil, *tmp_address;
	while (fgets(tmp, 100, fp) != NULL) {
		for (i = 0; i < strlen(tmp); i++)
			if (tmp[i] == '|')
				goto END_LOOP;
			if (tmp[i] == '0')
				break;
		if (tmp[++i] != 'x')
			continue;
		tmp_address = [NSMutableString new];
		for (i = i + 1; i < strlen(tmp); i++) {
			if ((tmp[i]>='0'&&tmp[i]<='9') || (tmp[i]>='A'&&tmp[i]<='F') || (tmp[i]>='a'&&tmp[i]<='f'))
				[tmp_address appendFormat:@"%c", tmp[i]];
			else
				break;
		}
		address = str2int(tmp_address);
		if (tmp[i] != ':')
			continue;
		for (i = i + 1; i < strlen(tmp); i++)
			if (tmp[i] == '|')
				goto END_LOOP;
			if ((tmp[i]>='0'&&tmp[i]<='9') || (tmp[i]>='A'&&tmp[i]<='F') || (tmp[i]>='a'&&tmp[i]<='f'))
				break;
		if (i == strlen(tmp))
			continue;
		inst = [NSMutableString new];
		for (; i < strlen(tmp); i++) {
			if ((tmp[i]>='0'&&tmp[i]<='9') || (tmp[i]>='A'&&tmp[i]<='F') || (tmp[i]>='a'&&tmp[i]<='f'))
				[inst appendFormat:@"%c", tmp[i]];
			else
				break;
		}
		[insList addObject: [[instruction alloc] initAddress:address andInstruction:inst]];
		END_LOOP:
		i = i;	//no use ...
	}
	[FetchUnit InitInstructionMemory:insList];
}

- (void) singleStepForward {
	[MemoryUnit GetData:M_register];
	[MemoryUnit Calculate];
	[ExecuteUnit GetData:E_register W_stat:[[W_register objectForKey:@"stat"] intValue] m_stat:MemoryUnit.m_stat];
	[ExecuteUnit Calculate];
	
	[DecodeUnit GetData:D_register e_dstE:ExecuteUnit.e_dstE e_valE:ExecuteUnit.e_valE M_dstE:[[M_register objectForKey:@"dstE"] intValue] M_valE:[[M_register objectForKey:@"valE"] intValue] M_dstM:[[M_register objectForKey:@"dstM"] intValue] m_valM:MemoryUnit.m_valM W_dstM:[[W_register objectForKey:@"dstM"] intValue] W_valM:[[W_register objectForKey:@"valM"] intValue] W_dstE:[[W_register objectForKey:@"dstE"] intValue] W_valE:[[W_register objectForKey:@"valE"] intValue]];
	[DecodeUnit Calculate];
	[FetchUnit GetData:F_predPC M_valA:[[M_register objectForKey:@"valA"] intValue] W_valM:[[W_register objectForKey:@"valM"] intValue] M_Cnd:[[M_register objectForKey:@"Cnd"] intValue] M_icode:[[M_register objectForKey:@"icode"] intValue] W_icode:[[W_register objectForKey:@"icode"] intValue]];
	[FetchUnit Calculate];
	[WriteUnit GetData:W_register];
	
	[FetchUnit WriteData:D_register];
	[DecodeUnit WriteData:E_register];
	[ExecuteUnit WriteData:M_register];
	[MemoryUnit WriteData:W_register];
	[WriteUnit WriteData:DecodeUnit.RegisterFile];
	
	//write system log
	//create a dictionary to store curr values
	NSMutableDictionary* currValues = [NSMutableDictionary new];
	[currValues setObject:[NSNumber numberWithInt:F_predPC] forKey:@"F_predPC"];
	[currValues setObject:[D_register objectForKey:@"stat"] forKey:@"D_stat"];
	[currValues setObject:[D_register objectForKey:@"icode"] forKey:@"D_icode"];
	[currValues setObject:[D_register objectForKey:@"ifun"] forKey:@"D_ifun"];
	[currValues setObject:[D_register objectForKey:@"rA"] forKey:@"D_rA"];
	[currValues setObject:[D_register objectForKey:@"rB"] forKey:@"D_rB"];
	[currValues setObject:[D_register objectForKey:@"valC"] forKey:@"D_valC"];
	[currValues setObject:[D_register objectForKey:@"valP"] forKey:@"D_valP"];
	//to be continued ...
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









