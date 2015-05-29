//
//  DecodePart.h
//  PIPE-Y86
//
//  Created by XuanYuan on 15/5/25.
//  Copyright (c) 2015年 XuanYuan. All rights reserved.
//

#pragma once
#import <Foundation/Foundation.h>
#import "Constants.h"

@interface DecodePart : NSObject
{
	//for input
	int D_stat, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP;
	int e_dstE, e_valE, M_dstE, M_valE, M_dstM, m_valM;
	int W_dstM, W_valM, W_dstE, W_valE;
	//for output
	int d_stat, d_icode, d_ifun, d_valC, d_valA;
	int d_valB, d_dstE, d_dstM, d_srcA, d_srcB;
	//the Register File
	int RF[8];
	int* RegisterFile;
}
@property int d_srcA;
@property int d_srcB;
@property int* RegisterFile;
//have a default constructor for initiating the Register File
- (id) init;
- (void) GetData: (NSMutableDictionary *) D_Register
	  e_dstE: (int) ie_dstE e_valE: (int) ie_valE
	  M_dstE: (int) iM_dstE M_valE: (int) iM_valE
	  M_dstM: (int) iM_dstM m_valM: (int) im_valM
	  W_dstM: (int) iW_dstM W_valM: (int) iW_valM
	  W_dstE: (int) iW_dstE W_valE: (int) iW_valE;
- (void) Calculate;
- (void) WriteData: (NSMutableDictionary *) E_Register;
@end


