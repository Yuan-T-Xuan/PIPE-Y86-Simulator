//
//  AppDelegate.m
//  PIPE-Y86
//
//  Created by XuanYuan on 15/5/23.
//  Copyright (c) 2015年 XuanYuan. All rights reserved.
//

#import "AppDelegate.h"

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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	core = [PIPE new];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

- (void)refreshGUI {
	//refresh pipeline registers
	[self.GUI_F_predPC setIntValue: core.F_predPC];
	[self.GUI_D_stat setStringValue: int2stat([[core.D_register objectForKey:@"stat"] intValue])];
	[self.GUI_D_icode setIntValue: [[core.D_register objectForKey:@"icode"] intValue]];
	[self.GUI_D_ifun setIntValue: [[core.D_register objectForKey:@"ifun"] intValue]];
	[self.GUI_D_rA setStringValue: int2reg([[core.D_register objectForKey:@"rA"] intValue])];
	[self.GUI_D_rB setStringValue: int2reg([[core.D_register objectForKey:@"rB"] intValue])];
	[self.GUI_D_valC setIntValue: [[core.D_register objectForKey:@"valC"] intValue]];
	[self.GUI_D_valP setIntValue: [[core.D_register objectForKey:@"valP"] intValue]];
	[self.GUI_E_stat setStringValue: int2stat([[core.E_register objectForKey:@"stat"] intValue])];
	[self.GUI_E_icode setIntValue: [[core.E_register objectForKey:@"icode"] intValue]];
	[self.GUI_E_ifun setIntValue: [[core.E_register objectForKey:@"ifun"] intValue]];
	[self.GUI_E_valC setIntValue: [[core.E_register objectForKey:@"valC"] intValue]];
	[self.GUI_E_valA setIntValue: [[core.E_register objectForKey:@"valA"] intValue]];
	[self.GUI_E_valB setIntValue: [[core.E_register objectForKey:@"valB"] intValue]];
	[self.GUI_E_dstE setStringValue: int2reg([[core.E_register objectForKey:@"dstE"] intValue])];
	[self.GUI_E_dstM setStringValue: int2reg([[core.E_register objectForKey:@"dstM"] intValue])];
	[self.GUI_E_srcA setStringValue: int2reg([[core.E_register objectForKey:@"srcA"] intValue])];
	[self.GUI_E_srcB setStringValue: int2reg([[core.E_register objectForKey:@"srcB"] intValue])];
	[self.GUI_M_stat setStringValue: int2stat([[core.M_register objectForKey:@"stat"] intValue])];
	[self.GUI_M_icode setIntValue: [[core.M_register objectForKey:@"icode"] intValue]];
	[self.GUI_M_Cnd setIntValue: [[core.M_register objectForKey:@"Cnd"] intValue]];
	[self.GUI_M_valE setIntValue: [[core.M_register objectForKey:@"valE"] intValue]];
	[self.GUI_M_valA setIntValue: [[core.M_register objectForKey:@"valA"] intValue]];
	[self.GUI_M_dstE setStringValue: int2reg([[core.M_register objectForKey:@"dstE"] intValue])];
	[self.GUI_M_dstM setStringValue: int2reg([[core.M_register objectForKey:@"dstM"] intValue])];
	[self.GUI_W_stat setStringValue: int2stat([[core.W_register objectForKey:@"stat"] intValue])];
	[self.GUI_W_icode setIntValue: [[core.W_register objectForKey:@"icode"] intValue]];
	[self.GUI_W_valE setIntValue: [[core.W_register objectForKey:@"valE"] intValue]];
	[self.GUI_W_valM setIntValue: [[core.W_register objectForKey:@"valM"] intValue]];
	[self.GUI_W_dstE setStringValue: int2reg([[core.W_register objectForKey:@"dstE"] intValue])];
	[self.GUI_W_dstM setStringValue: int2reg([[core.W_register objectForKey:@"dstM"] intValue])];
	//refresh register file
	[self.GUI_eax setIntValue:core.DecodeUnit.RegisterFile[REAX]];
	[self.GUI_ecx setIntValue:core.DecodeUnit.RegisterFile[RECX]];
	[self.GUI_edx setIntValue:core.DecodeUnit.RegisterFile[REDX]];
	[self.GUI_ebx setIntValue:core.DecodeUnit.RegisterFile[REBX]];
	[self.GUI_esi setIntValue:core.DecodeUnit.RegisterFile[RESI]];
	[self.GUI_edi setIntValue:core.DecodeUnit.RegisterFile[REDI]];
	[self.GUI_esp setIntValue:core.DecodeUnit.RegisterFile[RESP]];
	[self.GUI_ebp setIntValue:core.DecodeUnit.RegisterFile[REBP]];
	//refresh condition codes
	[self.GUI_ZF setIntValue: core.ExecuteUnit.CC_ZF];
	[self.GUI_SF setIntValue: core.ExecuteUnit.CC_SF];
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
	[self.GUI_FetchedInst setStringValue:[core.FetchUnit.iMemory objectForKey:[NSNumber numberWithInt:core.FetchUnit.f_pc]]];
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
	//load selected image
	[core loadImage: (char *)path];
	//refresh GUI
	[self refreshGUI];
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
}

- (IBAction)pushFullSpeed:(id)sender {
}

- (IBAction)pushSlowly:(id)sender {
}

- (IBAction)pushPause:(id)sender {
}

- (IBAction)pushReset:(id)sender {
}

- (IBAction)pushSet:(id)sender {
}

- (IBAction)pushRemove:(id)sender {
}

- (IBAction)pushSysLog:(id)sender {
}

- (IBAction)pushObserve:(id)sender {
}
@end
