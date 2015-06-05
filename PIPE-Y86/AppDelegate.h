//
//  AppDelegate.h
//  PIPE-Y86
//
//  Created by XuanYuan on 15/5/23.
//  Copyright (c) 2015年 XuanYuan. All rights reserved.
//

#pragma once
#import <Cocoa/Cocoa.h>
#import "PIPE.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
	PIPE* core;
	char _path[200];
	char* file_path;
}
@property PIPE* core;
@property char* file_path;

@property (unsafe_unretained) IBOutlet NSTextView *GUI_inst;

@property (weak) IBOutlet NSTextField *GUI_W_stat;
@property (weak) IBOutlet NSTextField *GUI_W_icode;
@property (weak) IBOutlet NSTextField *GUI_W_valE;
@property (weak) IBOutlet NSTextField *GUI_W_valM;
@property (weak) IBOutlet NSTextField *GUI_W_dstE;
@property (weak) IBOutlet NSTextField *GUI_W_dstM;

@property (weak) IBOutlet NSTextField *GUI_M_stat;
@property (weak) IBOutlet NSTextField *GUI_M_icode;
@property (weak) IBOutlet NSTextField *GUI_M_Cnd;
@property (weak) IBOutlet NSTextField *GUI_M_valE;
@property (weak) IBOutlet NSTextField *GUI_M_valA;
@property (weak) IBOutlet NSTextField *GUI_M_dstE;
@property (weak) IBOutlet NSTextField *GUI_M_dstM;

@property (weak) IBOutlet NSTextField *GUI_E_stat;
@property (weak) IBOutlet NSTextField *GUI_E_icode;
@property (weak) IBOutlet NSTextField *GUI_E_ifun;
@property (weak) IBOutlet NSTextField *GUI_E_valC;
@property (weak) IBOutlet NSTextField *GUI_E_valA;
@property (weak) IBOutlet NSTextField *GUI_E_valB;
@property (weak) IBOutlet NSTextField *GUI_E_dstE;
@property (weak) IBOutlet NSTextField *GUI_E_dstM;
@property (weak) IBOutlet NSTextField *GUI_E_srcA;
@property (weak) IBOutlet NSTextField *GUI_E_srcB;

@property (weak) IBOutlet NSTextField *GUI_D_stat;
@property (weak) IBOutlet NSTextField *GUI_D_icode;
@property (weak) IBOutlet NSTextField *GUI_D_ifun;
@property (weak) IBOutlet NSTextField *GUI_D_rA;
@property (weak) IBOutlet NSTextField *GUI_D_rB;
@property (weak) IBOutlet NSTextField *GUI_D_valC;
@property (weak) IBOutlet NSTextField *GUI_D_valP;

@property (weak) IBOutlet NSTextField *GUI_F_predPC;

@property (weak) IBOutlet NSTextField *GUI_show_breakpoints;

@property (weak) IBOutlet NSTextField *GUI_breakpoint;
@property (weak) IBOutlet NSTextField *GUI_eax;
@property (weak) IBOutlet NSTextField *GUI_ecx;
@property (weak) IBOutlet NSTextField *GUI_edx;
@property (weak) IBOutlet NSTextField *GUI_esp;
@property (weak) IBOutlet NSTextField *GUI_ebx;
@property (weak) IBOutlet NSTextField *GUI_esi;
@property (weak) IBOutlet NSTextField *GUI_edi;
@property (weak) IBOutlet NSTextField *GUI_ebp;
@property (weak) IBOutlet NSTextField *GUI_ZF;
@property (weak) IBOutlet NSTextField *GUI_SF;
@property (weak) IBOutlet NSTextField *GUI_OF;

@property (weak) IBOutlet NSTextField *GUI_F_stall;
@property (weak) IBOutlet NSTextField *GUI_F_bubble;
@property (weak) IBOutlet NSTextField *GUI_D_stall;
@property (weak) IBOutlet NSTextField *GUI_D_bubble;
@property (weak) IBOutlet NSTextField *GUI_E_stall;
@property (weak) IBOutlet NSTextField *GUI_E_bubble;
@property (weak) IBOutlet NSTextField *GUI_M_stall;
@property (weak) IBOutlet NSTextField *GUI_M_bubble;

@property (weak) IBOutlet NSTextField *GUI_ClockCycle;
@property (weak) IBOutlet NSTextField *GUI_FetchedInst;
@property (weak) IBOutlet NSTextField *GUI_address;
@property (weak) IBOutlet NSTextField *GUI_data;

//buttons
@property (weak) IBOutlet NSButton *BTN_Load;
@property (weak) IBOutlet NSButton *BTN_Step;
@property (weak) IBOutlet NSButton *BTN_Back;
@property (weak) IBOutlet NSButton *BTN_FullSpeed;
@property (weak) IBOutlet NSButton *BTN_Slowly;
@property (weak) IBOutlet NSButton *BTN_Pause;
@property (weak) IBOutlet NSButton *BTN_Reset;
@property (weak) IBOutlet NSButton *BTN_Set;
@property (weak) IBOutlet NSButton *BTN_Remove;
@property (weak) IBOutlet NSButton *BTN_SystemLog;
@property (weak) IBOutlet NSButton *BTN_Observe;

- (IBAction)pushLoad:(id)sender;
- (IBAction)pushStep:(id)sender;
- (IBAction)pushBack:(id)sender;
- (IBAction)pushFullSpeed:(id)sender;
- (IBAction)pushSlowly:(id)sender;
- (IBAction)pushPause:(id)sender;
- (IBAction)pushReset:(id)sender;
- (IBAction)pushSet:(id)sender;
- (IBAction)pushRemove:(id)sender;
- (IBAction)pushSysLog:(id)sender;
- (IBAction)pushObserve:(id)sender;

@end









