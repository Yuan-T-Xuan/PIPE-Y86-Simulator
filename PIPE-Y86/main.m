//
//  main.m
//  PIPE-Y86
//
//  Created by XuanYuan on 15/5/23.
//  Copyright (c) 2015年 XuanYuan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PIPE.h"

int main(int argc, const char * argv[]) {
	return NSApplicationMain(argc, argv);
	/*
	PIPE* testcore = [PIPE new];
	[testcore loadImage:"/Users/xuan/Documents/计算机原理/lab3/project/asum.yo"];
	//[testcore singleStepForward];
	//for (int i = 0; i < 59; i++) {
	//	[testcore singleStepForward];
	//	[testcore singleStepBackward];
	//}
	[testcore setBreakpointAt:116];
	[testcore run];
	return 0;
	*/
}
