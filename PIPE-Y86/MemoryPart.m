//
//  MemoryPart.m
//  PIPE-Y86
//
//  Created by XuanYuan on 15/5/25.
//  Copyright (c) 2015年 XuanYuan. All rights reserved.
//

#import "MemoryPart.h"

@implementation MemoryPart
@synthesize m_stat;
@synthesize m_valM;
@synthesize dMemory;

- (id) initWithMemory: (NSMutableDictionary*) Memory {
	if (self = [super init]) {
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

- (void) Calculate {
	//set default values
	m_stat = M_stat;
	m_icode = M_icode;
	m_valE = M_valE;
	m_dstE = M_dstE;
	m_dstM = M_dstM;
	//set mem_read&write
	int mem_read = 0, mem_write = 0, mem_addr = 0;
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
		if (mem_read)
			m_valM = [[dMemory objectForKey:[NSNumber numberWithInt:mem_addr]] intValue];
		if (mem_write)
			[dMemory setObject:[NSNumber numberWithInt:M_valA] forKey:[NSNumber numberWithInt:mem_addr]];
	}
	@catch (NSException *exception) {
		dmem_error = 1;
	}
	if (dmem_error)
		m_stat = SADR;
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









