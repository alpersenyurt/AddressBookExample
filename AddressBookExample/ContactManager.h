//
//  ASUtilityManager.h
//  AddressBookExample
//
//  Created by Netas Mac Book Pro 2 on 17/09/14.
//  Copyright (c) 2014 alperSenyurt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactManager : NSObject

@property(nonatomic,assign)BOOL showAlertWhenNotHasPermission;
@property(nonatomic,copy)NSString *alertMessage; //IF user wants ,user can change default alertMessage;

@property(nonatomic,retain)NSMutableArray *allContacts;

+ (ContactManager *) sharedManager ;
- (NSMutableArray *) convertContactsArrayToJSON : (NSMutableArray *) myContacts;
-(void)getAllContactFromAdressBookUserPermissionMessage:(NSString *)message withShowAlert:(BOOL)isShowAlert;

@end
