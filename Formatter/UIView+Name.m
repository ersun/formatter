//
//  UIView+Name.m
//  
//
//  Created by Umut Bozkurt on 09/12/13.
//
//

#import "UIView+Name.h"

NSString *const nameKey = @"nameKey";

@implementation UIView (Name)

// http://www.davidhamrick.com/2012/02/12/Adding-Properties-to-an-Objective-C-Category.html

-(NSString *)name
{
    return objc_getAssociatedObject(self, &nameKey);
}

-(void)setName:(NSString *)name
{
    objc_setAssociatedObject(self, &nameKey, name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
