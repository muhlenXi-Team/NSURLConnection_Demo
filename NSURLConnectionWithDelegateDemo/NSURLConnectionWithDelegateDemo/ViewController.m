//
//  ViewController.m
//  NSURLConnectionWithDelegateDemo
//
//  Created by muhlenXi on 2016/11/15.
//  Copyright © 2016年 XiYinjun. All rights reserved.
//

#import "ViewController.h"

// 循序NSURLConnectionDataDelegate协议
@interface ViewController () <NSURLConnectionDataDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *summaryImageView;


// 把Connection保存起来，为了方便操作
@property (nonatomic, strong) NSURLConnection *connection;
// 数据的容器，为了把请求到的数据，拼成完整的数据
@property (nonatomic, strong) NSMutableData *responseData;
// 数据总共的大小
@property (nonatomic, assign) NSInteger totalLength;

@end


@implementation ViewController

- (IBAction)downloadImageAction:(UIButton *)sender {
    
    NSString * urlString= @"http://img95.699pic.com/photo/2016/08/27/d5e2f6f6-0212-46ed-b27a-55e2e14647e2.jpg_wh300.jpg";
    
    NSString *urlStr = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 1.创建一个NSURLConnection对象，
    //2.同时发送异步请求，结果是通过Delegate返回
    self.connection =
    [NSURLConnection connectionWithRequest:request delegate:self];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSURLConnectionDataDelegate

// 接收到服务器的响应，这里可以拿到响应头
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // __PRETTY_FUNCTION__ 当前函数的函数名
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // 获取响应头
    NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
    NSLog(@"headers == %@", headers);
    
    // 服务器返回的数据总的大小
    self.totalLength = [headers[@"Content-Length"] integerValue];
    
    // 接收到服务器响应的时候，要清空数据容器
    self.responseData.length = 0;
}

// 接收到服务器的数据，因为数据会被分成N段发送过来，这个方法会被调用N次
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // 把一段段数据拼到容器里
    [self.responseData appendData:data];
    
    // 数据的下载进度
    float p = self.responseData.length *1.0f / self.totalLength;
    NSLog(@"%d %%", (int)(p*100));
}

// 整个请求完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // 请求完成之后可以解析数据
    NSLog(@"responseData == %@",self.responseData);
    
    UIImage * image = [UIImage imageWithData:self.responseData];
    self.summaryImageView.image = image;
}

// 请求失败会调用这个方法
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSLog(@"请求失败: %@", error);
}


#pragma mark - Setter & Getter

// Getter方法，懒加载-用到的时候才加载
// 除了Getter方法以外的任何地方，都要用Getter方法(.语法)来访问成员变量
- (NSMutableData *)responseData
{
    if (_responseData == nil) {
        _responseData = [[NSMutableData alloc] init];
    }
    
    return _responseData;
}



@end
