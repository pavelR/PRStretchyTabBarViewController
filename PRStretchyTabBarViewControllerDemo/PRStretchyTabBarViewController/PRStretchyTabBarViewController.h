//
// PRStretchyTabBarViewController.h
//
// The MIT License (MIT)
//
// Copyright (c) 2014 Pavel Rashchymski
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>
#import "PRStretchySideMenuItem.h"

@class PRStretchyTabBarViewController;
@class PRStretchySideMenuView;

@protocol PRStretchyTabBarControllerDelegate <NSObject>

@optional

- (BOOL)tabBarController:(PRStretchyTabBarViewController *)stretchyTabBarController shouldSelectViewController:(UIViewController *)viewController;

- (void)tabBarController:(PRStretchyTabBarViewController *)stretchyTabBarController didSelectViewController:(UIViewController *)viewController;

@end

@interface PRStretchyTabBarViewController : UIViewController
@property(nonatomic, copy) NSArray *viewControllers;
@property(nonatomic, assign) NSUInteger limitationHorizontalItems;// Defaults is 4
@property(nonatomic, weak) id <PRStretchyTabBarControllerDelegate> delegate;

@property(nonatomic, readonly, strong) UIViewController *selectedViewController;
@property(nonatomic, readonly, assign) NSUInteger selectedIndex;

@property(nonatomic, assign) BOOL blockViewAfterMenuShown;// Defaults is NO
@property(nonatomic, assign) BOOL hideMenuAfterTouch;// Defaults is NO
@property(nonatomic, strong) UIButton *menuButton;

@property (nonatomic, strong, readonly) PRStretchySideMenuView *stretchySideMenuView;

@property(nonatomic, assign, readonly) BOOL isShownMenu;

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;

- (void)setViewController:(UIViewController *)viewController
                  atIndex:(NSUInteger)index
                 animated:(BOOL)animated;

- (void)selectViewControllerAtIndex:(NSUInteger )index animated:(BOOL)animated;

- (void)toggleMenuButton;

@end

@interface UIViewController (PRStretchyTabBarViewController)
@property(nonatomic, readonly, strong) PRStretchyTabBarViewController *tabBarController; // If the view controller has a tab bar controller as its ancestor, return it. Returns nil otherwise.
@property(nonatomic, readonly, strong) PRStretchySideMenuItem *stretchySideMenuItem;
@end