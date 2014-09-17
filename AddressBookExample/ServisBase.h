//
//  ServisBase.h
//  AddressBookExample
//
//  Created by Netas Mac Book Pro 2 on 17/09/14.
//  Copyright (c) 2014 alperSenyurt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
#import "MyException.h"

typedef void (^complation)(BOOL,MyException *);


@interface ServiceBase : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>{
}


@property (nonatomic,assign) int serviceTag;
@property (nonatomic,retain) NSURLConnection *theConnection;
@property (nonatomic,retain) NSMutableData * receivedData;
@property(nonatomic,copy)complation complationHandler;

@property(nonatomic,assign,getter = isRunning) BOOL running;
@property(nonatomic,assign) BOOL doFinish;

@property (nonatomic) BOOL isCanceledExt;

-(void) cancel;
-(void) sendException:(NSString *) message withStatusCode:(int)code;
-(void) setConnectionFail:(id)connection andError:(NSError*)error;
-(BOOL) isInternetOK;


@end
