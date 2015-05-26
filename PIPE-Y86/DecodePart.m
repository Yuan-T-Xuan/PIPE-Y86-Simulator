//
//  DecodePart.m
//  PIPE-Y86
//
//  Created by XuanYuan on 15/5/25.
//  Copyright (c) 2015年 XuanYuan. All rights reserved.
//

#import "DecodePart.h"

@implementation DecodePart
@synthesize d_srcA;
@synthesize d_srcB;
@synthesize RegisterFile;

- (id) init {
	if (self = [super init]) {
		RegisterFile = RF;
		int i;
		for (i = 0; i < 8; i++) {
			RegisterFile[i] = 0;
		}
	}
	return self;
}

- (void) GetData: (NSMutableDictionary *) D_Register
	  e_dstE: (int) ie_dstE e_valE: (int) ie_valE
	  M_dstE: (int) iM_dstE M_valE: (int) iM_valE
	  M_dstM: (int) iM_dstM m_valM: (int) im_valM
	  W_dstM: (int) iW_dstM W_valM: (int) iW_valM
	  W_dstE: (int) iW_dstE W_valE: (int) iW_valE {
	D_stat = [[D_Register objectForKey:@"stat"] intValue];
	D_icode = [[D_Register objectForKey:@"icode"] intValue];
	D_ifun = [[D_Register objectForKey:@"ifun"] intValue];
	D_rA = [[D_Register objectForKey:@"rA"] intValue];
	D_rB = [[D_Register objectForKey:@"rB"] intValue];
	D_valC = [[D_Register objectForKey:@"valC"] intValue];
	D_valP = [[D_Register objectForKey:@"valP"] intValue];
	e_dstE = ie_dstE;
	e_valE = ie_valE;
	M_dstE = iM_dstE;
	M_valE = iM_valE;
	M_dstM = iM_dstM;
	m_valM = im_valM;
	W_dstM = iW_dstM;
	W_valM = iW_valM;
	W_dstE = iW_dstE;
	W_valE = iW_valE;
}

- (void) Calculate {
	//set d_srcA
	if (D_icode == IRRMOVL || D_icode == IRMMOVL || D_icode == IOPL || D_icode == IPUSHL)
		d_srcA = D_rA;
	else if (D_icode == IPOPL || D_icode == IRET)
		d_srcA = RESP;
	else
		d_srcA = RNONE;
	//set d_srcB
	if (D_icode == IMRMOVL || D_icode == IRMMOVL || D_icode == IOPL)
		d_srcB = D_rB;
	else if (D_icode == IPUSHL || D_icode == IPOPL || D_icode == ICALL || D_icode == IRET)
		d_srcB = RESP;
	else
		d_srcB = RNONE;
	//set d_dstE
	if (D_icode == IRRMOVL || D_icode == IIRMOVL || D_icode == IOPL)
		d_dstE = D_rB;
	else if (D_icode == IPUSHL || D_icode == IPOPL || D_icode == ICALL || D_icode == IRET)
		d_dstE = RESP;
	else
		d_dstE = RNONE;
	//set d_dstM
	if (D_icode == IMRMOVL || D_icode == IPOPL)
		d_dstM = D_rA;
	else
		d_dstM = RNONE;
	//get A&B from Register File
	int d_rvalA = 0, d_rvalB = 0;
	if (d_srcA != RNONE)
		d_rvalA = RegisterFile[d_srcA];
	if (d_srcB != RNONE)
		d_rvalB = RegisterFile[d_srcB];
	//set d_valA
	if (D_icode == ICALL || D_icode == IJXX)
		d_valA = D_valP;
	else if (d_srcA == e_dstE)
		d_valA = e_valE;
	else if (d_srcA == M_dstM)
		d_valA = m_valM;
	else if (d_srcA == M_dstE)
		d_valA = M_valE;
	else if (d_srcA == W_dstM)
		d_valA = W_valM;
	else if (d_srcA == W_dstE)
		d_valA = W_valE;
	else
		d_valA = d_rvalA;
	//set d_valB
	if (d_srcB == e_dstE)
		d_valB = e_valE;
	else if(d_srcB == M_dstM)
		d_valB = m_valM;
	else if(d_srcB == M_dstE)
		d_valB = M_valE;
	else if(d_srcB == W_dstM)
		d_valB = W_valM;
	else if(d_srcB == W_dstE)
		d_valB = W_valE;
	else
		d_valB = d_rvalB;
	//set other pipeline registers
	d_stat = D_stat;
	d_icode = D_icode;
	d_ifun = D_ifun;
	d_valC = D_valC;
}

- (void) WriteData: (NSMutableDictionary *) E_Register {
	[E_Register setObject:[NSNumber numberWithInt:d_stat] forKey:@"stat"];
	[E_Register setObject:[NSNumber numberWithInt:d_icode] forKey:@"icode"];
	[E_Register setObject:[NSNumber numberWithInt:d_ifun] forKey:@"ifun"];
	[E_Register setObject:[NSNumber numberWithInt:d_valC] forKey:@"valC"];
	[E_Register setObject:[NSNumber numberWithInt:d_valA] forKey:@"valA"];
	[E_Register setObject:[NSNumber numberWithInt:d_valB] forKey:@"valB"];
	[E_Register setObject:[NSNumber numberWithInt:d_dstE] forKey:@"dstE"];
	[E_Register setObject:[NSNumber numberWithInt:d_dstM] forKey:@"dstM"];
	[E_Register setObject:[NSNumber numberWithInt:d_srcA] forKey:@"srcA"];
	[E_Register setObject:[NSNumber numberWithInt:d_srcB] forKey:@"srcB"];
}
@end












