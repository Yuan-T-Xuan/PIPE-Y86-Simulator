//
//  instruction.h
//  PIPE-Y86
//
//  Created by XuanYuan on 15/5/29.
//  Copyright (c) 2015年 XuanYuan. All rights reserved.
//

#pragma once
#import <Foundation/Foundation.h>

@interface instruction : NSObject
{
	int addr;
	NSString* inst;
}
@property int addr;
@property NSString* inst;
- (id) initAddress: (int) iaddr andInstruction: (NSString*) iinst;
@end
