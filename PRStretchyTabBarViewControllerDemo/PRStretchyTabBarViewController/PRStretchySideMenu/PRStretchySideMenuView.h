//
// PRStretchySideMenuView.h
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

typedef NS_ENUM(NSUInteger, PRStretchySideMenuCornerPosition) {
   PRStretchySideMenuCornerPositionTopLeft,
   PRStretchySideMenuCornerPositionTopRight,
   PRStretchySideMenuCornerPositionBottomLeft,
   PRStretchySideMenuCornerPositionBottomRight
};

@class PRStretchySideMenuItem;
@class PRStretchySideMenuView;

@protocol PRStretchySideMenuViewDelegate <NSObject>

@required
- (void)stretchySideMenu:(PRStretchySideMenuView *)menu
            didPressItem:(PRStretchySideMenuItem *)item
                 atIndex:(NSUInteger)index;

@optional
- (void)stretchySideMenuWillAppear:(PRStretchySideMenuView *)menu;
- (void)stretchySideMenuDidAppear:(PRStretchySideMenuView *)menu;

- (void)stretchySideMenuWillDisappear:(PRStretchySideMenuView *)menu;
- (void)stretchySideMenuDidDisappear:(PRStretchySideMenuView *)menu;

- (void)stretchySideMenuDidTouch:(PRStretchySideMenuView *)menu;

@end

@interface PRStretchySideMenuView : UIView

@property (nonatomic, strong ) UIButton *menuButton;//Defulte nil
@property (nonatomic, weak) id <PRStretchySideMenuViewDelegate> delegate;

@property (nonatomic, strong) UIColor *stretchViewBackgroundColor;
@property (nonatomic, strong) UIColor *stretchViewTintColor;

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong, readonly) PRStretchySideMenuItem *selectedItem;

@property(nonatomic, assign) PRStretchySideMenuCornerPosition cornerPosition;// Define is Top Right

- (void)showMenuWithAnimation:(BOOL)animation;
- (void)hideMenuWithAnimation:(BOOL)animation;

- (void)addItemToVerticalSideMenu:(PRStretchySideMenuItem *)item atIndex:(NSUInteger)index;
- (void)addItemToHorizontalSideMenu:(PRStretchySideMenuItem *)item atIndex:(NSUInteger)index;;

@end
