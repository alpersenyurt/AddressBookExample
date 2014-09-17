//
//  Person.h
//  AddressBookExample
//
//  Created by Netas Mac Book Pro 2 on 17/09/14.
//  Copyright (c) 2014 alperSenyurt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject


- (id)initWithFirstName:(NSString *) firstName withLastName:(NSString *)lastName withPersonNumber:(NSString *)phoneNumber;

@property(nonatomic,copy)NSString *firstName;
@property(nonatomic,copy)NSString *secondName;
@property(nonatomic,copy)NSString *phoneNumber;

@end
