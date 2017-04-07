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
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
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
     */
   
    
    // 示例: 保存一张图片到钥匙串, 卸载demo后，再重新安装，照片还在
    //NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"1475134424301544"]);
    //NSError *error = nil;
    //[[XYUserDefaults userDefaults] setObject:imageData forKey:@"image" error:&error];
    NSData *d = [[XYUserDefaults userDefaults] objectForKey:@"image"];
    UIImage *image = [UIImage imageWithData:d];
    self.imageView.image = image;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
