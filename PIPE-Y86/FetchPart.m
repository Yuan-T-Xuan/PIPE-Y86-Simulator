//
//  FetchPart.m
//  PIPE-Y86
//
//  Created by XuanYuan on 15/5/23.
//  Copyright (c) 2015年 XuanYuan. All rights reserved.
//

#import "FetchPart.h"

@implementation FetchPart
- (void) InitInstructionMemory: (NSString *) FilePath {
	
}

- (void) GetData: (int) iPredPC M_valA: (int) iM_valA
	  W_valM: (int) iW_valM M_Cnd: (int) iM_Cnd M_icode: (int) iM_icode
	   M_Bch: (int) iM_Bch W_icode: (int) iW_icode {
	self->PredPC = iPredPC;
	self->M_valA = iM_valA;
	self->W_valM = iW_valM;
	self->M_Cnd = iM_Cnd;
	self->M_icode = iM_icode;
	self->M_Bch = iM_Bch;
	self->W_icode = iW_icode;
}

- (void) Calculate {
	int f_pc;
	if(M_icode == IJXX && !M_Cnd)
		f_pc = M_valA;
	else if(W_icode == IRET)
		f_pc = W_valM;
	else
		f_pc = PredPC;
	//todo: get instruction ...
}

- (void) WriteData {	//not completed
	
}
@end










