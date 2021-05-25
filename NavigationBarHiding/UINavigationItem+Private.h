//
//  UINavigationItem+Private.h
//  NavigationBarHiding
//
//  Created by Stephen Anthony on 23/05/2021.
//

@import UIKit;

@interface UINavigationItem (Private)

- (void)_setManualScrollEdgeAppearanceEnabled:(BOOL)enabled;
- (void)_setManualScrollEdgeAppearanceProgress:(CGFloat)progress;

@end
