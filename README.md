# PRStretchyTabBarViewController
==============================

## Snapshot

![PRStretchySideMenuView Top Rigth](https://github.com/pavelR/PRStretchyTabBarViewController/raw/master/Demo.gif)   

## How to Use

```objective-c
   self.stretchyTabBarController = [PRStretchyTabBarViewController new];
   self.stretchyTabBarController.blockViewAfterMenuShown = YES;
   self.stretchyTabBarController.hideMenuAfterTouch = YES;
   self.stretchyTabBarController.limitationHorizontalItems = 5;
   
   // Created and initialized UIButton menuButton_
   
   self.stretchyTabBarController.menuButton = menuButton_;
   self.stretchyTabBarController.stretchySideMenuView.cornerPosition = PRStretchySideMenuCornerPositionTopRight;
   self.stretchyTabBarController.delegate = self;
   [self.view addSubview:self.stretchyTabBarController.view];
   
   UIViewController *v1 = [UIViewController new];
   v1.title = @"Menu";
   v1.view.backgroundColor = [UIColor randomColor];
   v1.stretchySideMenuItem.image = [UIImage imageNamed:@"Display.png"];
   
   UIViewController *v2 = [UIViewController new];
   v2.title = @"Facebook";
   v2.stretchySideMenuItem.image = [UIImage imageNamed:@"Facebook.png"];
   v2.view.backgroundColor = [UIColor randomColor];
   
   // -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/- //
   
   UIViewController *v15 = [UIViewController new];
   v25.title = @"1 6 15 20 15 6 1";
   v25.view.backgroundColor = [UIColor randomColor];
   
   NSArray *viewControllers = @[v1, v2, v3, v4, v5, v6, v7, v8, v18, v19, v20, v21, v22, v23, v24, v25];
   
   [self.stretchyTabBarController setViewControllers:viewControllers
                                            animated:NO];
   
}

```

**That's all**

## Contact

## License

PRStretchyTabBarViewController is available under the MIT license.
