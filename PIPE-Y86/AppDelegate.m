//
//  AppDelegate.m
//  PIPE-Y86
//
//  Created by XuanYuan on 15/5/23.
//  Copyright (c) 2015年 XuanYuan. All rights reserved.
//

#import "AppDelegate.h"

static NSString* int2hex_str(int innum) {
	if (innum == 0)
		return @"0x0";
	char hex_num[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
	unsigned num = innum;
	NSMutableString* inverse = [NSMutableString stringWithString:@""];
	while (num > 0) {
		[inverse appendFormat:@"%c", hex_num[num % 16]];
		num = num / 16;
	}
	NSMutableString* return_result = [NSMutableString stringWithString:@"0x"];
	for (int i = 0; i < [inverse length]; i++) {
		[return_result appendFormat:@"%c", [inverse characterAtIndex:([inverse length]-i-1)]];
	}
	return return_result;
}

static int str2int(NSString* instr) {
	int result = 0, length = 0;
	length = (int)[instr length];
	int i;
	for (i = 0; i < length; i++) {
		if ([instr characterAtIndex:i] >= '0' && [instr characterAtIndex:i] <= '9')
			result = result * 16 + [instr characterAtIndex:i] - '0';
		else if ([instr characterAtIndex:i] >= 'A' && [instr characterAtIndex:i] <= 'F')
			result = result * 16 + [instr characterAtIndex:i] + 10 - 'A';
		else
			result = result * 16 + [instr characterAtIndex:i] + 10 - 'a';
	}
	return result;
}

static NSString* int2stat(int input) {
	if (input == 1)
		return @"saok";
	else if (input == 2)
		return @"sadr";
	else if (input == 3)
		return @"sins";
	else
		return @"shlt";
}

static NSString* int2reg(int input) {
	switch (input) {
		case 0:
			return @"eax";
		case 1:
			return @"ecx";
		case 2:
			return @"edx";
		case 3:
			return @"ebx";
		case 4:
			return @"esp";
		case 5:
			return @"ebp";
		case 6:
			return @"esi";
		case 7:
			return @"edi";
		default:
			return @"none";
	}
}

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate
@synthesize core;
@synthesize file_path;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	file_path = _path;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

- (void)refreshGUI {
	//refresh pipeline registers
	[self.GUI_F_predPC setStringValue: int2hex_str(core.F_predPC)];
	[self.GUI_D_stat setStringValue: int2stat([[core.D_register objectForKey:@"stat"] intValue])];
	[self.GUI_D_icode setIntValue: [[core.D_register objectForKey:@"icode"] intValue]];
	[self.GUI_D_ifun setIntValue: [[core.D_register objectForKey:@"ifun"] intValue]];
	[self.GUI_D_rA setStringValue: int2reg([[core.D_register objectForKey:@"rA"] intValue])];
	[self.GUI_D_rB setStringValue: int2reg([[core.D_register objectForKey:@"rB"] intValue])];
	[self.GUI_D_valC setStringValue: int2hex_str([[core.D_register objectForKey:@"valC"] intValue])];
	[self.GUI_D_valP setStringValue: int2hex_str([[core.D_register objectForKey:@"valP"] intValue])];
	[self.GUI_E_stat setStringValue: int2stat([[core.E_register objectForKey:@"stat"] intValue])];
	[self.GUI_E_icode setIntValue: [[core.E_register objectForKey:@"icode"] intValue]];
	[self.GUI_E_ifun setIntValue: [[core.E_register objectForKey:@"ifun"] intValue]];
	[self.GUI_E_valC setStringValue: int2hex_str([[core.E_register objectForKey:@"valC"] intValue])];
	[self.GUI_E_valA setStringValue: int2hex_str([[core.E_register objectForKey:@"valA"] intValue])];
	[self.GUI_E_valB setStringValue: int2hex_str([[core.E_register objectForKey:@"valB"] intValue])];
	[self.GUI_E_dstE setStringValue: int2reg([[core.E_register objectForKey:@"dstE"] intValue])];
	[self.GUI_E_dstM setStringValue: int2reg([[core.E_register objectForKey:@"dstM"] intValue])];
	[self.GUI_E_srcA setStringValue: int2reg([[core.E_register objectForKey:@"srcA"] intValue])];
	[self.GUI_E_srcB setStringValue: int2reg([[core.E_register objectForKey:@"srcB"] intValue])];
	[self.GUI_M_stat setStringValue: int2stat([[core.M_register objectForKey:@"stat"] intValue])];
	[self.GUI_M_icode setIntValue: [[core.M_register objectForKey:@"icode"] intValue]];
	[self.GUI_M_Cnd setIntValue: [[core.M_register objectForKey:@"Cnd"] intValue]];
	[self.GUI_M_valE setStringValue: int2hex_str([[core.M_register objectForKey:@"valE"] intValue])];
	[self.GUI_M_valA setStringValue: int2hex_str([[core.M_register objectForKey:@"valA"] intValue])];
	[self.GUI_M_dstE setStringValue: int2reg([[core.M_register objectForKey:@"dstE"] intValue])];
	[self.GUI_M_dstM setStringValue: int2reg([[core.M_register objectForKey:@"dstM"] intValue])];
	[self.GUI_W_stat setStringValue: int2stat([[core.W_register objectForKey:@"stat"] intValue])];
	[self.GUI_W_icode setIntValue: [[core.W_register objectForKey:@"icode"] intValue]];
	[self.GUI_W_valE setStringValue: int2hex_str([[core.W_register objectForKey:@"valE"] intValue])];
	[self.GUI_W_valM setStringValue: int2hex_str([[core.W_register objectForKey:@"valM"] intValue])];
	[self.GUI_W_dstE setStringValue: int2reg([[core.W_register objectForKey:@"dstE"] intValue])];
	[self.GUI_W_dstM setStringValue: int2reg([[core.W_register objectForKey:@"dstM"] intValue])];
	//refresh register file
	[self.GUI_eax setStringValue:int2hex_str(core.DecodeUnit.RegisterFile[REAX])];
	[self.GUI_ecx setStringValue:int2hex_str(core.DecodeUnit.RegisterFile[RECX])];
	[self.GUI_edx setStringValue:int2hex_str(core.DecodeUnit.RegisterFile[REDX])];
	[self.GUI_ebx setStringValue:int2hex_str(core.DecodeUnit.RegisterFile[REBX])];
	[self.GUI_esi setStringValue:int2hex_str(core.DecodeUnit.RegisterFile[RESI])];
	[self.GUI_edi setStringValue:int2hex_str(core.DecodeUnit.RegisterFile[REDI])];
	[self.GUI_esp setStringValue:int2hex_str(core.DecodeUnit.RegisterFile[RESP])];
	[self.GUI_ebp setStringValue:int2hex_str(core.DecodeUnit.RegisterFile[REBP])];
	//refresh condition codes
	[self.GUI_ZF setIntValue: core.ExecuteUnit.CC_ZF];
	[self.GUI_SF setIntValue: core.ExecuteUnit.CC_SF];
	[self.GUI_OF setIntValue: core.ExecuteUnit.CC_OF];
	//refresh control logic
	[self.GUI_F_bubble setIntValue:0];
	[self.GUI_F_stall setIntValue: core.F_stall];
	[self.GUI_D_stall setIntValue: core.D_stall];
	[self.GUI_D_bubble setIntValue: core.D_bubble];
	[self.GUI_E_bubble setIntValue: core.E_bubble];
	[self.GUI_E_stall setIntValue:0];
	[self.GUI_M_bubble setIntValue: core.M_bubble];
	[self.GUI_M_stall setIntValue:0];
	//refresh clock cycle
	[self.GUI_ClockCycle setIntValue: (int)[core.sys_log count]];
	@try {
	[self.GUI_FetchedInst setStringValue:[core.FetchUnit.iMemory objectForKey:[NSNumber numberWithInt:core.FetchUnit.f_pc]]];
	}
	@catch (NSException *exception) {
	[self.GUI_FetchedInst setStringValue:@"00"];
	}
	//refresh observed memory
	//not finished yet
}

- (IBAction)pushLoad:(id)sender {
	NSLog(@"Load Button Clicked");
	//initialize and configure the open panel
	NSOpenPanel* openPanel = [NSOpenPanel openPanel];
	[openPanel setCanChooseFiles: YES];
	[openPanel setCanChooseDirectories:NO];
	[openPanel setAllowsMultipleSelection:NO];
	long isOK = [openPanel runModal];
	if (isOK != NSFileHandlingPanelOKButton) {
		NSLog(@"no file selected");
		return;
	}
	const char* path = [[openPanel URL] fileSystemRepresentation];
	printf("%s\n", path);
	strcpy(file_path, path);
	//get a new core
	core = [PIPE new];
	//load selected image
	NSString* returned_inst = [core loadImage: (char *)path];
	//refresh GUI
	[self refreshGUI];
	[self.GUI_FetchedInst setStringValue:@""];
	[self.GUI_inst setString:returned_inst];
	//enable buttons
	[self.BTN_Step setEnabled:YES];
	[self.BTN_Back setEnabled:YES];
	[self.BTN_FullSpeed setEnabled:YES];
	[self.BTN_Slowly setEnabled:YES];
	[self.BTN_Pause setEnabled:YES];
	[self.BTN_Reset setEnabled:YES];
	[self.BTN_Set setEnabled:YES];
	[self.BTN_Remove setEnabled:YES];
	[self.BTN_SystemLog setEnabled:YES];
	[self.BTN_Observe setEnabled:YES];
}

- (IBAction)pushStep:(id)sender {
	//if halted, no step forward
	if ([[core.W_register objectForKey:@"stat"] intValue] != SAOK)
		return;
	//otherwise
	[core singleStepForward];
	[self refreshGUI];
}

- (IBAction)pushBack:(id)sender {
	[core singleStepBackward];
	[self refreshGUI];
	[self.GUI_FetchedInst setStringValue:@""];
}

- (IBAction)pushFullSpeed:(id)sender {
	while ([[core.W_register objectForKey:@"stat"] intValue] == SAOK) {
		//if switch_stop is true
		if (core.switch_stop != 0) {
			core.switch_stop = 0;
			return;
		}
		//if there's a breakpoint
		if ([core.breakpoints containsObject: [NSNumber numberWithInt:core.FetchUnit.f_pc]]) {
			NSLog(@"A breakpoint detected.");
			return;
		}
		//else, run normally
		[core singleStepForward];
		[self refreshGUI];
	}
}

- (void)Slowly_background {
	while ([[core.W_register objectForKey:@"stat"] intValue] == SAOK) {
		//if switch_stop is true
		if (core.switch_stop != 0) {
			core.switch_stop = 0;
			[self.BTN_Slowly setEnabled:YES];
			return;
		}
		//if there's a breakpoint
		if ([core.breakpoints containsObject: [NSNumber numberWithInt:core.FetchUnit.f_pc]]) {
			NSLog(@"A breakpoint detected.");
			[self.BTN_Slowly setEnabled:YES];
			return;
		}
		//else, run normally
		[core singleStepForward];
		[self refreshGUI];
		sleep(1);
	}
	[self.BTN_Slowly setEnabled:YES];
}

- (IBAction)pushSlowly:(id)sender {
	[self performSelectorInBackground:@selector(Slowly_background) withObject:nil];
	[self.BTN_Slowly setEnabled:NO];
}

- (IBAction)pushPause:(id)sender {
	[core Pause];
}

- (IBAction)pushReset:(id)sender {
	core = [PIPE new];
	//load selected image
	NSString* returned_inst = [core loadImage: file_path];
	//refresh GUI
	[self refreshGUI];
	[self.GUI_FetchedInst setStringValue:@""];
	[self.GUI_inst setString:returned_inst];
}

- (IBAction)pushSet:(id)sender {
	NSString* returned_address = [self.GUI_breakpoint stringValue];
	[core setBreakpointAt:str2int([returned_address substringFromIndex:2])];
	//change "Breakpoints at: (none)"
	NSMutableString* breakpoints = [NSMutableString stringWithString:@"Breakpoints at: "];
	if ([core.breakpoints count] == 0)
		[breakpoints appendString:@"(none)"];
	else {
		NSNumber* bp = nil;
		NSEnumerator *enumerator = [core.breakpoints objectEnumerator];
		while (bp = [enumerator nextObject]) {
			[breakpoints appendString:int2hex_str([bp intValue])];
			[breakpoints appendString:@", "];
		}
		breakpoints = [NSMutableString stringWithString:[breakpoints substringToIndex:[breakpoints length]-2]];
	}
	[self.GUI_show_breakpoints setStringValue:breakpoints];
}

- (IBAction)pushRemove:(id)sender {
	NSString* returned_address = [self.GUI_breakpoint stringValue];
	[core removeBreakpointFrom:str2int([returned_address substringFromIndex:2])];
	//change "Breakpoints at: (none)"
	NSMutableString* breakpoints = [NSMutableString stringWithString:@"Breakpoints at: "];
	if ([core.breakpoints count] == 0)
		[breakpoints appendString:@"(none)"];
	else {
		NSNumber* bp = nil;
		NSEnumerator *enumerator = [core.breakpoints objectEnumerator];
		while (bp = [enumerator nextObject]) {
			[breakpoints appendString:int2hex_str([bp intValue])];
			[breakpoints appendString:@", "];
		}
		breakpoints = [NSMutableString stringWithString:[breakpoints substringToIndex:[breakpoints length]-2]];
	}
	[self.GUI_show_breakpoints setStringValue:breakpoints];
}

- (IBAction)pushSysLog:(id)sender {
	NSSavePanel* savePanel = [NSSavePanel savePanel];
	long isOK = [savePanel runModal];
	if (isOK != NSFileHandlingPanelOKButton)
		return;
	const char* path = [[savePanel URL] fileSystemRepresentation];
	printf("saving to: %s\n", path);
	NSMutableString* to_write = [NSMutableString stringWithString:@""];
	[to_write appendString:@"Cycle_"];
	[to_write appendFormat:@"%d\n", 0];
	[to_write appendString:@"--------------------\n"];
	[to_write appendString:@"FETCH:\n"];
	[to_write appendString:@"\tF_predPC \t= "];
	[to_write appendString:int2hex_str(0)];
	[to_write appendString:@"\n\nDECODE:\n"];
	[to_write appendString:@"\tD_icode \t= "];
	[to_write appendString:int2hex_str(INOP)];
	[to_write appendString:@"\n\tD_ifun   \t= "];
	[to_write appendString:int2hex_str(CA)];
	[to_write appendString:@"\n\tD_rA     \t= "];
	[to_write appendString:int2hex_str(RNONE)];
	[to_write appendString:@"\n\tD_rB     \t= "];
	[to_write appendString:int2hex_str(RNONE)];
	[to_write appendString:@"\n\tD_valC   \t= "];
	[to_write appendString:int2hex_str(0)];
	[to_write appendString:@"\n\tD_valP   \t= "];
	[to_write appendString:int2hex_str(0)];
	[to_write appendString:@"\n\nEXECUTE:\n"];
	[to_write appendString:@"\tE_icode \t= "];
	[to_write appendString:int2hex_str(INOP)];
	[to_write appendString:@"\n\tE_ifun   \t= "];
	[to_write appendString:int2hex_str(CA)];
	[to_write appendString:@"\n\tE_valC   \t= "];
	[to_write appendString:int2hex_str(0)];
	[to_write appendString:@"\n\tE_valA   \t= "];
	[to_write appendString:int2hex_str(0)];
	[to_write appendString:@"\n\tE_valB   \t= "];
	[to_write appendString:int2hex_str(0)];
	[to_write appendString:@"\n\tE_dstE   \t= "];
	[to_write appendString:int2hex_str(RNONE)];
	[to_write appendString:@"\n\tE_dstM   \t= "];
	[to_write appendString:int2hex_str(RNONE)];
	[to_write appendString:@"\n\tE_srcA   \t= "];
	[to_write appendString:int2hex_str(REAX)];
	[to_write appendString:@"\n\tE_srcB   \t= "];
	[to_write appendString:int2hex_str(REAX)];
	[to_write appendString:@"\n\nMEMORY:\n"];
	[to_write appendString:@"\tM_icode \t= "];
	[to_write appendString:int2hex_str(INOP)];
	[to_write appendString:@"\n\tM_Cnd   \t= "];
	[to_write appendString:@"false"];
	[to_write appendString:@"\n\tM_valE   \t= "];
	[to_write appendString:int2hex_str(0)];
	[to_write appendString:@"\n\tM_valA   \t= "];
	[to_write appendString:int2hex_str(0)];
	[to_write appendString:@"\n\tM_dstE   \t= "];
	[to_write appendString:int2hex_str(0)];
	[to_write appendString:@"\n\tM_dstM   \t= "];
	[to_write appendString:int2hex_str(0)];
	[to_write appendString:@"\n\nWRITE BACK:\n"];
	[to_write appendString:@"\tW_icode \t= "];
	[to_write appendString:int2hex_str(INOP)];
	[to_write appendString:@"\n\tW_valE   \t= "];
	[to_write appendString:int2hex_str(0)];
	[to_write appendString:@"\n\tW_valM   \t= "];
	[to_write appendString:int2hex_str(0)];
	[to_write appendString:@"\n\tW_dstE   \t= "];
	[to_write appendString:int2hex_str(RNONE)];
	[to_write appendString:@"\n\tW_dstM   \t= "];
	[to_write appendString:int2hex_str(RNONE)];
	[to_write appendString:@"\n\n"];
	int count = (int)[core.sys_log count];
	int i = 0;
	for (i = 0; i < count; i++) {
		[to_write appendString:@"Cycle_"];
		[to_write appendFormat:@"%d\n", i+1];
		[to_write appendString:@"--------------------\n"];
		[to_write appendString:@"FETCH:\n"];
		[to_write appendString:@"\tF_predPC \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"F_predPC"]intValue])];
		[to_write appendString:@"\n\nDECODE:\n"];
		[to_write appendString:@"\tD_icode \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"D_icode"]intValue])];
		[to_write appendString:@"\n\tD_ifun   \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"D_ifun"]intValue])];
		[to_write appendString:@"\n\tD_rA     \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"D_rA"]intValue])];
		[to_write appendString:@"\n\tD_rB     \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"D_rB"]intValue])];
		[to_write appendString:@"\n\tD_valC   \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"D_valC"]intValue])];
		[to_write appendString:@"\n\tD_valP   \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"D_valP"]intValue])];
		[to_write appendString:@"\n\nEXECUTE:\n"];
		[to_write appendString:@"\tE_icode \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"E_icode"]intValue])];
		[to_write appendString:@"\n\tE_ifun   \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"E_ifun"]intValue])];
		[to_write appendString:@"\n\tE_valC   \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"E_valC"]intValue])];
		[to_write appendString:@"\n\tE_valA   \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"E_valA"]intValue])];
		[to_write appendString:@"\n\tE_valB   \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"E_valB"]intValue])];
		[to_write appendString:@"\n\tE_dstE   \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"E_dstE"]intValue])];
		[to_write appendString:@"\n\tE_dstM   \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"E_dstM"]intValue])];
		[to_write appendString:@"\n\tE_srcA   \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"E_srcA"]intValue])];
		[to_write appendString:@"\n\tE_srcB   \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"E_srcB"]intValue])];
		[to_write appendString:@"\n\nMEMORY:\n"];
		[to_write appendString:@"\tM_icode \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"M_icode"]intValue])];
		[to_write appendString:@"\n\tM_Cnd   \t= "];
		[to_write appendString:[[[core.sys_log objectAtIndex:i]objectForKey:@"M_Cnd"]intValue]==0?@"false":@"true"];
		[to_write appendString:@"\n\tM_valE   \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"M_valE"]intValue])];
		[to_write appendString:@"\n\tM_valA   \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"M_valA"]intValue])];
		[to_write appendString:@"\n\tM_dstE   \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"M_dstE"]intValue])];
		[to_write appendString:@"\n\tM_dstM   \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"M_dstM"]intValue])];
		[to_write appendString:@"\n\nWRITE BACK:\n"];
		[to_write appendString:@"\tW_icode \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"W_icode"]intValue])];
		[to_write appendString:@"\n\tW_valE   \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"W_valE"]intValue])];
		[to_write appendString:@"\n\tW_valM   \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"W_valM"]intValue])];
		[to_write appendString:@"\n\tW_dstE   \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"W_dstE"]intValue])];
		[to_write appendString:@"\n\tW_dstM   \t= "];
		[to_write appendString:int2hex_str([[[core.sys_log objectAtIndex:i]objectForKey:@"W_dstM"]intValue])];
		[to_write appendString:@"\n\n"];
	}
	[to_write writeToFile:[NSString stringWithCString:path encoding:NSASCIIStringEncoding]
		   atomically:NO
		     encoding:NSASCIIStringEncoding
			error:nil];
}

- (IBAction)pushObserve:(id)sender {
	NSString* returned_address = [self.GUI_address stringValue];
	id got_data = nil;
	if ([returned_address length] <= 2)
		got_data = [core.MemoryUnit.dMemory objectForKey:[NSNumber numberWithInt:[self.GUI_address intValue]]];
	else if ([[returned_address substringToIndex:2] isEqual: @"0x"])
		got_data = [core.MemoryUnit.dMemory objectForKey:[NSNumber numberWithInt:str2int([returned_address substringFromIndex:2])]];
	else
		got_data = [core.MemoryUnit.dMemory objectForKey:[NSNumber numberWithInt:[self.GUI_address intValue]]];
	if ([got_data isKindOfClass: [NSString class]])
		[self.GUI_data setStringValue:(NSString*)got_data];
	else
		[self.GUI_data setStringValue:int2hex_str([got_data intValue])];
}
@end










