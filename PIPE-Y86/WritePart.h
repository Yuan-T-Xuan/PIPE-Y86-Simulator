//
//  WritePart.h
//  PIPE-Y86
//
//  Created by XuanYuan on 15/5/26.
//  Copyright (c) 2015年 XuanYuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface WritePart : NSObject
{
	//for writing back
	int W_valE, W_valM, W_dstE, W_dstM;
}
- (void) GetData: (NSMutableDictionary *) W_Register;
- (void) WriteData: (int *) RegisterFile;
//Register file is written as a part of decode unit.
@end


