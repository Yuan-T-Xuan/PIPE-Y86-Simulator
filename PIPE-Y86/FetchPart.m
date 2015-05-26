//
//  FetchPart.m
//  PIPE-Y86
//
//  Created by XuanYuan on 15/5/23.
//  Copyright (c) 2015年 XuanYuan. All rights reserved.
//

#import "FetchPart.h"

@implementation FetchPart
@synthesize iMemory;

- (void) InitInstructionMemory: (NSString *) FilePath {
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
		f_icode = [[Instruction substringToIndex:1] intValue];
		f_ifun = [[[Instruction substringFromIndex:1] substringToIndex:1] intValue];
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
			f_rA = [[[Instruction substringFromIndex:2]substringToIndex:1]intValue];
			f_rB = [[[Instruction substringFromIndex:3]substringToIndex:1]intValue];
		}
		//set valC
		if (f_icode == IIRMOVL || f_icode == IRMMOVL || f_icode == IMRMOVL)
			f_valC = [[Instruction substringFromIndex:4] intValue];
		if (f_icode == IJXX || f_icode == ICALL)
			f_valC = [[Instruction substringFromIndex:2] intValue];
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










