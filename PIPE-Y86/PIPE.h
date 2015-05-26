//
//  PIPE.h
//  PIPE-Y86
//
//  Created by XuanYuan on 15/5/26.
//  Copyright (c) 2015年 XuanYuan. All rights reserved.
//

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
@end

@implementation instruction
@synthesize addr;
@synthesize inst;
@end

@interface PIPE : NSObject
{
	//variables for pipe control logic
	int F_stall, D_stall, D_bubble, E_bubble, M_bubble, W_stall;
	//stored instruction list
	NSMutableArray* insList;	//array of instructions
	//five pipeline registers
	int F_predPC, F_prev_predPC;
	NSMutableDictionary* D_register;//also store _prev_ values
	NSMutableDictionary* E_register;//also store _prev_ values
	NSMutableDictionary* M_register;//also store _prev_ values
	NSMutableDictionary* W_register;//also store _prev_ values
	//dict for storing breakpoint
	NSMutableSet* breakpoints;	//storing NSNumber(int)
	//stop or not
	int switch_stop;
	//clock count
	int clock_count;
	//log (can be written to txt files)
	NSString* sys_log;
}
@property NSMutableArray* insList;
@property NSMutableSet* breakpoints;
@property int switch_stop;
@property (readonly) int F_predPC;
@property (readonly) NSMutableDictionary* D_register;
@property (readonly) NSMutableDictionary* E_register;
@property (readonly) NSMutableDictionary* M_register;
@property (readonly) NSMutableDictionary* W_register;
@property (readonly) NSString* sys_log;

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




