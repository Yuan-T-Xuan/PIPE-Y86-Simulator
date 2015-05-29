//
//  instruction.m
//  PIPE-Y86
//
//  Created by XuanYuan on 15/5/29.
//  Copyright (c) 2015年 XuanYuan. All rights reserved.
//

#import "instruction.h"

@implementation instruction
@synthesize addr;
@synthesize inst;
- (id) initAddress: (int) iaddr andInstruction: (NSString*) iinst {
	if (self = [super init]) {
		addr = iaddr;
		inst = iinst;
	}
	return self;
}
@end
