//
//  ExecutePart.m
//  PIPE-Y86
//
//  Created by XuanYuan on 15/5/26.
//  Copyright (c) 2015年 XuanYuan. All rights reserved.
//

#import "ExecutePart.h"

@implementation ExecutePart
@synthesize e_Cnd;
@synthesize e_valE;
@synthesize e_dstE;
@synthesize CC_ZF;
@synthesize CC_SF;

- (id) init {
	if (self = [super init]) {
		e_valE = 0;
		e_dstE = RNONE;
		CC_ZF = 0;
		CC_SF = 0;
	}
	return self;
}

- (void) GetData: (NSMutableDictionary *) E_Register
	  W_stat: (int) iW_stat m_stat: (int) im_stat {
	E_stat = [[E_Register objectForKey:@"stat"] intValue];
	E_icode = [[E_Register objectForKey:@"icode"] intValue];
	E_ifun = [[E_Register objectForKey:@"ifun"] intValue];
	E_valC = [[E_Register objectForKey:@"valC"] intValue];
	E_valA = [[E_Register objectForKey:@"valA"] intValue];
	E_valB = [[E_Register objectForKey:@"valB"] intValue];
	E_dstE = [[E_Register objectForKey:@"dstE"] intValue];
	E_dstM = [[E_Register objectForKey:@"dstM"] intValue];
	E_srcA = [[E_Register objectForKey:@"srcA"] intValue];
	E_srcB = [[E_Register objectForKey:@"srcB"] intValue];
	W_stat = iW_stat;
	m_stat = im_stat;
}

- (void) Calculate {
	//set aluA
	int aluA = 0;
	if(E_icode == IRRMOVL || E_icode == IOPL)
		aluA = E_valA;
	else if (E_icode == IIRMOVL || E_icode == IRMMOVL || E_icode == IMRMOVL)
		aluA = E_valC;
	else if (E_icode == ICALL || E_icode == IPUSHL)
		aluA = -4;
	else if (E_icode == IRET || E_icode == IPOPL)
		aluA = 4;
	//set aluB
	int aluB = 0;
	if (E_icode == IRMMOVL || E_icode == IMRMOVL || E_icode == IOPL || E_icode == ICALL || E_icode == IPUSHL || E_icode == IRET || E_icode == IPOPL)
		aluB = E_valB;
	else if (E_icode == IRRMOVL || E_icode == IIRMOVL)
		aluB = 0;
	//set alu function
	int alufun = ALUADD;
	if (E_icode == IOPL)
		alufun = E_ifun;
	//calculate set_cc
	int set_cc = 0;
	if (E_icode==IOPL && m_stat == SAOK && W_stat == SAOK)
		set_cc = 1;
	//calculate with "alu" (set e_valE)
	if (alufun == ALUADD)
		e_valE = aluB + aluA;
	else if (alufun == ALUSUB)
		e_valE = aluB - aluA;
	else if (alufun == ALUAND)
		e_valE = aluB & aluA;
	else if (alufun == ALUXOR)
		e_valE = aluB ^ aluA;
	//set CC if possible
	if (set_cc) {
		if (e_valE == 0)
			CC_ZF = 1;
		else
			CC_ZF = 0;
		CC_SF = (e_valE >> 31) & 0x1;
	}
	//set Condition
	e_Cnd = 0;
	if (E_ifun == CA)
		e_Cnd = 1;
	else if (E_ifun == CLE)
		e_Cnd = CC_SF || CC_ZF;
	else if (E_ifun == CL)
		e_Cnd = CC_SF;
	else if (E_ifun == CE)
		e_Cnd = CC_ZF;
	else if (E_ifun == CNE)
		e_Cnd = !CC_ZF;
	else if (E_ifun == CGE)
		e_Cnd = !CC_SF;
	else if (E_ifun == CG)
		e_Cnd = !CC_SF && !CC_ZF;
	//set dstE
	if (E_icode == IRRMOVL && !e_Cnd)
		e_dstE = RNONE;
	else
		e_dstE = E_dstE;
	//set other values
	e_stat = E_stat;
	e_icode = E_icode;
	e_valA = E_valA;
	e_dstM = E_dstM;
}

- (void) WriteData: (NSMutableDictionary *) M_Register {
	[M_Register setObject:[NSNumber numberWithInt:e_stat] forKey:@"stat"];
	[M_Register setObject:[NSNumber numberWithInt:e_icode] forKey:@"icode"];
	[M_Register setObject:[NSNumber numberWithInt:e_Cnd] forKey:@"Cnd"];
	[M_Register setObject:[NSNumber numberWithInt:e_valE] forKey:@"valE"];
	[M_Register setObject:[NSNumber numberWithInt:e_valA] forKey:@"valA"];
	[M_Register setObject:[NSNumber numberWithInt:e_dstM] forKey:@"dstM"];
	[M_Register setObject:[NSNumber numberWithInt:e_dstE] forKey:@"dstE"];
}
@end









