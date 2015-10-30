//
//  SignUpViewController.m
//  Circle
//
//  Created by Xin Du on 9/26/15.
//  Copyright © 2015 Circle. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *EmailUITextField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordUITextField;
@property (weak, nonatomic) IBOutlet UITextField *RepeatPasswordUITextField;



@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView* CurrentImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signInBackground.jpg"]];
    CurrentImage.frame = self.view.bounds;
    [[self view] addSubview:CurrentImage];
    [CurrentImage.superview sendSubviewToBack:CurrentImage];
}

-(void) moveToParentView {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
- (IBAction)CreateButtonPressed:(id)sender {
    
    if(self.EmailUITextField.text.length==0||self.PasswordUITextField.text.length==0||self.RepeatPasswordUITextField.text.length==0) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Invalid Input"
                                                                       message:@"Email or Password shouldn't be empty."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else if([self.PasswordUITextField.text isEqualToString:self.RepeatPasswordUITextField.text]) {
        
        NSString *tempString = [[NSString alloc] initWithString:[[[@"http://ec2-54-86-38-175.compute-1.amazonaws.com:8080/CircleAuthenticationService/create-new-account?username=" stringByAppendingString:self.EmailUITextField.text] stringByAppendingString:@"&password="] stringByAppendingString:self.RepeatPasswordUITextField.text]];
        
        NSURL *URL = [NSURL URLWithString:tempString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        request.HTTPMethod = @"POST";
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          if (!error) {

                                          NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                          Boolean succeed = [[json objectForKey:@"succeed"] boolValue];
                                          NSString *information = [json objectForKey:@"information"];
                                              
                                              UIAlertController* alert;
                                          if (succeed) {
                                              alert = [UIAlertController alertControllerWithTitle:@"Create account Successfully"
                                                                                                             message:@"Your account has already been created. An email has been sent to your email."
                                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                                              UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                    handler:^(UIAlertAction * action) {
                                                                                                        [[NSOperationQueue mainQueue] addOperationWithBlock:^
                                                                                                         {
                                                                                                             [self.parentSignInViewController setUsernameValue:self.EmailUITextField.text];
                                                                                                             [self moveToParentView];
                                                                                                         }];
                                                                                                    }];
                                              [alert addAction:defaultAction];
                                              [[NSOperationQueue mainQueue] addOperationWithBlock:^
                                               {[self presentViewController:alert animated:YES completion:nil];
                                               }];
                                              
                                          } else {
                                              alert = [UIAlertController alertControllerWithTitle:@"Create Problem!"
                                                                                                             message:information
                                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                                              UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                    handler:^(UIAlertAction * action) {
                                                                                                        [[NSOperationQueue mainQueue] addOperationWithBlock:^
                                                                                                         {
                                                                                                             self.EmailUITextField.text = @"";
                                                                                                             self.PasswordUITextField.text = @"";
                                                                                                             self.RepeatPasswordUITextField.text = @"";
                                                                                                         }];
                                                                                                    }];
                                              [alert addAction:defaultAction];
                                              [[NSOperationQueue mainQueue] addOperationWithBlock:^
                                               {[self presentViewController:alert animated:YES completion:nil];
                                               }];
                                          }
                                              
                                              
                                          } else {
                                              UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Connect Error"
                                                                                                             message:@"Please make sure you connect to the internet."
                                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                                              
                                              UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                    handler:^(UIAlertAction * action) {
                                                                                                        
                                                                                                    }];
                                              
                                              [alert addAction:defaultAction];
                                              [self presentViewController:alert animated:YES completion:nil];
                                          }
                                      }];
        
        [task resume];

    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Invalid Input"
                                                                       message:@"The password you input should be same."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                              
                                                              }];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        self.PasswordUITextField.text = @"";
        self.RepeatPasswordUITextField.text = @"";
    }
    
}

- (IBAction)AlreadyButtonPressed:(id)sender {
    [self moveToParentView];
}


@end

