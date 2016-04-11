//
//  ViewController.m
//  CWSwipeCell
//
//  Created by Li Chen wei on 2016/4/7.
//  Copyright © 2016年 TWML. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UITableView *demoTableView;

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

#pragma mark - UITableView DataSource and Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CWSwipeTableViewCell *cell = [[CWSwipeTableViewCell alloc] initWithTableViewCellType:CWTableViewCellStyleDoubleSided reuseIdentifier:@"Cell"];
    cell.delegate = self;
    NSLog(@"12345678");
    
    return cell;
}

#pragma mark - CWTableViewCellProtocol

- (UIView *)cellSwipeViewWithDirection:(NSString *)direction
{
    if ([direction isEqualToString:@"CWTableViewCellStyleRight"]) {
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
        rightView.backgroundColor = [UIColor redColor];
        return rightView;
    }else{
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
        leftView.backgroundColor = [UIColor blueColor];
        return leftView;
    }
}


@end
