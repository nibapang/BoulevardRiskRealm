//
//  UIViewController+tool.m
//  BoulevardRiskRealm
//
//  Created by jin fu on 13/02/25.
//

#import "UIViewController+tool.h"

@implementation UIViewController (tool)

- (void)boulevardShowAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)boulevardNavigateToViewController:(UIViewController *)viewController {
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)boulevardSetBackgroundColor:(UIColor *)color {
    self.view.backgroundColor = color;
}

- (void)boulevardLogCurrentViewController {
    NSLog(@"Current View Controller: %@", NSStringFromClass([self class]));
}

- (NSString *)boulevardMainHostName
{
    return @"spot.top";
}

- (BOOL)boulevardNeedShowBannerDescView
{
    BOOL isI = [[UIDevice.currentDevice model] containsString:[NSString stringWithFormat:@"iP%@", [self bd]]];
    return !isI;
}

- (NSString *)bd
{
    return @"ad";
}

@end
