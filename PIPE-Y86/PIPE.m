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
		//set switch_stop to 0
		switch_stop = 0;
		//insList, breakpoints and sys_log always get renewed when loading images
	}
	return self;
}

- (void) loadImage: (char*) ifilePath {
	//prepare insList, breakpoints and sys_log
	insList = [NSMutableArray new];
	breakpoints = [NSMutableSet new];
	sys_log = [NSMutableArray new];
	//read file
	FILE* fp;
	fp = fopen(ifilePath, "r");
	if (fp == NULL) {
		NSLog(@"No image has been read.");
		return;
	}
	char tmp[100];
	int i, address;
	NSMutableString *inst = nil, *tmp_address;
	//for debug
	int counter = 0;
	//
	while (fgets(tmp, 100, fp) != NULL) {
		//for debug
		counter++;
		printf("%3d %s", counter, tmp);
		//
		for (i = 0; i < strlen(tmp); i++) {
			if (tmp[i] == '|') {
				//for debug
				//printf("'|' Found\n");
				//
				goto END_LOOP;
			}
			if (tmp[i] == '0')
				break;
		}
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
		for (i = i + 1; i < strlen(tmp); i++) {
			if (tmp[i] == '|')
				goto END_LOOP;
			if ((tmp[i]>='0'&&tmp[i]<='9') || (tmp[i]>='A'&&tmp[i]<='F') || (tmp[i]>='a'&&tmp[i]<='f'))
				break;
		}
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
		//for debug
		printf("One Added\n");
		//
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
	
	//pipeline control logic
	//For F
	int F_stall_1 = ([[E_register objectForKey:@"icode"] intValue]==IMRMOVL) || ([[E_register objectForKey:@"icode"] intValue]==IPOPL);
	int F_stall_2 = ([[E_register objectForKey:@"dstM"] intValue]==DecodeUnit.d_srcA) || ([[E_register objectForKey:@"dstM"] intValue]==DecodeUnit.d_srcB);
	int F_stall_3 = ([[D_register objectForKey:@"icode"] intValue]==IRET) || ([[E_register objectForKey:@"icode"] intValue]==IRET) || ([[M_register objectForKey:@"icode"] intValue]==IRET);
	F_stall = (F_stall_1 && F_stall_2) || F_stall_3;
	//For D
	D_stall = F_stall_1 && F_stall_2;
	int D_bubble_1 = ([[E_register objectForKey:@"icode"] intValue] == IJXX) && !ExecuteUnit.e_Cnd;
	int D_bubble_2 = !D_stall;
	D_bubble = D_bubble_1 || (D_bubble_2 && F_stall_3);
	//For E
	E_bubble = D_bubble_1 || D_stall;
	//For M & W
	W_stall = ([[W_register objectForKey:@"stat"] intValue] != SAOK);
	M_bubble = (MemoryUnit.m_stat != SAOK) || W_stall;
	//use control logic values
	if (!F_stall)
		[FetchUnit WritePredPC: &F_predPC];
	if (D_bubble) {
		[D_register setObject:[NSNumber numberWithInt:SAOK] forKey:@"stat"];
		[D_register setObject:[NSNumber numberWithInt:INOP] forKey:@"icode"];
		[D_register setObject:[NSNumber numberWithInt:CA] forKey:@"ifun"];
	} else if (!D_stall)
		[FetchUnit WriteData:D_register];
	if (E_bubble) {
		[E_register setObject:[NSNumber numberWithInt:SAOK] forKey:@"stat"];
		[E_register setObject:[NSNumber numberWithInt:INOP] forKey:@"icode"];
		[E_register setObject:[NSNumber numberWithInt:CA] forKey:@"ifun"];
	} else
		[DecodeUnit WriteData:E_register];
	if (M_bubble) {
		[M_register setObject:[NSNumber numberWithInt:SAOK] forKey:@"stat"];
		[M_register setObject:[NSNumber numberWithInt:INOP] forKey:@"icode"];
	} else
		[ExecuteUnit WriteData:M_register];
	if (!W_stall)
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
	[currValues setObject:[E_register objectForKey:@"stat"] forKey:@"E_stat"];
	[currValues setObject:[E_register objectForKey:@"icode"] forKey:@"E_icode"];
	[currValues setObject:[E_register objectForKey:@"ifun"] forKey:@"E_ifun"];
	[currValues setObject:[E_register objectForKey:@"valC"] forKey:@"E_valC"];
	[currValues setObject:[E_register objectForKey:@"valA"] forKey:@"E_valA"];
	[currValues setObject:[E_register objectForKey:@"valB"] forKey:@"E_valB"];
	[currValues setObject:[E_register objectForKey:@"dstE"] forKey:@"E_dstE"];
	[currValues setObject:[E_register objectForKey:@"dstM"] forKey:@"E_dstM"];
	[currValues setObject:[E_register objectForKey:@"srcA"] forKey:@"E_srcA"];
	[currValues setObject:[E_register objectForKey:@"srcB"] forKey:@"E_srcB"];
	[currValues setObject:[M_register objectForKey:@"stat"] forKey:@"M_stat"];
	[currValues setObject:[M_register objectForKey:@"icode"] forKey:@"M_icode"];
	[currValues setObject:[M_register objectForKey:@"Cnd"] forKey:@"M_Cnd"];
	[currValues setObject:[M_register objectForKey:@"valE"] forKey:@"M_valE"];
	[currValues setObject:[M_register objectForKey:@"valA"] forKey:@"M_valA"];
	[currValues setObject:[M_register objectForKey:@"dstE"] forKey:@"M_dstE"];
	[currValues setObject:[M_register objectForKey:@"dstM"] forKey:@"M_dstM"];
	[currValues setObject:[W_register objectForKey:@"stat"] forKey:@"W_stat"];
	[currValues setObject:[W_register objectForKey:@"icode"] forKey:@"W_icode"];
	[currValues setObject:[W_register objectForKey:@"valE"] forKey:@"W_valE"];
	[currValues setObject:[W_register objectForKey:@"valM"] forKey:@"W_valM"];
	[currValues setObject:[W_register objectForKey:@"dstE"] forKey:@"W_dstE"];
	[currValues setObject:[W_register objectForKey:@"dstM"] forKey:@"W_dstM"];
	//do not forget the CC
	[currValues setObject:[NSNumber numberWithInt:ExecuteUnit.CC_ZF] forKey:@"CC_ZF"];
	[currValues setObject:[NSNumber numberWithInt:ExecuteUnit.CC_SF] forKey:@"CC_SF"];
	//save it in the log array
	[sys_log addObject:currValues];
}

- (void) singleStepBackward {
	//if it is the first step (or no step), cannot go backward
	if ([sys_log count] <= 1)
		return;
	NSMutableDictionary* lastStep = [sys_log lastObject];
	//F_register
	F_predPC = [[lastStep objectForKey:@"F_predPC"] intValue];
	//D_register
	[D_register setObject:[lastStep objectForKey:@"D_stat"] forKey:@"stat"];
	[D_register setObject:[lastStep objectForKey:@"D_icode"] forKey:@"icode"];
	[D_register setObject:[lastStep objectForKey:@"D_ifun"] forKey:@"ifun"];
	[D_register setObject:[lastStep objectForKey:@"D_rA"] forKey:@"rA"];
	[D_register setObject:[lastStep objectForKey:@"D_rB"] forKey:@"rB"];
	[D_register setObject:[lastStep objectForKey:@"D_valC"] forKey:@"valC"];
	[D_register setObject:[lastStep objectForKey:@"D_valP"] forKey:@"valP"];
	//E_register
	[E_register setObject:[lastStep objectForKey:@"E_stat"] forKey:@"stat"];
	[E_register setObject:[lastStep objectForKey:@"E_icode"] forKey:@"icode"];
	[E_register setObject:[lastStep objectForKey:@"E_ifun"] forKey:@"ifun"];
	[E_register setObject:[lastStep objectForKey:@"E_valC"] forKey:@"valC"];
	[E_register setObject:[lastStep objectForKey:@"E_valA"] forKey:@"valA"];
	[E_register setObject:[lastStep objectForKey:@"E_valB"] forKey:@"valB"];
	[E_register setObject:[lastStep objectForKey:@"E_dstE"] forKey:@"dstE"];
	[E_register setObject:[lastStep objectForKey:@"E_dstM"] forKey:@"dstM"];
	[E_register setObject:[lastStep objectForKey:@"E_srcA"] forKey:@"srcA"];
	[E_register setObject:[lastStep objectForKey:@"E_srcB"] forKey:@"srcB"];
	//M_register
	[M_register setObject:[lastStep objectForKey:@"M_stat"] forKey:@"stat"];
	[M_register setObject:[lastStep objectForKey:@"M_icode"] forKey:@"icode"];
	[M_register setObject:[lastStep objectForKey:@"M_Cnd"] forKey:@"Cnd"];
	[M_register setObject:[lastStep objectForKey:@"M_valE"] forKey:@"valE"];
	[M_register setObject:[lastStep objectForKey:@"M_valA"] forKey:@"valA"];
	[M_register setObject:[lastStep objectForKey:@"M_dstE"] forKey:@"dstE"];
	[M_register setObject:[lastStep objectForKey:@"M_dstM"] forKey:@"dstM"];
	//W_register
	[W_register setObject:[lastStep objectForKey:@"W_stat"] forKey:@"stat"];
	[W_register setObject:[lastStep objectForKey:@"W_icode"] forKey:@"icode"];
	[W_register setObject:[lastStep objectForKey:@"W_valE"] forKey:@"valE"];
	[W_register setObject:[lastStep objectForKey:@"W_valM"] forKey:@"valM"];
	[W_register setObject:[lastStep objectForKey:@"W_dstE"] forKey:@"dstE"];
	[W_register setObject:[lastStep objectForKey:@"W_dstM"] forKey:@"dstM"];
	//CC
	ExecuteUnit.CC_ZF = [[lastStep objectForKey:@"CC_ZF"] intValue];
	ExecuteUnit.CC_SF = [[lastStep objectForKey:@"CC_SF"] intValue];
	//remove the last step
	[sys_log removeLastObject];
}

- (void) setBreakpointAt: (int) iaddress {
	[breakpoints addObject: [NSNumber numberWithInt: iaddress]];
}

- (void) removeBreakpointFrom: (int) iaddress {
	[breakpoints removeObject: [NSNumber numberWithInt: iaddress]];
}

- (void) runSlowly {
	while ([[W_register objectForKey:@"stat"] intValue] == SAOK) {
		//if switch_stop is true
		if (switch_stop != 0) {
			switch_stop = 0;
			return;
		}
		//if there's a breakpoint
		if ([breakpoints containsObject: [NSNumber numberWithInt:FetchUnit.f_pc]]) {
			NSLog(@"A breakpoint detected.");
			return;
		}
		//else, run normally
		[self singleStepForward];
		//... and wait
		sleep(1);
	}
}

- (void) run {
	while ([[W_register objectForKey:@"stat"] intValue] == SAOK) {
		//if switch_stop is true
		if (switch_stop != 0) {
			switch_stop = 0;
			return;
		}
		//if there's a breakpoint
		if ([breakpoints containsObject: [NSNumber numberWithInt:FetchUnit.f_pc]]) {
			NSLog(@"A breakpoint detected.");
			return;
		}
		//else, run normally
		[self singleStepForward];
		//for debug
		//printf("One Step\n");
		//
	}
}

- (void) Pause {
	switch_stop = 1;
}
@end









