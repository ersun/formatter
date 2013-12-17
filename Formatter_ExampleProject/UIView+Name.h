//
//  UIView+Name.h
//
//
//  Created by Umut Bozkurt on 09/12/13.
//  
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIView (Name)

@property (strong, nonatomic) NSString *name;

-(void)setName:(NSString *)name;

@end
