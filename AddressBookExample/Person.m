//
//  Person.m
//  AddressBookExample
//
//  Created by Netas Mac Book Pro 2 on 17/09/14.
//  Copyright (c) 2014 alperSenyurt. All rights reserved.
//

#import "Person.h"

@implementation Person

- (id)initWithFirstName:(NSString *) firstName withLastName:(NSString *)lastName withPersonNumber:(NSString *)phoneNumber
{
    self = [super init];
    if (self) {
        self.firstName = firstName;
        self.secondName = lastName;
        self.phoneNumber   = phoneNumber;
    }
    return self;
}

@end
