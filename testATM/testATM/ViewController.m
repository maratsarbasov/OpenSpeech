//
//  ViewController.m
//  testATM
//
//  Created by Marat Sarbasov on 17/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.open.ru/geocoding/1.0.0/getNearATM"]];
    
    NSString *userUpdate =@"<?xml version=\"1.0\"?><getNearATM><coordinates><latitude>55.79073446</latitude><longitude>37.70538694</longitude></coordinates></getNearATM>";
    
    //create the Method "GET" or "POST"
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    
    //Convert the String to Data
    NSData *data1 = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    //Apply the data to the body
    [urlRequest setHTTPBody:data1];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
            parser.delegate = self;
            [parser parse];
            
            NSDictionary *responseDictionary
            NSLog(@"The response is - %@",responseDictionary);
            NSInteger success = [[responseDictionary objectForKey:@"success"] integerValue];
            if(success == 1)
            {
                NSLog(@"Login SUCCESS");
            }
            else
            {
                NSLog(@"Login FAILURE");
            }
        }
        else
        {
            NSLog(@"Error");     
        }
    }];
    [dataTask resume];
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
