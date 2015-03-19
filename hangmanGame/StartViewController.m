//
//  StartViewController.m
//  hangmanGame
//
//  Created by BILLY HO on 3/18/15.
//  Copyright (c) 2015 BILLY HO. All rights reserved.
//

#import "StartViewController.h"
#import "MainViewController.h"

#import "NetworkEngine.h"
#import "MBProgressHUD.h"

@interface StartViewController ()

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
    hud.labelText = @"Starting...";

    [NetworkEngine startGameWhenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainViewController *mainViewController = (MainViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"mainViewController"];
        mainViewController.sessionId = [responseObject objectForKey:@"sessionId"];
        mainViewController.guessPerWord = [[responseObject valueForKeyPath:@"data.numberOfGuessAllowedForEachWord"] integerValue];
        mainViewController.nuberOfWords = [[responseObject valueForKeyPath:@"data.numberOfWordsToGuess"] integerValue];
        
        [self presentViewController:mainViewController animated:YES completion:nil];
        [hud hide:YES];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
