//
//  SunGetContactsTool.m
//  Test
//
//  Created by 孙兴祥 on 2018/1/30.
//  Copyright © 2018年 sunxiangxiang. All rights reserved.
//

#import "SunGetContactsTool.h"
#import <AddressBook/AddressBook.h>

@implementation SunGetContactsTool

+ (void)checkAuthorization:(void(^)(BOOL isAllowAccess))accessBlock {
    
    if(ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined){
        
        ABAddressBookRef bookRef = ABAddressBookCreate();
        ABAddressBookRequestAccessWithCompletion(bookRef, ^(bool granted, CFErrorRef error) {
            if(accessBlock){
                if(granted){
                    accessBlock(YES);
                }else{
                    accessBlock(NO);
                }
            }
            CFRelease(bookRef);
        });
    }else if(ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        if(accessBlock){
            accessBlock(YES);
        }
    }else{
        if(accessBlock){
            accessBlock(NO);
        }
    }
}

+ (NSArray<SunContactModel *> *)getAllContacts {
    
    NSMutableArray *contacts = [NSMutableArray array];
    
    ABAddressBookRef bookRef = ABAddressBookCreate();
    CFArrayRef arrayRef = ABAddressBookCopyArrayOfAllPeople(bookRef);
    
    CFIndex count = CFArrayGetCount(arrayRef);
    for(int i = 0;i<count;i++){
        
        ABRecordRef record = CFArrayGetValueAtIndex(arrayRef, i);
        //获取名字
        NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(record, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(record, kABPersonLastNameProperty);
        //获取电话号码
        ABMultiValueRef multiValue = ABRecordCopyValue(record, kABPersonPhoneProperty);
        NSString *phone = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(multiValue, 0);
        CFRelease(multiValue);
        //头像
        CFDataRef imageData = ABPersonCopyImageDataWithFormat(record, kABPersonImageFormatThumbnail);
        UIImage *image = [UIImage imageWithData:(NSData*)CFBridgingRelease(imageData)];
        
        SunContactModel *model = [[SunContactModel alloc] init];
        model.name = [NSString stringWithFormat:@"%@%@",(lastName?lastName:@""),(firstName?firstName:@"")];
        model.phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        if([model.phone containsString:@"+86"]){
            model.phone = [model.phone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        }
        model.iconImage = image;
        if(model.phone.length > 0){
            [contacts addObject:model];
        }
        
    }
    
    CFRelease(arrayRef);
    CFRelease(bookRef);
    return contacts;
}

@end
