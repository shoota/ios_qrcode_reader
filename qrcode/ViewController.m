//
//  ViewController.m
//  qrcode
//
//  Created by 熊野修太 on 2015/03/20.
//  Copyright (c) 2015年 anaguma.org. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // session
    self.session = [[AVCaptureSession alloc] init];
    
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    if (self.input) {
        [self.session addInput:self.input];
    } else {
        NSLog(@"error");
    }

    
    // Output
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.session addOutput:self.output];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code]];
    NSLog(@"%@", [self.output availableMetadataObjectTypes]);
    
    
    // Preview
   AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    preview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view.layer insertSublayer:preview atIndex:0];
    
    // Start
    [self.session startRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    // 認識されたメタデータは複数存在することもあるので、１つずつ調べる
    for (AVMetadataObject *data in metadataObjects) {
        // 一次元・二次元コード以外は無視する
        // ※人物顔の識別結果だった場合など
        if (![data isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) continue;
        
        // コード内の文字列を取得
        NSString *strValue = [(AVMetadataMachineReadableCodeObject *)data stringValue];
        
        // 何のタイプとして認識されたかを確認
        if ([data.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            // QRコードの場合、URLとしてmobileSafariを開く
            NSURL *url = [NSURL URLWithString:strValue];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
}


@end
