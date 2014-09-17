//
//  ASViewController.m
//  AddressBookExample
//
//  Created by Netas Mac Book Pro 2 on 17/09/14.
//  Copyright (c) 2014 alperSenyurt. All rights reserved.
//

#import "ASViewController.h"
#import "ExampleAPIUsage.h"
@interface ASViewController ()

@end

@implementation ASViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    ExampleAPIUsage *example =[[ExampleAPIUsage alloc] init];
    [example callAPI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
