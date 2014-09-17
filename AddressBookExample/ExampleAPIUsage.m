//
//  ExampleAPIUsage.m
//  AddressBookExample
//
//  Created by Netas Mac Book Pro 2 on 18/09/14.
//  Copyright (c) 2014 alperSenyurt. All rights reserved.
//

#import "ExampleAPIUsage.h"
#import "ContactManager.h"
@implementation ExampleAPIUsage


// You can call the API in 3 different ways
-(void)callAPI{

    
    //
//FIRST EXAMPLE
    
    //you can get contact with default contact permission message
    [[ContactManager sharedManager] getAllContactFromAdressBookUserPermissionMessage:nil
                                                                       withShowAlert:YES];

/*
//SECOND EXAMPLE
    
    //you can get contact with your contact permission message
    [[ContactManager sharedManager] getAllContactFromAdressBookUserPermissionMessage:
                                                                       @"You must give the app contact permission "
                                                                       withShowAlert:YES];
//THIRD EXAMPLE
   
    //you can get contact without specific your contact message and without alert popup
    [[ContactManager sharedManager] getAllContactFromAdressBookUserPermissionMessage:
                                                                       @"You must give the app contact permission "
                                                                       withShowAlert:NO];
*/

}
@end
