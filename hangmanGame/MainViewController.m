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
#import "NetworkEngine.h"

@interface MainViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *wordsRemainLabel;
@property (strong, nonatomic) IBOutlet UILabel *guessLeftLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *usedLabel;

@property (strong, nonatomic) IBOutlet UILabel *currentWordLabel;
@property (strong, nonatomic) IBOutlet UITextField *guessTextField;

@property (nonatomic) NSInteger wordsRemain;
@property (nonatomic) NSInteger wrongGuessCount;

@property (strong, nonatomic) MBProgressHUD *hud;

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

#pragma Update UI
- (void)updateUIWithCurrentWord:(NSString *)word usedCharacter:(NSString *)character reset:(BOOL)reset
{
    if (reset) {
        _wordsRemain--;
        _wrongGuessCount = 0;
        _usedLabel.text = @"Used: ";
        _wordsRemainLabel.text = [NSString stringWithFormat:@"Words remains: %ld", _wordsRemain];
    } else {
        _usedLabel.text = [_usedLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@, ", character]];
    }
    
    _currentWordLabel.text = word;
    _guessLeftLabel.text = [NSString stringWithFormat:@"Guess left: %ld", _guessPerWord - _wrongGuessCount];
    [self updateScore];
}

#pragma Hud Function
- (void)showHudWithText:(NSString *)text
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = text;
}

- (void)showHudTextOnly:(NSString *)text
{
    _hud.mode = MBProgressHUDModeText;
    _hud.labelText = text;
}

- (void)hidHud
{
    [_hud hide:YES];
}

#pragma Network Action
- (IBAction)requestWord:(id)sender
{
    if (_wordsRemain <= 0) {
        [self showErrorMessage:@"No more word to guess, please submit your score"];
    }
    
    [self showHudWithText:@"Getting word..."];
    
    [NetworkEngine performAction:@"nextWord" sessionId:_sessionId
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            [self updateUIWithCurrentWord:[responseObject valueForKeyPath:@"data.word"]
                            usedCharacter:nil
                                    reset:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
}


- (void)guessWord:(NSString *)word
{
    [self showHudWithText:@"Checking word..."];
    
    [NetworkEngine guessWord:word sessionId:_sessionId
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            NSInteger currentWrongCount = [[responseObject valueForKeyPath:@"data.wrongGuessCountOfCurrentWord"] integerValue];
            
            if (_wrongGuessCount == currentWrongCount) {
                [self showHudTextOnly:@"Bingo!"];
            } else {
                [self showHudTextOnly:@"Word not found!"];
                _wrongGuessCount = currentWrongCount;
            }
            
            [self updateUIWithCurrentWord:[responseObject valueForKeyPath:@"data.word"]
                            usedCharacter:word
                                    reset:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (void)updateScore
{
    [NetworkEngine performAction:@"getResult" sessionId:_sessionId
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            _scoreLabel.text = [NSString stringWithFormat:@"Score: %@", [responseObject valueForKeyPath:@"data.score"]];
            [self hidHud];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)submitScore:(id)sender
{
    [self showHudWithText:@"Submitting score..."];
    
    [NetworkEngine performAction:@"submitResult" sessionId:_sessionId
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            [self hidHud];
            [self goBack:sender];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
    }];
}

- (IBAction)goBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma Validate Input
- (BOOL)validateInput:(NSString *)input
{
    if (_wrongGuessCount == _guessPerWord) {
        [self showErrorMessage:@"No guess left! Please get next word!"];
        return NO;
    }
    
    if (input.length > 1) {
        [self showErrorMessage:@"One character per time!"];
        return NO;
    }

    NSString *myRegex = @"[A-Za-z]";
    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", myRegex];
    BOOL valid = [myTest evaluateWithObject:input];
    if (valid) {
        return YES;
    } else {
        [self showErrorMessage:@"Invalid character!"];
        return NO;
    }
}

- (void)showErrorMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

#pragma UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{    
    if([self validateInput:textField.text]) {
        NSLog(@"%@", [textField.text uppercaseString]);
        [self guessWord:[textField.text uppercaseString]];
    }
}


@end
