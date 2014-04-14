//
// PRStretchySideMenuView.m
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

#import "PRStretchySideMenuView.h"
#import "PRStretchySideMenuItem.h"
#import "PRStretchySideMenuItemView.h"

#import "PRSystemHelper.h"

static CGFloat kVerticalBarViewWidth = 100;
static CGFloat kHorizontalBarViewHeight = 100;
static CGFloat kHorizontalBarViewOffsetX = 0;
static CGFloat kVerticalBarViewOffsetY = 0;
static CGFloat kBarViewsOffset = 50;
static CGFloat kStatusBarHeight = 20;

@interface PRStretchySideMenuView ()

@property (nonatomic, strong) UIView *verticalSideMenuView;
@property (nonatomic, strong) UIView *horizontalSideMenuView;

@property (nonatomic, strong) NSMutableArray *verticalMenuItems;
@property (nonatomic, strong) NSMutableArray *horizontalMenuItems;

@property (nonatomic, strong, readwrite) PRStretchySideMenuItem *selectedItem;

@property (nonatomic, strong) PRStretchySideMenuItemView *selectedItemView;

@end

@implementation PRStretchySideMenuView

- (id)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
   if (self) {
      self.verticalMenuItems = [NSMutableArray new];
      self.horizontalMenuItems = [NSMutableArray new];
      self.autoresizesSubviews = NO;
      self.autoresizingMask = UIViewAutoresizingNone;
   }
   return self;
}

