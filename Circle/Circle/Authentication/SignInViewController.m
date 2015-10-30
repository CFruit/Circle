//
//  SignInViewController.m
//  Circle
//
//  Created by Wenchao Zhang on 9/26/15.
//  Copyright © 2015 Circle. All rights reserved.
//

#import "SignInViewController.h"
#import "SignUpViewController.h"
#import "CircleMainTabBarViewController.h"

@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *UsernameUITextField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordUITextField;
@property (weak, nonatomic) IBOutlet UIButton *SignInUIButton;
@property (weak, nonatomic) IBOutlet UIButton *SignUpButton;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView* CurrentImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signUpBackground.jpg"]];
    CurrentImage.frame = self.view.bounds;
    [[self view] addSubview:CurrentImage];
    [CurrentImage.superview sendSubviewToBack:CurrentImage];
}


- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidAppear:(BOOL)animated {
    
}
- (void)setUsernameValue:(NSString*)username {
    self.UsernameUITextField.text = username;
}

- (IBAction)SignInUIButtonPressed:(id)sender {
    if(self.UsernameUITextField.text.length==0||self.PasswordUITextField.text.length==0) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Invalid Input"
                                                                       message:@"Email or Password shouldn't be empty."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        NSString *tempString = [[NSString alloc] initWithString:[[[@"http://ec2-54-86-38-175.compute-1.amazonaws.com:8080/CircleAuthenticationService/sign-in?username=" stringByAppendingString:self.UsernameUITextField.text] stringByAppendingString:@"&password="] stringByAppendingString:self.PasswordUITextField.text]];
        
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
                                              NSString *recieveAccessToken = [json objectForKey:@"circleAccessToken"];
                                              [[NSUserDefaults standardUserDefaults] setObject:recieveAccessToken forKey:@"accessToken"];
                                              //NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]);
                                              UIAlertController* alert;
                                              if (succeed) {
                                                  CircleMainTabBarViewController *circleMainTabBarViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CircleMainTabBarViewController"];
                                                  [[NSOperationQueue mainQueue] addOperationWithBlock:^
                                                   {[self presentViewController:circleMainTabBarViewController animated:NO completion:nil];
                                                   }];
                                                  
                                                  
                                              } else {
                                                  int code = [[json objectForKey:@"code"] intValue];
                                                  NSString *info;
                                                  if (code == 2) {
                                                       info = @"Server problem";
                                                  }else if (code == 3) {
                                                      info = @"Cannot find such username-password pair";
                                                  }else {
                                                      info = @"Unknown problem";
                                                  }
                                                  alert = [UIAlertController alertControllerWithTitle:@"Problem"
                                                                                              message:info
                                                                                       preferredStyle:UIAlertControllerStyleAlert];
                                                  UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                        handler:^(UIAlertAction * action) {
                                                                                                            [[NSOperationQueue mainQueue] addOperationWithBlock:^
                                                                                                             {
                                                                                                                 self.PasswordUITextField.text = @"";
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

  }
}


- (IBAction)SignUpButtonPressed:(id)sender {

    SignUpViewController *signUpViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    signUpViewController.parentSignInViewController = self;
    [self addChildViewController:signUpViewController];
    [self.view addSubview:signUpViewController.view];
    [signUpViewController didMoveToParentViewController:self];
    
}

@end
