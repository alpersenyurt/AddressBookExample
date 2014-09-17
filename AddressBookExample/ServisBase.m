//
//  ServisBase.m
//  AddressBookExample
//
//  Created by Netas Mac Book Pro 2 on 17/09/14.
//  Copyright (c) 2014 alperSenyurt. All rights reserved.
//

#import "ServisBase.h"
#import "MyException.h"
#import "Reachability.h"

@interface ServiceBase()
@end



@implementation ServiceBase


@synthesize serviceTag;
@synthesize theConnection;
@synthesize receivedData;
@synthesize running;
@synthesize doFinish;
@synthesize isCanceledExt;

-(id) init {
    self = [super init];
    isCanceledExt = NO;
    return self;
}

-(void) cancel{
    doFinish = YES;
    
}




-(void) setConnectionResponse:(NSURLResponse*) response andConnection:(id)connection
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    
    if ([httpResponse statusCode] >= 400) {
        
        
        [self setRunning:NO];
        
        NSString *errorText = [NSString stringWithFormat:@"statu:%ld\n%@",(long)[httpResponse statusCode],
                               [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]];
      
        [self sendException:errorText withStatusCode:httpResponse.statusCode];
        
        if ([connection isKindOfClass:[NSURLConnection class]]) {
            [connection cancel];
        }
      
    } else {
        if (receivedData) {
            [receivedData setLength:0];
        }
        
        [self setRunning:YES];
    }
}

-(void) setConnectionFail:(id)connection andError:(NSError*)error
{

    [self setRunning:NO];
    
    if (self.isCanceledExt) {
        
        self.isCanceledExt = NO;
    }
    [self sendException:[error localizedDescription] withStatusCode:-1];
    
    
    
}





#pragma mark -
#pragma mark - NSURLConnectiondelegates

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self setConnectionResponse:response andConnection:connection];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [receivedData appendData:data];
    [self setRunning:YES];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self setConnectionFail:connection andError:error];
    
}

-(void) sendException:(NSString *) message withStatusCode:(int)code{
    
    MyException *ex = [[MyException alloc] init];
    ex.message = message;
    ex.code = code;
    if (nil!=_complationHandler) {
        
        _complationHandler(NO,ex);
        
    }
    
    
}


-(BOOL) isInternetOK
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        UIAlertView *noInternetWarning = [[UIAlertView alloc] initWithTitle: @"Warning"
                                                                        message:NO_INTERNET
                                                                       delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [noInternetWarning show];

        [self sendException: @"CONNECTION_ERROR" withStatusCode:-1];
;
    }
    return YES;
}

@end
