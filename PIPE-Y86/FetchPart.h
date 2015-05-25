//
//  FetchPart.h
//  PIPE-Y86
//
//  Created by XuanYuan on 15/5/23.
//  Copyright (c) 2015年 XuanYuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface FetchPart : NSObject
{
	//for input
	int PredPC, M_valA, W_valM, M_Cnd;
	int M_icode, W_icode;
	//for output
	int f_stat, f_icode, f_ifun, f_rA, f_rB;
	int f_valC, f_valP;
	//the inst memory
	NSMutableDictionary *iMemory;	//key: NSNumBer(int) value: NSString
}
- (void) InitInstructionMemory: (NSString *) FilePath;
- (void) GetData: (int) iPredPC M_valA: (int) iM_valA
	  W_valM: (int) iW_valM M_Cnd: (int) iM_Cnd M_icode: (int) iM_icode
	   W_icode: (int) iW_icode;
- (void) Calculate;
- (void) WriteData: (NSMutableDictionary *) D_Register;
@end
