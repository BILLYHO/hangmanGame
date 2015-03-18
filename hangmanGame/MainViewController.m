//
//  MainViewController.m
//  hangmanGame
//
//  Created by BILLY HO on 3/18/15.
//  Copyright (c) 2015 BILLY HO. All rights reserved.
//

#import "MainViewController.h"
#import "AFNetworking.h"

@interface MainViewController ()

@property (strong, nonatomic) IBOutlet UILabel *currentWord;
@property (strong, nonatomic) IBOutlet UITextField *guessTextField;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)requestWord:(id)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *parameters = @{@"sessionId": _sessionId, @"action":@"nextWord"};
    
    
    [manager POST:@"https://strikingly-hangman.herokuapp.com/game/on" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         _currentWord.text = [responseObject valueForKeyPath:@"data.word"];
         NSLog(@"%@",_currentWord.text);
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}


- (void)guessWord:(NSString *)word
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *parameters = @{@"sessionId": _sessionId, @"action":@"guessWord", @"guess":word};
    
    
    [manager POST:@"https://strikingly-hangman.herokuapp.com/game/on" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         _currentWord.text = [responseObject valueForKeyPath:@"data.word"];
         NSLog(@"%@",_currentWord.text);
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

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
            //[self guessWord:[textField.text uppercaseString]];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid character!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
}


@end
