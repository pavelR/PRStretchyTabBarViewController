//
// PRStretchyTabBarViewController.m
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

#import "PRStretchyTabBarViewController.h"
#import "PRStretchySideMenuView.h"

#import <objc/runtime.h>

@interface PRStretchyTabBarViewController () <PRStretchySideMenuViewDelegate>
@property (nonatomic, strong) NSMutableArray *viewControllersInst;
@property (nonatomic, strong) PRStretchySideMenuView *stretchySideMenuView;
@property(nonatomic, readwrite, assign) NSUInteger selectedIndex;
@property(nonatomic, readwrite, strong) UIViewController *selectedViewController;

@property(nonatomic, assign, readwrite) BOOL isShownMenu;

@end

@implementation PRStretchyTabBarViewController

- (id)init {
   self = [super init];
   if (self) {
      self.viewControllersInst = [NSMutableArray new];
      self.limitationHorizontalItems = 4;
      self.isShownMenu = NO;
      self.blockViewAfterMenuShown = NO;
      self.hideMenuAfterTouch = NO;
   }
   return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
   self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
   if (self) {
      self.viewControllersInst = [NSMutableArray new];
      self.limitationHorizontalItems = 4;
      self.isShownMenu = NO;
      self.blockViewAfterMenuShown = NO;
      self.hideMenuAfterTouch = NO;
   }
   return self;
}

- (void)loadView {
   PRStretchySideMenuView *sideMenuView = [[PRStretchySideMenuView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   self.stretchySideMenuView = sideMenuView;
   self.stretchySideMenuView.cornerPosition = PRStretchySideMenuCornerPositionTopLeft;
   self.stretchySideMenuView.delegate = self;
   self.stretchySideMenuView.stretchViewBackgroundColor = [UIColor lightGrayColor];
   self.view = self.stretchySideMenuView;
}

- (void)viewDidLoad {
   [super viewDidLoad];
   self.view.backgroundColor = [UIColor lightGrayColor];
   self.stretchySideMenuView.menuButton = self.menuButton;
}

- (void)closeMenu:(BOOL)close {
   
   if (close && self.isShownMenu) {
      self.selectedViewController.view.userInteractionEnabled = YES;
      [self.stretchySideMenuView hideMenuWithAnimation:YES];
   } else {
      self.selectedViewController.view.userInteractionEnabled = !self.blockViewAfterMenuShown;
      [self.stretchySideMenuView showMenuWithAnimation:YES];
   }
   
   self.isShownMenu = !self.isShownMenu;
}

- (void)viewWillAppear:(BOOL)animated {
   self.stretchySideMenuView.frame = self.view.frame;
}

- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
}

#pragma mark - Interface

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
   [self.viewControllersInst addObjectsFromArray:viewControllers];
   
   for (UIViewController *vc in self.viewControllers) {
      NSUInteger index = [self.viewControllers indexOfObject:vc];
      [self addStretchyItemFromViewController:vc atIndex:index];
   }
   
   [self selectViewControllerAtIndex:0 animated:animated];
}

- (void)setViewController:(UIViewController *)viewController
                  atIndex:(NSUInteger )index
                 animated:(BOOL)animated {
   [self.viewControllersInst replaceObjectAtIndex:index withObject:viewController];
   [self addStretchyItemFromViewController:viewController atIndex:index];
   [self selectViewControllerAtIndex:index animated:animated];
}

- (void)addStretchyItemFromViewController:(UIViewController *)vc atIndex:(NSUInteger)index {
   
   id activeBlock = ^(PRStretchySideMenuItem *item) {
      for (UIViewController *vc in self.viewControllersInst) {
         if ([vc.stretchySideMenuItem isEqual:item]) {
            NSUInteger index = [self.viewControllersInst indexOfObject:vc];
            [self selectViewControllerAtIndex:index animated:YES];
         }
      }
   };
   
   [vc.stretchySideMenuItem setActionBlock:activeBlock];
   
   if (index < self.limitationHorizontalItems) {
      [self.stretchySideMenuView addItemToHorizontalSideMenu:vc.stretchySideMenuItem atIndex:index];
   } else {
      [self.stretchySideMenuView addItemToVerticalSideMenu:vc.stretchySideMenuItem atIndex:index];
   }
}

