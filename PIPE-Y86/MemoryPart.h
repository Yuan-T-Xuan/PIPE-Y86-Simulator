//
//  MemoryPart.h
//  PIPE-Y86
//
//  Created by XuanYuan on 15/5/25.
//  Copyright (c) 2015年 XuanYuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
 
@interface MemoryPart : NSObject
{
	//for input
	int M_stat, M_icode, M_Cnd, M_valE;
	int M_valA, M_dstE, M_dstM;
	//for output
	int m_stat, m_icode, m_valE, m_valM, m_dstE, m_dstM;
	//the data memory
	NSMutableDictionary *dMemory;	//key: NSNumBer(int) value: NSNumBer(int)
	//actually it will share the same memory space with iMemory
}
@property (readonly) int m_valM;
@property NSMutableDictionary* dMemory;
- (id) initWithMemory: (NSMutableDictionary*) Memory;
- (void) GetData: (NSMutableDictionary *) M_Register;
- (void) Calculate;
- (void) WriteData: (NSMutableDictionary *) W_Register;
@end


