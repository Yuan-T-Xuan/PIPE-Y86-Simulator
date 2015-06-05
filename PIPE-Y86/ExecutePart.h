//
//  ExecutePart.h
//  PIPE-Y86
//
//  Created by XuanYuan on 15/5/26.
//  Copyright (c) 2015年 XuanYuan. All rights reserved.
//

#pragma once
#import <Foundation/Foundation.h>
#import "Constants.h"

@interface ExecutePart : NSObject
{
	//for input
	int E_stat, E_icode, E_ifun, E_valC, E_valA, E_valB, E_dstE;
	int E_dstM, E_srcA, E_srcB, W_stat, m_stat;
	//for output
	int e_stat, e_icode, e_Cnd, e_valE, e_valA, e_dstM, e_dstE;
	//stored CC
	int CC_ZF, CC_SF, CC_OF;
}
@property (readonly) int e_Cnd;
@property (readonly) int e_valE;
@property (readonly) int e_dstE;
@property int CC_ZF;
@property int CC_SF;
@property int CC_OF;
- (id) init;
- (void) GetData: (NSMutableDictionary *) E_Register
	  W_stat: (int) iW_stat m_stat: (int) im_stat;
- (void) Calculate;
- (void) WriteData: (NSMutableDictionary *) M_Register;
@end


