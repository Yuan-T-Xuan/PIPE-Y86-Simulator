//
//  main.m
//  PIPE-Y86
//
//  Created by XuanYuan on 15/5/23.
//  Copyright (c) 2015年 XuanYuan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, const char * argv[]) {
	//return NSApplicationMain(argc, argv);
	//
	/*NSMutableDictionary *dict;
	dict = [NSMutableDictionary dictionaryWithCapacity:100];
	[dict setObject:@"A String" forKey:[NSNumber numberWithInt:1]];
	NSString *str;
	str = [dict objectForKey:[NSNumber numberWithInt:1]];
	NSNumber* anum = [NSNumber numberWithInt:1];
	int hehe = [anum intValue];
	printf("%d\n", hehe);*/
	NSString* test = @"lalala";
	printf("%d\n", (int)[test length]);
	return 0;
}
