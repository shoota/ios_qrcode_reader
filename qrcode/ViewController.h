//
//  ViewController.h
//  qrcode
//
//  Created by 熊野修太 on 2015/03/20.
//  Copyright (c) 2015年 anaguma.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureSession* session;

@end

