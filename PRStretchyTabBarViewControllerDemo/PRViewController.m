//
//  PRViewController.m
//  PRStretchyTabBarViewControllerDemo
//
//  Created by pavel_admin on 4/14/14.
//  Copyright (c) 2014 pavel_admin. All rights reserved.
//

#import "PRViewController.h"

#import "PRStretchySideMenuView.h"
#import "PRViewController.h"
#import "PRStretchyTabBarViewController.h"

#import "PRStretchyTabBarViewController/PRStretchySideMenu/PRSystemHelper.h"

@interface PRViewController () <PRStretchyTabBarControllerDelegate>
   @property (nonatomic, strong) PRStretchyTabBarViewController *stretchyTabBarController;
@end

@implementation PRViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
   self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
   if (self) {
      // Custom initialization
   }
   return self;
}

- (void)viewDidLoad {
   [super viewDidLoad];
   [self test];
   // Do any additional setup after loading the view.
}

- (void)test {
   self.stretchyTabBarController = [PRStretchyTabBarViewController new];
   self.stretchyTabBarController.blockViewAfterMenuShown = YES;
   self.stretchyTabBarController.hideMenuAfterTouch = YES;
   self.stretchyTabBarController.limitationHorizontalItems = 5;
   
   self.stretchyTabBarController.menuButton = [self testMenuButton];
   
   self.stretchyTabBarController.stretchySideMenuView.cornerPosition = PRStretchySideMenuCornerPositionTopRight;
   
   [self.view addSubview:self.stretchyTabBarController.view];
   
   // Image and text
   
   UIViewController *v1 = [UIViewController new];
   v1.title = @"Menu";
   v1.view.backgroundColor = [UIColor randomColor];
   v1.stretchySideMenuItem.image = [UIImage imageNamed:@"Display.png"];
   
   UIViewController *v11 = [UIViewController new];
   v11.title = @"Facebook";
   v11.stretchySideMenuItem.image = [UIImage imageNamed:@"Facebook.png"];
   v11.view.backgroundColor = [UIColor randomColor];
   
   UIViewController *v12 = [UIViewController new];
   v12.title = @"Search";
   v12.stretchySideMenuItem.image = [UIImage imageNamed:@"Search.png"];
   v12.view.backgroundColor = [UIColor randomColor];
   
   UIViewController *v13 = [UIViewController new];
   v13.title = @"Settings";
   v13.stretchySideMenuItem.image = [UIImage imageNamed:@"settings.png"];
   v13.view.backgroundColor = [UIColor randomColor];
   
   UIViewController *v14 = [UIViewController new];
   v14.title = @"E-mail";
   v14.stretchySideMenuItem.image = [UIImage imageNamed:@"Message.png"];
   v14.view.backgroundColor = [UIColor randomColor];
   
   // Image only
   
   UIViewController *v15 = [UIViewController new];
   v15.stretchySideMenuItem.image = [UIImage imageNamed:@"Display.png"];
   v15.view.backgroundColor = [UIColor randomColor];
   
   UIViewController *v16 = [UIViewController new];
   v16.stretchySideMenuItem.image = [UIImage imageNamed:@"Facebook.png"];
   v16.view.backgroundColor = [UIColor randomColor];
   
   UIViewController *v17 = [UIViewController new];
   v17.view.backgroundColor = [UIColor randomColor];
   v17.stretchySideMenuItem.image = [UIImage imageNamed:@"Search.png"];
   
   UIViewController *v18 = [UIViewController new];
   v18.view.backgroundColor = [UIColor randomColor];
   v18.stretchySideMenuItem.image = [UIImage imageNamed:@"settings.png"];
   
   UIViewController *v19 = [UIViewController new];
   v19.view.backgroundColor = [UIColor randomColor];
   v19.stretchySideMenuItem.image = [UIImage imageNamed:@"Message.png"];
   
   // Text only
   
   UIViewController *v20 = [UIViewController new];
   v20.title = @"1";
   v20.view.backgroundColor = [UIColor randomColor];
   
   UIViewController *v21 = [UIViewController new];
   v21.title = @"1 2 1";
   v21.view.backgroundColor = [UIColor randomColor];
   
   UIViewController *v22 = [UIViewController new];
   v22.title = @"1 3 3 1";
   v22.view.backgroundColor = [UIColor randomColor];
   
   UIViewController *v23 = [UIViewController new];
   v23.title = @"1 4 6 4 1";
   v23.view.backgroundColor = [UIColor randomColor];
   
   UIViewController *v24 = [UIViewController new];
   v24.title = @"1 5 10 10 5 1";
   v24.view.backgroundColor = [UIColor randomColor];
   
   UIViewController *v25 = [UIViewController new];
   v25.title = @"1 6 15 20 15 6 1";
   v25.view.backgroundColor = [UIColor randomColor];
   
   [self.stretchyTabBarController setViewControllers:@[v1, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, /*v23, v24,*/ v25]
                                            animated:NO];
   
   self.stretchyTabBarController.delegate = self;
   
}

- (UIButton *)testMenuButton {
   CGRect buttonFrame = CGRectMake(0, 0, 30, 30);
   UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
   
   button.frame = buttonFrame;
   [button setTitle:@"+" forState:UIControlStateNormal];
   
   [button.titleLabel setFont:[UIFont systemFontOfSize:30]];
   [button setContentMode:UIViewContentModeCenter];
   [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
   [button addTarget:self
              action:@selector(pressMainButton)
    forControlEvents:UIControlEventTouchUpInside];
   
   return button;
   
}

- (void)pressMainButton {
   [self.stretchyTabBarController toggleMenuButton];
}

- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}

- (BOOL)tabBarController:(PRStretchyTabBarViewController *)stretchyTabBarController shouldSelectViewController:(UIViewController *)viewController {
   return YES;
}

@end
