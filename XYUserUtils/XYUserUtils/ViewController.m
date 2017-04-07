//
//  ViewController.m
//  XYUserUtils
//
//  Created by Ossey on 17/4/7.
//  Copyright © 2017年 Ossey. All rights reserved.
//

#import "ViewController.h"
#import "XYUserDefaults.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSDictionary *dict = @{@"js": @[@"1", @"2", @"3"]};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    [[XYUserDefaults userDefaults] setObject:data forKey:@"test" error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    

    NSData *d = [[XYUserDefaults userDefaults] objectForKey:@"test"];
    NSDictionary *d1 = nil;
    if ([d isKindOfClass:[NSData class]]) {
        d1 = [NSJSONSerialization JSONObjectWithData:d options:NSJSONReadingAllowFragments error:&error];
    }
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    } else {
        NSLog(@"%@", d1);
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
