//
//  UIViewController+tool.h
//  BoulevardRiskRealm
//
//  Created by jin fu on 13/02/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (tool)

- (NSString *)boulevardMainHostName;

- (BOOL)boulevardNeedShowBannerDescView;

- (void)boulevardShowAlertWithTitle:(NSString *)title message:(NSString *)message;
- (void)boulevardNavigateToViewController:(UIViewController *)viewController;
- (void)boulevardSetBackgroundColor:(UIColor *)color;
- (void)boulevardLogCurrentViewController;

@end

NS_ASSUME_NONNULL_END
