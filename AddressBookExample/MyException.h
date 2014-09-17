//
//  MyExeption.h
//  AddressBookExample
//
//  Created by Netas Mac Book Pro 2 on 17/09/14.
//  Copyright (c) 2014 alperSenyurt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyException : NSObject

@property (nonatomic,retain) NSString   *message;
@property (nonatomic,assign) int        code;
@property (nonatomic,assign) int        doActionCode;

@end
