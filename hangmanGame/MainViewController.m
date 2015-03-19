//
//  MainViewController.m
//  hangmanGame
//
//  Created by BILLY HO on 3/18/15.
//  Copyright (c) 2015 BILLY HO. All rights reserved.
//

#import "MainViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface MainViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *wordsRemainLabel;
@property (strong, nonatomic) IBOutlet UILabel *guessLeftLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *usedLabel;

@property (strong, nonatomic) IBOutlet UILabel *currentWord;
@property (strong, nonatomic) IBOutlet UITextField *guessTextField;

@property (nonatomic) NSInteger wordsRemain;
@property (nonatomic) NSInteger wrongGuessCount;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _guessTextField.delegate = self;
    _wordsRemain = _nuberOfWords;
    [self requestWord:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateWordRemainLabel
{
    _wordsRemainLabel.text = [NSString stringWithFormat:@"Words remains: %ld", _wordsRemain];
}

- (void)updateGuessLeftLabel
{
    _guessLeftLabel.text = [NSString stringWithFormat:@"Guess left: %ld", _guessPerWord - _wrongGuessCount];
}

- (void)updateUsedLabel:(NSString *)character
{
    _usedLabel.text = [_usedLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@, ", character]];
}

- (IBAction)requestWord:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"sessionId": _sessionId, @"action":@"nextWord"};
    
    [manager POST:@"https://strikingly-hangman.herokuapp.com/game/on" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         _currentWord.text = [responseObject valueForKeyPath:@"data.word"];
         NSLog(@"%@",_currentWord.text);
         _wordsRemain--;
         _wrongGuessCount =  [[responseObject valueForKeyPath:@"data.wrongGuessCountOfCurrentWord"] integerValue];
         [self updateWordRemainLabel];
         [self updateGuessLeftLabel];
         [self updateScore];
         _usedLabel.text = @"Used: ";
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}


- (void)guessWord:(NSString *)word
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *parameters = @{@"sessionId": _sessionId, @"action":@"guessWord", @"guess":word};
    
    
    [manager POST:@"https://strikingly-hangman.herokuapp.com/game/on" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         _currentWord.text = [responseObject valueForKeyPath:@"data.word"];
         NSLog(@"%@",_currentWord.text);
         _wrongGuessCount =  [[responseObject valueForKeyPath:@"data.wrongGuessCountOfCurrentWord"] integerValue];
         [self updateGuessLeftLabel];
         [self updateScore];
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}


- (void)updateScore
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *parameters = @{@"sessionId": _sessionId, @"action":@"getResult"};
    
    
    [manager POST:@"https://strikingly-hangman.herokuapp.com/game/on" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         _scoreLabel.text = [NSString stringWithFormat:@"Score: %@", [responseObject valueForKeyPath:@"data.score"]];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

- (IBAction)submitScore:(id)sender
{
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *parameters = @{@"sessionId": _sessionId, @"action":@"submitResult"};
    
    
    [manager POST:@"https://strikingly-hangman.herokuapp.com/game/on" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         _scoreLabel.text = [NSString stringWithFormat:@"Score: %@", [responseObject valueForKeyPath:@"data.score"]];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [self goBack:sender];
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

- (IBAction)goBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length > 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"One character per time!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        NSString *myRegex = @"[A-Za-z]";
        NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", myRegex];
        NSString *string = textField.text;
        BOOL valid = [myTest evaluateWithObject:string];
        if (valid) {
            NSLog(@"%@", [textField.text uppercaseString]);
            [self guessWord:[textField.text uppercaseString]];
            [self updateUsedLabel:[textField.text uppercaseString]];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid character!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
}


@end
