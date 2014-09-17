//
//  ContactService.m
//  AddressBookExample
//
//  Created by Netas Mac Book Pro 2 on 17/09/14.
//  Copyright (c) 2014 alperSenyurt. All rights reserved.
//

#import "ContactService.h"

@implementation ContactService


//SERVERS SHOULD HAS METHOD WITH NAME  CONTACT_SERVISE_METHOD WHICH HAS A PARAMATER TOKEN AS STRING AND ARRAY


-(void)sendUserContacts:(NSMutableArray *)contacts withComplationHandler:(complation)handler{
    
   
    // We should check Internettt connection
    if (![self isInternetOK]) {

        return;
    }
    
    
    self.complationHandler=handler;
    
    NSArray * postUserInfoArrayObjects = [[NSArray alloc] initWithObjects:@"token",@"contacts",nil] ;
    NSArray * postUserInfoArrayKeys = [[NSArray alloc] initWithObjects:@"token",contacts,nil] ;
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjects:postUserInfoArrayObjects forKeys:postUserInfoArrayKeys];
    
    if([NSJSONSerialization isValidJSONObject:dict])
    {
        NSError * error = nil;
        
        NSData * jsonData = nil;
        
        jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
        
        if( error == nil && jsonData != nil)
        {
            NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVICE_ADRESS_PREFIX,CONTACT_SERVISE_METHOD]];
            
            NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
            
            [request setHTTPMethod:@"POST"];
            
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
            
            [request setHTTPBody:jsonData];
            
            
            self.theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            if (!self.theConnection)
            {
                
                [self sendException:CONNECTION_ERROR_MESSAGE withStatusCode:-1];

                
            }else{
                self.receivedData = [NSMutableData data];
            }
        }
    }
    
    
    
}
#pragma mark -
#pragma mark - NSURLConnectiondelegates



// SERVISE SHOULD RETURN JSON WHICH HAS A  PARAMETER THAT IS SUCCESS_PREFIX
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError       * xerror = nil;
    NSDictionary * xresult = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingMutableContainers error:&xerror];
    xresult =[xresult objectForKey:@"d"];
    
    if (self.serviceTag == TAG_SRV_CONTACT_SERVISE)
        
    {
        if(xerror == nil)
        {
            int statusResult         = [[xresult objectForKey:SUCCESS_PREFIX] intValue];
            
            if (statusResult==1)
            {
                
                if(nil !=self.complationHandler){
                    self.complationHandler(YES,nil);
                    
                }
                
            }
            else
            {
                
                [self sendException:CONNECTION_ERROR_MESSAGE withStatusCode:statusResult];

            
            }
            
        } else {
        
            [self sendException:xerror.localizedDescription withStatusCode:xerror.code];

        
        }
        
        
    }
    
}
@end
