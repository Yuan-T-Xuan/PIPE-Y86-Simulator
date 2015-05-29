//
//  FetchPart.m
//  PIPE-Y86
//
//  Created by XuanYuan on 15/5/23.
//  Copyright (c) 2015年 XuanYuan. All rights reserved.
//

#import "FetchPart.h"

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

@implementation FetchPart
@synthesize iMemory;

- (id) init {
	if (self = [super init]) {
		iMemory = [NSMutableDictionary new];
	}
	return self;
}

- (void) InitInstructionMemory: (NSMutableArray*) insList {
	//to be completed...
}

- (void) GetData: (int) iPredPC M_valA: (int) iM_valA
	  W_valM: (int) iW_valM M_Cnd: (int) iM_Cnd M_icode: (int) iM_icode
	   W_icode: (int) iW_icode {
	PredPC = iPredPC;
	M_valA = iM_valA;
	W_valM = iW_valM;
	M_Cnd = iM_Cnd;
	M_icode = iM_icode;
	W_icode = iW_icode;
}

- (void) Calculate {
	int f_pc;
	if(M_icode == IJXX && !M_Cnd)
		f_pc = M_valA;
	else if(W_icode == IRET)
		f_pc = W_valM;
	else
		f_pc = PredPC;
	NSString* Instruction;
	int imem_error = 0;
	@try {
		Instruction = [iMemory objectForKey:[NSNumber numberWithInt:f_pc]];
	}
	@catch (NSException *exception) {
		imem_error = 1;
	}
	//set icode and ifun
	if (imem_error) {
		f_icode = INOP;
		f_ifun = FNONE;
	}
	else {
		f_icode = str2int([Instruction substringToIndex:1]);
		f_ifun = str2int([[Instruction substringFromIndex:1] substringToIndex:1]);
	}
	//set stat
	if (f_icode == IHALT)
		f_stat = SHLT;
	else if (f_icode != IOPL && f_icode != IJXX && f_icode != IRRMOVL && f_ifun != CA)
		f_stat = SINS;
	else if (imem_error)
		f_stat = SADR;
	else
		f_stat = SAOK;
	//more to do to set stat...
	if (f_stat == SAOK) {
		//set rA and rB
		if (f_icode == IRRMOVL || f_icode == IRMMOVL || f_icode == IIRMOVL || f_icode == IMRMOVL || f_icode == IOPL || f_icode == IPUSHL || f_icode == IPOPL) {
			f_rA = str2int([[Instruction substringFromIndex:2]substringToIndex:1]);
			f_rB = str2int([[Instruction substringFromIndex:3]substringToIndex:1]);
		}
		//set valC
		if (f_icode == IIRMOVL || f_icode == IRMMOVL || f_icode == IMRMOVL)
			f_valC = str2int(little2big([Instruction substringFromIndex:4]));
		if (f_icode == IJXX || f_icode == ICALL)
			f_valC = str2int(little2big([Instruction substringFromIndex:2]));
		//set valP
		if (f_icode == IHALT || f_icode == INOP || f_icode == IRET)
			f_valP = f_pc + 1;
		else if (f_icode ==IRRMOVL||f_icode ==IOPL|| f_icode ==IPUSHL|| f_icode ==IPOPL)
			f_valP = f_pc + 2;
		else if (f_icode == IJXX || f_icode == ICALL)
			f_valP = f_pc + 5;
		else
			f_valP = f_pc + 6;
	}
	else { f_icode = INOP; f_ifun = FNONE; }
}

- (void) WriteData: (NSMutableDictionary *) D_Register {
	[D_Register setObject:[NSNumber numberWithInt:f_stat] forKey:@"stat"];
	[D_Register setObject:[NSNumber numberWithInt:f_icode] forKey:@"icode"];
	[D_Register setObject:[NSNumber numberWithInt:f_ifun] forKey:@"ifun"];
	[D_Register setObject:[NSNumber numberWithInt:f_rA] forKey:@"rA"];
	[D_Register setObject:[NSNumber numberWithInt:f_rB] forKey:@"rB"];
	[D_Register setObject:[NSNumber numberWithInt:f_valC] forKey:@"valC"];
	[D_Register setObject:[NSNumber numberWithInt:f_valP] forKey:@"valP"];
}
@end