- (void)selectViewControllerAtIndex:(NSUInteger )index animated:(BOOL)animated {
   
   if (index >= self.viewControllersInst.count) {
      return;
   }
   
   UIViewController *selectVC = [self.viewControllersInst objectAtIndex:index];
   
   BOOL delegateResponds = [self.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)];
   
   if (delegateResponds) {
      if ([self.delegate tabBarController:self shouldSelectViewController:selectVC]) {
         [self addControllerToMenuView:selectVC atIndex:index];
      }
   } else {
      [self addControllerToMenuView:selectVC atIndex:index];
   }
}

- (void)addControllerToMenuView:(UIViewController *)selectVC atIndex:(NSInteger )index {
   if (selectVC) {
      if ([selectVC.view.superview isKindOfClass:[PRStretchySideMenuView class]]) {
         if (![selectVC isEqual:self.selectedViewController]) {
            [self.view bringSubviewToFront:selectVC.view];
         }
      } else {
         [self.view addSubview:selectVC.view];
      }
   }
   
   // TODO:Fix bug with 20 px status bar
   
   CGRect vcFrame = selectVC.view.frame;
   vcFrame.origin = CGPointMake(vcFrame.origin.x, 0);
   selectVC.view.frame = vcFrame;
   
   if (self.isShownMenu) {
      selectVC.view.userInteractionEnabled = !self.blockViewAfterMenuShown;
   }
   
   self.selectedIndex = index;
   self.selectedViewController = selectVC;
   
   BOOL delegateResponds = [self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)];
   
   if (delegateResponds) {
      [self.delegate tabBarController:self
              didSelectViewController:self.selectedViewController];
   }
}

- (void)toggleMenuButton {
   [self closeMenu:self.isShownMenu];
}

- (void)setViewControllers:(NSArray *)viewControllers {
   [self setViewControllers:viewControllers animated:NO];
}

#pragma mark - Accessors and mutators methods

- (PRStretchySideMenuView *)stretchySideMenuView {
   
   if (!_stretchySideMenuView) {
      PRStretchySideMenuView *sideMenuView = [[PRStretchySideMenuView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
      self.stretchySideMenuView = sideMenuView;
      sideMenuView.cornerPosition = PRStretchySideMenuCornerPositionTopLeft;
      sideMenuView.delegate = self;
      sideMenuView.stretchViewBackgroundColor = [UIColor lightGrayColor];
      _stretchySideMenuView = sideMenuView;
      self.view = _stretchySideMenuView;
   }
   
   return _stretchySideMenuView;
}

- (NSArray *)viewControllers {
   return self.viewControllersInst;
}

- (void)setMenuButton:(UIButton *)menuButton_ {
   _menuButton = menuButton_;
   self.stretchySideMenuView.menuButton = _menuButton;
}

#pragma mark - PRStretchySideMenuViewDelegate methods

- (void)stretchySideMenu:(PRStretchySideMenuView *)menu
            didPressItem:(PRStretchySideMenuItem *)item
                 atIndex:(NSUInteger)index {
   item.actionBlock(item);
}

- (void)stretchySideMenuDidTouch:(PRStretchySideMenuView *)menu {
   
   if (self.hideMenuAfterTouch) {
      if (self.isShownMenu) {
         [self closeMenu:YES];
      }
   }
}

@end

@implementation UIViewController (PRStretchyTabBarViewController)

static char const * const itemTagKey = "stretchySideMenuItemTagKey";

- (PRStretchySideMenuItem *)stretchySideMenuItem {
   
   PRStretchySideMenuItem *item = objc_getAssociatedObject(self, itemTagKey);
   
   if (item) {
      return item;
   }
   
   item = [PRStretchySideMenuItem new];
   item.title = self.title;
   objc_setAssociatedObject(self, itemTagKey, item, OBJC_ASSOCIATION_RETAIN);
   
   return item;
}

@end