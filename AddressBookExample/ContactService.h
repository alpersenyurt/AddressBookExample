//
//  ContactService.h
//  AddressBookExample
//
//  Created by Netas Mac Book Pro 2 on 17/09/14.
//  Copyright (c) 2014 alperSenyurt. All rights reserved.
//

#import "ServisBase.h"

@interface ContactService : ServiceBase

-(void)sendUserContacts:(NSMutableArray *)contacts withComplationHandler:(complation)handler;



@end
