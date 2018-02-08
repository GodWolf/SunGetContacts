//
//  SunGetContactsTool.h
//  Test
//
//  Created by 孙兴祥 on 2018/1/30.
//  Copyright © 2018年 sunxiangxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SunContactModel.h"

@interface SunGetContactsTool : NSObject

+ (void)checkAuthorization:(void(^)(BOOL isAllowAccess))accessBlock;

+ (NSArray<SunContactModel *> *)getAllContacts;

@end
