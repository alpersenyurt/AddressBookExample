//
//  ASUtilityManager.m
//  AddressBookExample
//
//  Created by Netas Mac Book Pro 2 on 17/09/14.
//  Copyright (c) 2014 alperSenyurt. All rights reserved.
//

#import "ContactManager.h"
#import "Person.h"
#import "ContactService.h"
#import "MyException.h"
@import AddressBook;

@implementation ContactManager

@synthesize allContacts,alertMessage;


+ (ContactManager *) sharedManager {
    
    static ContactManager *singleUtilityObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleUtilityObject = [[self alloc] init];
    });
    return singleUtilityObject;
}

-(NSMutableArray *) allContacts{
    
    if (allContacts == nil){
        allContacts = [[NSMutableArray alloc] init];
    }
    
    return allContacts;
}

-(NSString *) alertMessage{
    
    if (alertMessage == nil){
        alertMessage = DEFAULT_CONTACT_PERMISSION_ALERT_MESSAGE;
    }
    
    return alertMessage;
}



- (NSMutableArray *) convertContactsArrayToJSON : (NSMutableArray *) myContacts
{
    
    NSMutableArray * jsonArray = [[NSMutableArray alloc] init] ;
    
    @autoreleasepool {
        
        
        if(myContacts != nil)
        {
            for(int i=0; i<[myContacts count]; i++)
            {
                
                Person * contact = [myContacts objectAtIndex:i];
                
                NSString * phoneNumber =[NSString stringWithFormat:@"%@_%@_%@",contact.firstName,contact.secondName,contact.phoneNumber];
                [jsonArray addObject:phoneNumber];
                
            }
        }
    }
    
    return jsonArray;
    
}
// we must always ask permission when we get contact from AdressBook If not Apple rejectst the app so We couldnt do that according to parameter
-(void)getAllContactFromAdressBookUserPermissionMessage:(NSString *)message withShowAlert:(BOOL)isShowAlert{

    self.alertMessage = message;
    self.showAlertWhenNotHasPermission = isShowAlert;
    
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted)
    {
        //if user has not given contact permission to app , we can show alert if user wants
        if (_showAlertWhenNotHasPermission) {
        
            UIAlertView *cantreachContactAlert = [[UIAlertView alloc] initWithTitle: @"Warning"
                                                                          message:self.alertMessage
                                                                         delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
            [cantreachContactAlert show];
        
        }
    }
 
    
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){ //if user has already given permission
            [self loadContact];
    }
    else {

        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!granted && _showAlertWhenNotHasPermission){
                    UIAlertView *cantreachContactAlert = [[UIAlertView alloc] initWithTitle: @"Warning" message: self.alertMessage delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
                    [cantreachContactAlert show];
                    return;
                }
                [self loadContact];
            });
        });
    }
   
}
-(void)loadContact{

    
    CFErrorRef *error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    
    for(int i = 0; i < numberOfPeople; i++) {
        
        Person *contact = [[Person alloc] init];

        ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
        
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        contact.firstName=firstName;
        contact.secondName= lastName;
        
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
            NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
            contact.phoneNumber = phoneNumber;
        }
        [self.allContacts addObject:contact];
        
    }
    
    
    if ([self.allContacts count]>0) {

    
        [self sendAllContactToServise];
    }

}

-(void)sendAllContactToServise{

    ContactService *servise =[[ContactService alloc] init];
    NSMutableArray *jsonArray =[self convertContactsArrayToJSON:self.allContacts];
    
    [servise sendUserContacts:jsonArray withComplationHandler:^(BOOL succes,MyException *exception) {
        
        if (!succes) {
            
            if (exception.code==RETRY_SERVICE_CODE) {  //MAYBE we want using retry mechanism with only some error code
                
                [self sendAllContactToServise];

            }

        }
    }];
 }
@end
