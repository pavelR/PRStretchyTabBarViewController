//
// PRSystemHelper.m
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

#import "PRSystemHelper.h"

#define SYSTEM_VERSION_LESS_THAN(v)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)

@implementation PRSystemHelper

+(BOOL)systemVersionIsEqualTo:(NSString *)systemVersion {
   return ([self compareSystemVersion:systemVersion] == NSOrderedSame);
}

+(BOOL)systemVersionIsGreaterThan:(NSString *)systemVersion {
   return ([self compareSystemVersion:systemVersion] == NSOrderedDescending);
}

+(BOOL)systemVersionIsGreaterThanOrEqualTo:(NSString *)systemVersion {
   return ([self compareSystemVersion:systemVersion] != NSOrderedAscending);
}

+(BOOL)systemVersionIsLessThan:(NSString *)systemVersion {
   return ([self compareSystemVersion:systemVersion] == NSOrderedAscending);
}

+(BOOL)systemVersionIsLessThanOrEqualTo:(NSString *)systemVersion {
   return ( [self compareSystemVersion:systemVersion] != NSOrderedDescending);
}

+(NSComparisonResult)compareSystemVersion:(NSString *)systemVersion {
   return [[[UIDevice currentDevice] systemVersion] compare:systemVersion
                                                    options:NSNumericSearch];
}

@end

@implementation UIColor (RandomColor)

+(UIColor *)randomColor {
   return [UIColor colorWithRed:((rand() % 255)/255.0)
                          green:((rand() % 255)/255.0)
                           blue:((rand() % 255)/255.0)
                          alpha:1.0];
}

@end

@implementation UIImage(Overlay)

- (UIImage *)imageWithColor:(UIColor *)color {
   UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
   CGContextRef context = UIGraphicsGetCurrentContext();
   CGContextTranslateCTM(context, 0, self.size.height);
   CGContextScaleCTM(context, 1.0, -1.0);
   CGContextSetBlendMode(context, kCGBlendModeNormal);
   CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
   CGContextClipToMask(context, rect, self.CGImage);
   [color setFill];
   CGContextFillRect(context, rect);
   UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
   return newImage;
}

@end