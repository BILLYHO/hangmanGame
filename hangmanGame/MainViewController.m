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

@property (strong, nonatomic) IBOutlet UILabel *currentWord;
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

- (IBAction)requestWord:(id)sender
{
    [self showHudWithText:@"Getting word..."];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    NSDictionary *parameters = @{@"sessionId": _sessionId, @"action":@"nextWord"};
//    
//    [manager POST:@"https://strikingly-hangman.herokuapp.com/game/on" parameters:parameters
//          success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         NSLog(@"JSON: %@", responseObject);
//         _currentWord.text = [responseObject valueForKeyPath:@"data.word"];
//         NSLog(@"%@",_currentWord.text);
//         _wordsRemain--;
//         _wrongGuessCount =  [[responseObject valueForKeyPath:@"data.wrongGuessCountOfCurrentWord"] integerValue];
//         [self updateWordRemainLabel];
//         [self updateGuessLeftLabel];
//         [self updateScore];
//         _usedLabel.text = @"Used: ";
//     }
//          failure:
//     ^(AFHTTPRequestOperation *operation, NSError *error) {
//         NSLog(@"Error: %@", error);
//     }];
    
    [NetworkEngine performAction:@"nextWord" sessionId:_sessionId
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            _currentWord.text = [responseObject valueForKeyPath:@"data.word"];
            NSLog(@"%@",_currentWord.text);
            _wordsRemain--;
            _wrongGuessCount =  [[responseObject valueForKeyPath:@"data.wrongGuessCountOfCurrentWord"] integerValue];
            [self updateWordRemainLabel];
            [self updateGuessLeftLabel];
            [self updateScore];
            _usedLabel.text = @"Used: ";
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
}


- (void)guessWord:(NSString *)word
{
    [self showHudWithText:@"Checking word..."];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    
//    
//    NSDictionary *parameters = @{@"sessionId": _sessionId, @"action":@"guessWord", @"guess":word};
//    
//    
//    [manager POST:@"https://strikingly-hangman.herokuapp.com/game/on" parameters:parameters
//          success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         NSLog(@"JSON: %@", responseObject);
//         _currentWord.text = [responseObject valueForKeyPath:@"data.word"];
//         NSLog(@"%@",_currentWord.text);
//         
//         
//         NSInteger currentWrongCount = [[responseObject valueForKeyPath:@"data.wrongGuessCountOfCurrentWord"] integerValue];
//         
//         if (_wrongGuessCount == currentWrongCount) {
//             [self showHudTextOnly:@"Bingo!"];
//         } else {
//             [self showHudTextOnly:@"Word not found"];
//             _wrongGuessCount = currentWrongCount;
//         }
//         [self updateGuessLeftLabel];
//         [self updateScore];
//     }
//          failure:
//     ^(AFHTTPRequestOperation *operation, NSError *error) {
//         NSLog(@"Error: %@", error);
//     }];
    
    [NetworkEngine guessWord:word sessionId:_sessionId
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            _currentWord.text = [responseObject valueForKeyPath:@"data.word"];
            NSLog(@"%@",_currentWord.text);
            
            
            NSInteger currentWrongCount = [[responseObject valueForKeyPath:@"data.wrongGuessCountOfCurrentWord"] integerValue];
            
            if (_wrongGuessCount == currentWrongCount) {
                [self showHudTextOnly:@"Bingo!"];
            } else {
                [self showHudTextOnly:@"Word not found"];
                _wrongGuessCount = currentWrongCount;
            }
            [self updateGuessLeftLabel];
            [self updateScore];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (void)updateScore
{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    
//    
//    NSDictionary *parameters = @{@"sessionId": _sessionId, @"action":@"getResult"};
//    
//    
//    [manager POST:@"https://strikingly-hangman.herokuapp.com/game/on" parameters:parameters
//          success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         NSLog(@"JSON: %@", responseObject);
//         _scoreLabel.text = [NSString stringWithFormat:@"Score: %@", [responseObject valueForKeyPath:@"data.score"]];
//         [_hud hide:YES];
//     }
//          failure:
//     ^(AFHTTPRequestOperation *operation, NSError *error) {
//         NSLog(@"Error: %@", error);
//     }];
    
    [NetworkEngine performAction:@"getResult" sessionId:_sessionId
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            _scoreLabel.text = [NSString stringWithFormat:@"Score: %@", [responseObject valueForKeyPath:@"data.score"]];
            [_hud hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)submitScore:(id)sender
{
    [self showHudWithText:@"Submitting score..."];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    
//    
//    NSDictionary *parameters = @{@"sessionId": _sessionId, @"action":@"submitResult"};
//    
//    
//    [manager POST:@"https://strikingly-hangman.herokuapp.com/game/on" parameters:parameters
//          success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         NSLog(@"JSON: %@", responseObject);
//         _scoreLabel.text = [NSString stringWithFormat:@"Score: %@", [responseObject valueForKeyPath:@"data.score"]];
//         [_hud hide:YES];
//         [self goBack:sender];
//     }
//          failure:
//     ^(AFHTTPRequestOperation *operation, NSError *error) {
//         NSLog(@"Error: %@", error);
//     }];
    
    [NetworkEngine performAction:@"submitResult" sessionId:_sessionId
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            _scoreLabel.text = [NSString stringWithFormat:@"Score: %@", [responseObject valueForKeyPath:@"data.score"]];
            [_hud hide:YES];
            [self goBack:sender];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    if (_wrongGuessCount == _guessPerWord)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No guess left! Please get next word!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else if (textField.text.length > 1)
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
