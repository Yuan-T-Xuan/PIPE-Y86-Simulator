//
//  WritePart.m
//  PIPE-Y86
//
//  Created by XuanYuan on 15/5/26.
//  Copyright (c) 2015年 XuanYuan. All rights reserved.
//

#import "WritePart.h"

@implementation WritePart
- (void) GetData: (NSMutableDictionary *) W_Register {
	W_valE = [[W_Register objectForKey:@"valE"] intValue];
	W_valM = [[W_Register objectForKey:@"valM"] intValue];
	W_dstE = [[W_Register objectForKey:@"dstE"] intValue];
	W_dstM = [[W_Register objectForKey:@"dstM"] intValue];
}

- (void) WriteData: (int *) RegisterFile {
	if (W_dstE != RNONE)
		RegisterFile[W_dstE] = W_valE;
	if (W_dstM != RNONE)
		RegisterFile[W_dstM] = W_valM;
}
@end
