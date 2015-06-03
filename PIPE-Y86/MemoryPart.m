//
//  MemoryPart.m
//  PIPE-Y86
//
//  Created by XuanYuan on 15/5/25.
//  Copyright (c) 2015年 XuanYuan. All rights reserved.
//

#import "MemoryPart.h"

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

static NSString* little2big(NSString* instr) {
	char c1, c2, c3, c4, c5, c6, c7, c8;
	c1 = [instr characterAtIndex:0];
	c2 = [instr characterAtIndex:1];
	c3 = [instr characterAtIndex:2];
	c4 = [instr characterAtIndex:3];
	c5 = [instr characterAtIndex:4];
	c6 = [instr characterAtIndex:5];
	c7 = [instr characterAtIndex:6];
	c8 = [instr characterAtIndex:7];
	NSString* result = [NSString stringWithFormat:@"%c%c%c%c%c%c%c%c", c7,c8,c5,c6,c3,c4,c1,c2];
	return result;
}

@implementation MemoryPart
@synthesize mem_addr;
@synthesize prev_datum;
@synthesize m_stat;
@synthesize m_valM;
@synthesize dMemory;

- (id) initWithMemory: (NSMutableDictionary*) Memory {
	if (self = [super init]) {
		m_stat = SAOK;
		m_valM = 0;
		dMemory = Memory;
	}
	return self;
}

- (void) GetData: (NSMutableDictionary *) M_Register {
	M_stat = [[M_Register objectForKey:@"stat"] intValue];
	M_icode = [[M_Register objectForKey:@"icode"] intValue];
	M_Cnd = [[M_Register objectForKey:@"Cnd"] intValue];
	M_valE = [[M_Register objectForKey:@"valE"] intValue];
	M_valA = [[M_Register objectForKey:@"valA"] intValue];
	M_dstE = [[M_Register objectForKey:@"dstE"] intValue];
	M_dstM = [[M_Register objectForKey:@"dstM"] intValue];
}

- (int) Calculate {
	int type = 0;	//for return value
	prev_datum = 0;
	//set default values
	m_stat = M_stat;
	m_icode = M_icode;
	m_valE = M_valE;
	m_dstE = M_dstE;
	m_dstM = M_dstM;
	//set mem_read&write
	int mem_read = 0, mem_write = 0;
	if(M_icode == IMRMOVL || M_icode == IPOPL || M_icode == IRET)
		mem_read = 1;
	if(M_icode == IRMMOVL || M_icode == IPUSHL || M_icode == ICALL)
		mem_write = 1;
	//set memory address
	if (M_icode == IRMMOVL || M_icode == IPUSHL || M_icode == ICALL || M_icode == IMRMOVL)
		mem_addr = M_valE;
	else if (M_icode == IPOPL || M_icode == IRET)
		mem_addr = M_valA;
	//read/write memory (and set M_stat)
	int dmem_error = 0;
	@try {
		if (mem_read) {
			//what if the value was stored as a NSString?
			id tmp = [dMemory objectForKey:[NSNumber numberWithInt:mem_addr]];
			if ([tmp isKindOfClass: [NSString class]])
				m_valM = str2int(little2big((NSString*)tmp));
			else
				m_valM = [(NSNumber*)tmp intValue];
			type = -1;
		}
		if (mem_write) {
			type = 1;
			if ([dMemory objectForKey:[NSNumber numberWithInt:mem_addr]] != nil) {
				prev_datum = [[dMemory objectForKey:[NSNumber numberWithInt:mem_addr]] intValue];
				type = 2;
			}
			[dMemory setObject:[NSNumber numberWithInt:M_valA] forKey:[NSNumber numberWithInt:mem_addr]];
			
		}
	}
	@catch (NSException *exception) {
		dmem_error = 1;
	}
	if (dmem_error) {
		printf("Memory Error\n");
		m_stat = SADR;
	}
	return type;
}

- (void) WriteData: (NSMutableDictionary *) W_Register {
	[W_Register setObject:[NSNumber numberWithInt:m_stat] forKey:@"stat"];
	[W_Register setObject:[NSNumber numberWithInt:m_icode] forKey:@"icode"];
	[W_Register setObject:[NSNumber numberWithInt:m_valE] forKey:@"valE"];
	[W_Register setObject:[NSNumber numberWithInt:m_valM] forKey:@"valM"];
	[W_Register setObject:[NSNumber numberWithInt:m_dstE] forKey:@"dstE"];
	[W_Register setObject:[NSNumber numberWithInt:m_dstM] forKey:@"dstM"];
}
@end









