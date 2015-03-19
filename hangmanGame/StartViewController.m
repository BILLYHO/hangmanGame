//
//  StartViewController.m
//  hangmanGame
//
//  Created by BILLY HO on 3/18/15.
//  Copyright (c) 2015 BILLY HO. All rights reserved.
//

#import "StartViewController.h"
#import "MainViewController.h"

#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface StartViewController ()

@property (strong, nonatomic) NSString *sessionId;
@property (nonatomic) NSInteger guessPerWord;
@property (nonatomic) NSInteger numberOfWords;

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startGame:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Starting";
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *parameters = @{@"playerId": @"billyho92@foxmail.com", @"action":@"startGame"};
    
    
    [manager POST:@"https://strikingly-hangman.herokuapp.com/game/on" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         _sessionId = [responseObject objectForKey:@"sessionId"];
         _guessPerWord = [[responseObject valueForKeyPath:@"data.numberOfGuessAllowedForEachWord"] integerValue];
         _numberOfWords = [[responseObject valueForKeyPath:@"data.numberOfWordsToGuess"] integerValue];

         //NSLog(@"%@", sessionId);
         
         UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

         MainViewController *mainViewController = (MainViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"mainViewController"];
         mainViewController.sessionId = _sessionId;
         mainViewController.guessPerWord = _guessPerWord;
         mainViewController.nuberOfWords = _numberOfWords;
         
         [self presentViewController:mainViewController animated:YES completion:nil];
         //[MBProgressHUD hideHUDForView:self.view animated:YES];
         [hud hide:YES];
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];

}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"StartGame"])
    {
        MainViewController *mainViewController = segue.destinationViewController;
        mainViewController.sessionId = _sessionId;
        mainViewController.guessPerWord = _guessPerWord;
        mainViewController.nuberOfWords = _numberOfWords;
    }
}

@end
