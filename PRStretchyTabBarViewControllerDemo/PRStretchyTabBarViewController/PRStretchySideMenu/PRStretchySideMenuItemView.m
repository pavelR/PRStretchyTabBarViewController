//
// PRStretchySideMenuItemView.m
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

#import "PRStretchySideMenuItemView.h"
#import "PRStretchySideMenuItem.h"

#import "PRSystemHelper.h"

@interface PRStretchySideMenuItemView ()

@property (nonatomic, strong) PRStretchySideMenuItem *item;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *itemButton;

@end

@implementation PRStretchySideMenuItemView

- (id)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
   if (self) {
      // Initialization code
   }
   return self;
}

#pragma mark - Interface

- (id)initWithSideMenuItem:(PRStretchySideMenuItem *)item {
   
   CGRect rect = CGRectMake(0, 0, 40, 40);
   
   if (self = [super initWithFrame:rect]) {
      self.item = item;
      self.autoresizesSubviews = YES;
      self.clipsToBounds = NO;
      self.normalTintColor = [UIColor whiteColor];
      self.selectedTintColor = [UIColor blueColor];
   }
   
   return self;
}


- (void)willMoveToSuperview:(UIView *)newSuperview {
   [super willMoveToSuperview:newSuperview];
   
   [self.itemButton addTarget:self
                       action:@selector(pressesButtonItem:)
             forControlEvents:UIControlEventTouchUpInside];
   
   [self.imageView setImage:[self.item.image imageWithColor:self.normalTintColor]];
   self.titleLabel.text = self.item.title;
}

- (UIButton *)itemButton {
   if (!_itemButton) {
      _itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
      _itemButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
      [_itemButton setBackgroundColor:[UIColor clearColor]];
      _itemButton.autoresizesSubviews = YES;
      _itemButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      [self addSubview:_itemButton];
   }
   
   return _itemButton;
}

- (UILabel *)titleLabel {
   
   if (!_titleLabel) {
      
      CGRect frame = CGRectNull;
      
      _titleLabel = [[UILabel alloc] initWithFrame:frame];
      _titleLabel.textColor = self.normalTintColor;
      _titleLabel.backgroundColor = [UIColor clearColor];
      _titleLabel.textAlignment = NSTextAlignmentCenter;
      _titleLabel.minimumScaleFactor = 2.0;
      _titleLabel.adjustsFontSizeToFitWidth = YES;
      [_titleLabel setFont:[UIFont systemFontOfSize:15.0]];
      _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                     UIViewAutoresizingFlexibleRightMargin |
                                     UIViewAutoresizingFlexibleLeftMargin;
      
      [self layoutTitleLabel];
      
      [self addSubview:_titleLabel];
   }
   
   return _titleLabel;
}

- (UIImageView *)imageView {
   
   if (!self.item.image) {
      return nil;
   }
   
   if (!_imageView) {
      CGRect frame = CGRectMake(0, 0, 30, 30);
      
      _imageView = [[UIImageView alloc] initWithFrame:frame];
      _imageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
                                    UIViewAutoresizingFlexibleLeftMargin;
      _imageView.contentMode = UIViewContentModeScaleToFill;
      
      [self layoutImageView];
      
      [self addSubview:_imageView];
   }
   
   return _imageView;
}

- (void)setSelectedStatys:(BOOL)isSelect {
   
   if (isSelect) {
      if (self.item.selectedImage) {
         self.imageView.image = self.item.selectedImage;
      }
      
      self.imageView.image = [self.item.image imageWithColor:self.selectedTintColor];
      self.titleLabel.textColor = self.selectedTintColor;
   } else {
      self.imageView.image = [self.item.image imageWithColor:self.normalTintColor];
      self.titleLabel.textColor = self.normalTintColor;
   }
   
}

#pragma mark - Overloaded UIView methods

- (void)layoutSubviews {
   [super layoutSubviews];
   [self layoutImageView];
   [self resizeTitleFont];
   [self layoutTitleLabel];
}

#pragma mark - Layout meyhods

- (void)resizeTitleFont {
   CGFloat fontSize = 20;
   while (fontSize > 0.0)
   {
      CGSize maxSize = CGSizeMake(self.titleLabel.frame.size.width, 10000);
      
      CGSize size = [self.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:fontSize]
                                     constrainedToSize:maxSize
                                         lineBreakMode:NSLineBreakByWordWrapping];
      
      if (size.height <= self.titleLabel.frame.size.height) break;
      fontSize -= 1.0;
   }
   
   self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
}

- (void)layoutImageView {
   CGFloat x = 0;
   CGFloat y = 0;
   CGFloat width = 0;
   CGFloat height = 0;
   
   if (self.item.title.length) {
      width = 22;
      height = 22;
      x = (self.frame.size.width - width)/2;
      y = (self.frame.size.height - height - self.titleLabel.frame.size.height)/2;
   } else {
      width = 33;
      height = 33;
      x = (self.frame.size.width - width)/2;
      y = (self.frame.size.height - height)/2;
   }
   
   if (y < 0) {
      y = 0;
   }
   
   CGRect frame = CGRectMake(x, y, width, height);
   
   if (height >= self.frame.size.height) {
      frame = CGRectNull;
   }
   
   if ((y + height + 1 + self.titleLabel.frame.size.height) >= self.frame.size.height) {
      frame = CGRectNull;
   }
   
   _imageView.frame = frame;
}

- (void)layoutTitleLabel {
   CGRect frame = CGRectNull;
   
   if (self.item.title.length) {
      CGFloat x = 2;
      CGFloat y = self.imageView.frame.origin.y + self.imageView.frame.size.height + 1;
      
      CGFloat width = self.frame.size.width - 4;
      CGFloat height = 15;
      
      if (CGRectIsNull(self.imageView.frame) || (!self.imageView)) {
         y = (self.frame.size.height - height)/2;
      }
      
      frame = CGRectMake(x, y, width, height);
   }
   
   _titleLabel.frame = frame;
}

#pragma mark - Actions

- (void)pressesButtonItem:(UIButton *)itemButton {
   self.actionBlock(self);
}

@end
