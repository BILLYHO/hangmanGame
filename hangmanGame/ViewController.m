//
//  ViewController.m
//  hangmanGame
//
//  Created by BILLY HO on 3/18/15.
//  Copyright (c) 2015 BILLY HO. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()

@property (strong, nonatomic) NSString *sessionId;
@property (strong, nonatomic) IBOutlet UILabel *currentWord;
@property (strong, nonatomic) IBOutlet UITextField *guessTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startGame:(id)sender
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *parameters = @{@"playerId": @"billyho92@foxmail.com", @"action":@"startGame"};
    
    
    [manager POST:@"https://strikingly-hangman.herokuapp.com/game/on" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"JSON: %@", responseObject);
        _sessionId = [responseObject objectForKey:@"sessionId"];
        //NSLog(@"%@", _sessionId);
    }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

- (IBAction)requestWord:(id)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *parameters = @{@"sessionId": _sessionId, @"action":@"nextWord"};
    
    
    [manager POST:@"https://strikingly-hangman.herokuapp.com/game/on" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

@end
