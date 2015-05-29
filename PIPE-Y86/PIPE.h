//
//  PIPE.h
//  PIPE-Y86
//
//  Created by XuanYuan on 15/5/26.
//  Copyright (c) 2015年 XuanYuan. All rights reserved.
//

#pragma once
#import <Foundation/Foundation.h>
#import "FetchPart.h"
#import "DecodePart.h"
#import "ExecutePart.h"
#import "MemoryPart.h"
#import "WritePart.h"

@interface instruction : NSObject
{
	int addr;
	NSString* inst;
}
@property int addr;
@property NSString* inst;
- (id) initAddress: (int) iaddr andInstruction: (NSString*) iinst;
@end

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

@interface PIPE : NSObject
{
	//five main parts
	FetchPart* FetchUnit;
	DecodePart* DecodeUnit;
	ExecutePart* ExecuteUnit;
	MemoryPart* MemoryUnit;
	WritePart* WriteUnit;
	//variables for pipe control logic
	int F_stall, D_stall, D_bubble, E_bubble, M_bubble, W_stall;
	//stored instruction list
	NSMutableArray* insList;	//array of instructions
	//five pipeline registers
	int F_predPC;
	NSMutableDictionary* D_register;
	NSMutableDictionary* E_register;
	NSMutableDictionary* M_register;
	NSMutableDictionary* W_register;
	//dict for storing breakpoint
	NSMutableSet* breakpoints;	//storing NSNumber(int)
	//stop or not
	int switch_stop;
	//log
	//a mutable array which contains several NSMutableDictionary*s
	NSMutableArray* sys_log;
}
@property NSMutableArray* insList;
@property NSMutableSet* breakpoints;
@property int switch_stop;
@property (readonly) int F_predPC;
@property (readonly) NSMutableDictionary* D_register;
@property (readonly) NSMutableDictionary* E_register;
@property (readonly) NSMutableDictionary* M_register;
@property (readonly) NSMutableDictionary* W_register;
@property (readonly) NSMutableArray* sys_log;

- (id) init;
- (void) loadImage: (NSString*) ifilePath;
- (void) singleStepForward;
- (void) singleStepBackward;
- (void) setBreakpointAt: (int) iaddress;
- (void) removeBreakpointFrom: (int) iaddress;
- (void) runSlowly;
- (void) run;
- (void) Pause;
@end