- (void)dealloc {
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didMoveToSuperview {
   [super didMoveToSuperview];
   [self layoutMenuButton];
}

#pragma mark - Accessors and mutators methods

- (void)setMenuButton:(UIButton *)menuButton {
   [_menuButton removeFromSuperview];
   _menuButton = menuButton;
   [self layoutMenuButton];
   [self addSubview:_menuButton];
}

- (UIView *)verticalSideMenuView {
   if (!_verticalSideMenuView) {
      
      CGRect frame = CGRectNull;
      
      if ((self.cornerPosition == PRStretchySideMenuCornerPositionTopRight) ||
          (self.cornerPosition == PRStretchySideMenuCornerPositionBottomRight)) {
         frame = CGRectMake(self.frame.size.width,
                            kVerticalBarViewOffsetY,
                            kVerticalBarViewWidth + kBarViewsOffset,
                            self.frame.size.height);
      }
      
      if ((self.cornerPosition == PRStretchySideMenuCornerPositionTopLeft) ||
          (self.cornerPosition == PRStretchySideMenuCornerPositionBottomLeft)) {
         frame = CGRectMake(-(kVerticalBarViewWidth + kBarViewsOffset),
                            kVerticalBarViewOffsetY,
                            kVerticalBarViewWidth + kBarViewsOffset,
                            self.frame.size.height);
      }
      
      _verticalSideMenuView = [[UIView alloc] initWithFrame:frame];
      _verticalSideMenuView.backgroundColor = self.stretchViewBackgroundColor;
      [self addSubview:_verticalSideMenuView];
   }
   
   return _verticalSideMenuView;
}

- (UIView *)horizontalSideMenuView {
   if (!_horizontalSideMenuView) {
      
      CGRect frame = CGRectNull;
      
      if ((self.cornerPosition == PRStretchySideMenuCornerPositionTopRight) ||
          (self.cornerPosition == PRStretchySideMenuCornerPositionTopLeft)) {
         frame = CGRectMake(kHorizontalBarViewOffsetX,
                            -(kHorizontalBarViewHeight + kBarViewsOffset),
                            self.frame.size.width,
                            kHorizontalBarViewHeight + kBarViewsOffset);
      }
      
      if ((self.cornerPosition == PRStretchySideMenuCornerPositionBottomRight) ||
          (self.cornerPosition == PRStretchySideMenuCornerPositionBottomLeft)) {
         frame = CGRectMake(kHorizontalBarViewOffsetX,
                            self.frame.size.height,
                            self.frame.size.width,
                            kHorizontalBarViewHeight + kBarViewsOffset);
      }
      
      _horizontalSideMenuView = [[UIView alloc] initWithFrame:frame];
      _horizontalSideMenuView.backgroundColor = self.stretchViewBackgroundColor;
      [self addSubview:_horizontalSideMenuView];
   }
   
   return _horizontalSideMenuView;
}

- (void)setCornerPosition:(PRStretchySideMenuCornerPosition)cornerPosition_ {
   _cornerPosition = cornerPosition_;
   _verticalSideMenuView = nil;
   _horizontalSideMenuView = nil;
   [self layoutMenuButton];
}

#pragma mark - Actions

- (void)press:(PRStretchySideMenuItemView *)itemView {
   
   PRStretchySideMenuItem *item = (itemView.tag < self.horizontalMenuItems.count) ? [self.horizontalMenuItems objectAtIndex:itemView.tag] : nil;
   
   if (!item) {
      NSUInteger verticalIndex = (itemView.tag - self.horizontalMenuItems.count);
      item = [self.verticalMenuItems objectAtIndex:verticalIndex];
   }
   
   NSAssert(item, @"Item should not be nil");
   
   [self selectItem:item itemView:itemView];
   
   BOOL delegateResponds = [self.delegate respondsToSelector:@selector(stretchySideMenu:didPressItem:atIndex:)];
   
   if (delegateResponds) {
      [self.delegate stretchySideMenu:self
                         didPressItem:item
                              atIndex:itemView.tag];
   }
}

#pragma mark - Appearance and disappearance methods

- (void)showBarViews {
   
   [self showHorizontalBarView];
   [self showVerticalBarView];
}

- (void)showHorizontalBarView {
   
   CGRect oldFrame = self.horizontalSideMenuView.frame;
   
   if ((self.cornerPosition == PRStretchySideMenuCornerPositionTopRight) ||
       (self.cornerPosition == PRStretchySideMenuCornerPositionTopLeft)) {
      oldFrame.origin.y += kBarViewsOffset + [self statusBarHeight];
   }
   
   if ((self.cornerPosition == PRStretchySideMenuCornerPositionBottomRight) ||
       (self.cornerPosition == PRStretchySideMenuCornerPositionBottomLeft)) {
      oldFrame.origin.y -= kBarViewsOffset;
   }
   
   self.horizontalSideMenuView.frame = oldFrame;
}

- (void)showVerticalBarView {
   
   CGRect oldFrame = self.verticalSideMenuView.frame;
   
   if ((self.cornerPosition == PRStretchySideMenuCornerPositionTopRight) ||
       (self.cornerPosition == PRStretchySideMenuCornerPositionBottomRight)) {
      oldFrame.origin.x -= kBarViewsOffset;
   }
   
   if ((self.cornerPosition == PRStretchySideMenuCornerPositionTopLeft) ||
       (self.cornerPosition == PRStretchySideMenuCornerPositionBottomLeft)) {
      oldFrame.origin.x += kBarViewsOffset;
   }
   
   self.verticalSideMenuView.frame = oldFrame;
}

- (void)hideBarViews {
   [self hideHorizontalBarView];
   [self hideVerticalBarView];
}

- (void)hideHorizontalBarView {
   CGRect oldFrame = self.horizontalSideMenuView.frame;
   
   if ((self.cornerPosition == PRStretchySideMenuCornerPositionTopRight) ||
       (self.cornerPosition == PRStretchySideMenuCornerPositionTopLeft)) {
      oldFrame.origin.y -= kBarViewsOffset + [self statusBarHeight];
   }
   
   if ((self.cornerPosition == PRStretchySideMenuCornerPositionBottomRight) ||
       (self.cornerPosition == PRStretchySideMenuCornerPositionBottomLeft)) {
      oldFrame.origin.y += kBarViewsOffset;
   }
   
   self.horizontalSideMenuView.frame = oldFrame;
}

- (void)hideVerticalBarView {
   CGRect oldFrame = self.verticalSideMenuView.frame;
   
   if ((self.cornerPosition == PRStretchySideMenuCornerPositionTopRight) ||
       (self.cornerPosition == PRStretchySideMenuCornerPositionBottomRight)) {
      oldFrame.origin.x += kBarViewsOffset;
   }
   
   if ((self.cornerPosition == PRStretchySideMenuCornerPositionTopLeft) ||
       (self.cornerPosition == PRStretchySideMenuCornerPositionBottomLeft)) {
      oldFrame.origin.x -= kBarViewsOffset;
   }
   
   self.verticalSideMenuView.frame = oldFrame;
}

#pragma mark - Overloaded UIView methods

- (void)didAddSubview:(UIView *)subview {
   [super didAddSubview:subview];
   [self bringSubvies];
}

- (void)bringSubviewToFront:(UIView *)view {
   [super bringSubviewToFront:view];
   [self bringSubvies];
}

#pragma mark - Layout items

- (void)bringSubvies {
   [super bringSubviewToFront:self.verticalSideMenuView];
   [super bringSubviewToFront:self.horizontalSideMenuView];
   [super bringSubviewToFront:self.menuButton];
}

- (void)layoutHorizontalItems {
   CGFloat width = self.horizontalSideMenuView.frame.size.width - kBarViewsOffset;
   CGFloat height = kBarViewsOffset;
   
   CGFloat itemWidth = width/self.horizontalMenuItems.count;
   
   PRStretchySideMenuItemView *lastView = nil;
   
   for (PRStretchySideMenuItemView *view in self.horizontalSideMenuView.subviews) {
      CGFloat x = lastView.frame.origin.x + lastView.frame.size.width;
      CGFloat y = view.frame.origin.y;
      
      if (!lastView) {
         if ((self.cornerPosition == PRStretchySideMenuCornerPositionTopLeft) ||
             (self.cornerPosition == PRStretchySideMenuCornerPositionBottomLeft)) {
            x+=kBarViewsOffset;
         }
      }
      
      view.frame = CGRectMake(x, y, itemWidth, height);
      lastView = view;
   }
}

- (void)layoutVerticalItems {
   PRStretchySideMenuItemView *lastView = nil;
   
   for (PRStretchySideMenuItemView *view in self.verticalSideMenuView.subviews) {
      
      CGFloat width = kBarViewsOffset;
      CGFloat height = view.frame.size.height;
      
      CGFloat y = lastView.frame.origin.y + lastView.frame.size.height;
      CGFloat x = view.frame.origin.x;
      
      CGFloat bouncingOffset = 0;
      
      if ((self.cornerPosition == PRStretchySideMenuCornerPositionTopRight) ||
          (self.cornerPosition == PRStretchySideMenuCornerPositionTopLeft)) {
         bouncingOffset = 3*5;
      }
      
      if ((self.cornerPosition == PRStretchySideMenuCornerPositionBottomRight) ||
          (self.cornerPosition == PRStretchySideMenuCornerPositionBottomLeft)) {
         bouncingOffset = 5;
      }
      
      CGFloat itemHeight = (self.frame.size.height - kBarViewsOffset - [self statusBarHeight] - bouncingOffset)/self.verticalMenuItems.count;
      
      if (itemHeight < height) {
         height = itemHeight;
      }
      
      if (!lastView) {
         if ((self.cornerPosition == PRStretchySideMenuCornerPositionTopRight) ||
             (self.cornerPosition == PRStretchySideMenuCornerPositionTopLeft)) {
            y+=kBarViewsOffset + [self statusBarHeight] + 2*5;
         }
         
         if ((self.cornerPosition == PRStretchySideMenuCornerPositionBottomRight) ||
             (self.cornerPosition == PRStretchySideMenuCornerPositionBottomLeft)) {
            y+=[self statusBarHeight];
         }
      }
      
      if ((self.cornerPosition == PRStretchySideMenuCornerPositionTopRight) ||
          (self.cornerPosition == PRStretchySideMenuCornerPositionTopLeft)) {
         x = 0;
      }
      
      if ((self.cornerPosition == PRStretchySideMenuCornerPositionTopLeft) ||
          (self.cornerPosition == PRStretchySideMenuCornerPositionBottomLeft)) {
         x = self.verticalSideMenuView.frame.size.width - kBarViewsOffset;
      }
      
      
      view.frame = CGRectMake(x, y, width, height);
      lastView = view;
   }
}

- (void)layoutMenuButton {
   CGFloat menuButtonX = 0.0;
   CGFloat menuButtonY = 0.0;
   
   CGFloat menuButtonWidth = kBarViewsOffset;
   CGFloat menuButtonHeight = kBarViewsOffset;
   
   switch (self.cornerPosition) {
      case PRStretchySideMenuCornerPositionTopRight:
         menuButtonX = self.frame.size.width - menuButtonWidth - (kBarViewsOffset - menuButtonWidth)/2;
         menuButtonY = [self statusBarHeight];
         break;
      case PRStretchySideMenuCornerPositionTopLeft:
         menuButtonX = (kBarViewsOffset - menuButtonWidth)/2;
         menuButtonY = [self statusBarHeight];
         break;
      case PRStretchySideMenuCornerPositionBottomLeft:
         menuButtonX = (kBarViewsOffset - menuButtonWidth)/2;
         menuButtonY = self.frame.size.height - menuButtonHeight - (kBarViewsOffset - menuButtonHeight)/2;
         break;
      case PRStretchySideMenuCornerPositionBottomRight:
         menuButtonX = self.frame.size.width - menuButtonWidth - (kBarViewsOffset - menuButtonWidth)/2;
         menuButtonY = self.frame.size.height - menuButtonHeight - (kBarViewsOffset - menuButtonHeight)/2;
         break;
      default:
         break;
   }
   
   CGRect buttonFrame = CGRectMake(menuButtonX,
                                   menuButtonY,
                                   menuButtonWidth,
                                   menuButtonHeight);
   
   self.menuButton.frame = buttonFrame;
}

- (PRStretchySideMenuItemView *)verticalButtonFromItem:(PRStretchySideMenuItem *)item atIndex:(NSUInteger )index {
   
   NSUInteger verticalIndex = (index - self.horizontalMenuItems.count);
   PRStretchySideMenuItemView *itemView = [[PRStretchySideMenuItemView alloc] initWithSideMenuItem:item];
   
   CGFloat itemY = [self statusBarHeight];
   CGFloat itemX = 0.0;
   
   if ((self.cornerPosition == PRStretchySideMenuCornerPositionTopRight) ||
       (self.cornerPosition == PRStretchySideMenuCornerPositionTopLeft)) {
      itemY += kBarViewsOffset + verticalIndex * itemView.frame.size.height;
   }
   
   if ((self.cornerPosition == PRStretchySideMenuCornerPositionBottomLeft) ||
       (self.cornerPosition == PRStretchySideMenuCornerPositionTopLeft)) {
      itemX = self.verticalSideMenuView.frame.size.width - itemView.frame.size.width;
      itemY += verticalIndex * itemView.frame.size.height;
   }
   
   itemView.frame = CGRectMake(itemX,
                               itemY,
                               itemView.frame.size.width,
                               itemView.frame.size.height);
   
   __weak PRStretchySideMenuView *wSelf = self;
   
   id actionBlock = ^(PRStretchySideMenuItemView *itemView) {
      [wSelf press:itemView];
   };
   
   [itemView setActionBlock:actionBlock];
   itemView.tag = index;
   return itemView;
}

- (PRStretchySideMenuItemView *)horizontalButtonFromItem:(PRStretchySideMenuItem *)item atIndex:(NSUInteger )index {
   PRStretchySideMenuItemView *itemView = [[PRStretchySideMenuItemView alloc] initWithSideMenuItem:item];
   
   CGFloat itemX = 10.0;
   CGFloat itemY = 0.0;
   
   CGFloat width = itemView.frame.size.width;
   CGFloat height = kBarViewsOffset;
   
   itemX += index * (itemView.frame.size.width + 10);
   
   if ((self.cornerPosition == PRStretchySideMenuCornerPositionTopRight) ||
       (self.cornerPosition == PRStretchySideMenuCornerPositionTopLeft)) {
      itemY = self.horizontalSideMenuView.frame.size.height - kBarViewsOffset;
   }
   
   if ((self.cornerPosition == PRStretchySideMenuCornerPositionBottomLeft) ||
       (self.cornerPosition == PRStretchySideMenuCornerPositionTopLeft)) {
      itemX += kBarViewsOffset;
   }
   
   itemView.frame = CGRectMake(itemX,
                               itemY,
                               width,
                               height);
   
   __weak PRStretchySideMenuView *wSelf = self;
   
   id actionBlock = ^(PRStretchySideMenuItemView *itemView) {
      [wSelf press:itemView];
   };
   
   [itemView setActionBlock:actionBlock];
   itemView.tag = index;
   return itemView;
}

#pragma mark - Helpers methods

- (void)addItemToItemsArray:(PRStretchySideMenuItem *)item {
   if (![self.items containsObject:item]) {
      self.items = [self.items arrayByAddingObjectsFromArray:@[item]];
   }
}

- (void)selectItem:(PRStretchySideMenuItem *)item itemView:(PRStretchySideMenuItemView *)itemView {
   [self.selectedItemView setSelectedStatys:NO];
   self.selectedItemView = itemView;
   [self.selectedItemView setSelectedStatys:YES];
   self.selectedItem = item;
}

- (CGFloat)statusBarHeight {
   
   if ([PRSystemHelper systemVersionIsGreaterThanOrEqualTo:@"7.0"]) {
      return kStatusBarHeight;
   } else {
      return 0.0;
   }
   
   return kStatusBarHeight;
}

#pragma mark - Interface

- (void)showMenuWithAnimation:(BOOL)animation {
   
   if ([self.delegate respondsToSelector:@selector(stretchySideMenuWillAppear:)]) {
      [self.delegate stretchySideMenuWillAppear:self];
   }
   
   __weak typeof(self) wSelf = self;
   
   void (^barAnimateBlock)() = ^{
      [wSelf showBarViews];
   };
   
   void (^completionBlock)(BOOL) = ^(BOOL finished) {
      if ([wSelf.delegate respondsToSelector:@selector(stretchySideMenuDidAppear:)]) {
         [wSelf.delegate stretchySideMenuDidAppear:wSelf];
      }
   };
   
   if (animation) {
      if ([PRSystemHelper systemVersionIsGreaterThanOrEqualTo:@"7.0"]) {
         [UIView animateWithDuration:0.5
                               delay:0.0
              usingSpringWithDamping:0.5
               initialSpringVelocity:9.0
                             options:UIViewAnimationOptionCurveEaseIn
                          animations:barAnimateBlock
                          completion:completionBlock];
      } else {
         [UIView animateWithDuration:0.3
                               delay:0.0
                             options:UIViewAnimationOptionCurveEaseIn
                          animations:barAnimateBlock
                          completion:completionBlock];
      }
      
   } else {
      barAnimateBlock();
      completionBlock(YES);
   }
   
}

- (void)hideMenuWithAnimation:(BOOL)animation {
   
   if ([self.delegate respondsToSelector:@selector(stretchySideMenuWillDisappear:)]) {
      [self.delegate stretchySideMenuWillDisappear:self];
   }
   
   __weak typeof(self) wSelf = self;
   
   void (^animationBlock)() = ^{
      [wSelf hideBarViews];
   };
   
   void (^completionBlock)(BOOL) = ^(BOOL finished) {
      if ([wSelf.delegate respondsToSelector:@selector(stretchySideMenuDidDisappear:)]) {
         [wSelf.delegate stretchySideMenuDidDisappear:self];
      }
   };
   
   if (animation) {
      [UIView animateWithDuration:0.3
                       animations:animationBlock
                       completion:completionBlock];
   } else {
      animationBlock();
      completionBlock(YES);
   }
   
}

- (void)addItemToVerticalSideMenu:(PRStretchySideMenuItem *)item atIndex:(NSUInteger)index {
   
   if ([self.verticalMenuItems containsObject:item]) {
      [self.verticalMenuItems replaceObjectAtIndex:index withObject:item];
      return;
   } else {
      [self.verticalMenuItems addObject:item];
   }
   
   PRStretchySideMenuItemView *itemView = [self verticalButtonFromItem:item atIndex:index];
   [self.verticalSideMenuView addSubview:itemView];
   [self layoutVerticalItems];
   [self addItemToItemsArray:item];
   
   if (!self.selectedItem) {
      [self selectItem:item itemView:itemView];
   }
   
}

- (void)addItemToHorizontalSideMenu:(PRStretchySideMenuItem *)item atIndex:(NSUInteger)index {
   
   if ([self.horizontalMenuItems containsObject:item]) {
      [self.horizontalMenuItems replaceObjectAtIndex:index withObject:item];
      return;
   } else {
      [self.horizontalMenuItems addObject:item];
   }
   
   PRStretchySideMenuItemView *itemView = [self horizontalButtonFromItem:item
                                                                 atIndex:index];
   [self.horizontalSideMenuView addSubview:itemView];
   [self layoutHorizontalItems];
   [self addItemToItemsArray:item];
   
   if (!self.selectedItem) {
      [self selectItem:item itemView:itemView];
   }
   
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
   if ([self.delegate respondsToSelector:@selector(stretchySideMenuDidTouch:)]) {
      [self.delegate stretchySideMenuDidTouch:self];
   }
}

@end
