//
//  FriendListViewController.m
//  Circle
//
//  Created by Xin Du on 10/29/15.
//  Copyright © 2015 Circle. All rights reserved.
//Users/xindu/Circle/Circle/Authentication/CircleMainTabBarViewController.h/

#import "FriendListViewController.h"

@interface FriendListViewController ()

@end

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Friend List";
   // NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]);
    //self.navigationItem.titleView.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = @"wenchao";
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    return @"Friends";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld, %ld", indexPath.section, (long)indexPath.row);
}

@end
