# PRStretchyTabBarViewController

Tab bar with animation appearance and disappearance for save useful screen place. Supports iOS 6 and iOS 7.

## Snapshot

![PRStretchySideMenuView Top Rigth](https://github.com/pavelR/PRStretchyTabBarViewController/raw/master/Demo.gif)   

## How to Use

```objective-c
   PRStetchyTabBarViewController *stretchyTabBarController = [PRStretchyTabBarViewController new];

   // Created and initialized UIButton menuButton_
   
   stretchyTabBarController.menuButton = menuButton_;
   [self.view addSubview:stretchyTabBarController.view];
   
   UIViewController *v1 = [UIViewController new];
   v1.title = @"Menu";
   v1.view.backgroundColor = [UIColor magentaColor];
   v1.stretchySideMenuItem.image = [UIImage imageNamed:@"Display.png"];
   
   UIViewController *v2 = [UIViewController new];
   v2.title = @"Facebook";
   v2.stretchySideMenuItem.image = [UIImage imageNamed:@"Facebook.png"];
   v2.view.backgroundColor = [UIColor blueColor];
   
   // -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/- //
   
   UIViewController *v15 = [UIViewController new];
   v25.title = @"1 6 15 20 15 6 1";
   v25.view.backgroundColor = [UIColor cyanColor];
   
   NSArray *viewControllers = @[v1, v2, v3, v4, v5, v6, v7, v8, v18, v19, v20, v21, v22, v23, v24, v25];
   
   [stretchyTabBarController setViewControllers:viewControllers
                                       animated:NO];
   
}

```
## Contact
[PavelR](http://github.com/pavelR)
## License
PRStretchyTabBarViewController is available under the MIT license.
