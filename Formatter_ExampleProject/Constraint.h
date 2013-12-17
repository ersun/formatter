//
//  Constraint.h
//  odev
//
//  Created by Umut Bozkurt on 09/12/13.
//  Copyright (c) 2013 Wissen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "RelationType.h"
#import "LayoutDirection.h"
#import "FormatterDefaults.h"
#import "SizeType.h"
#import "ConstraintPriority.h"
#import "SuperViewEdge.h"
#import "UIView+Name.h"

@interface Constraint : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) UIView *viewToBeConstrained;
@property (strong, nonatomic) UIView *constrainsToView;
@property (nonatomic) CGFloat size;
@property (nonatomic) CGFloat distance;
@property (nonatomic) enum LayoutDirection direction;
@property (nonatomic) enum RelationType relationType;
@property (nonatomic) enum SizeType sizeType;
@property (nonatomic) enum ConstraintPriority sizePriority;
@property (nonatomic) enum ConstraintPriority distancePriority;
@property (nonatomic) enum SuperViewEdge isConnectedToSuperViewEdge;
@property (strong,nonatomic) NSDictionary *variableBindingsOfViews;

-(id)copy;

-(void)setWorkspace:(UIViewController *)workspace;
-(void)setVariableBindings;
-(void)setViewNames;

-(id)initWithView:(UIView *)viewToBeConstrained constrainsToView:(UIView *)constrainsToView withSize:(CGFloat)size withDistance:(CGFloat)distance withDirection:(enum LayoutDirection)layoutDirection withRelation:(enum RelationType)relationType withSizeType:(enum SizeType)sizeType;
-(id)initWithView:(UIView *)viewToBeConstrained constrainsToSuperViewEdge:(enum SuperViewEdge)superViewEdge withSize:(CGFloat)size withDistance:(CGFloat)distance withRelation:(enum RelationType)relationType withSizeType:(enum SizeType)sizeType;

+(Constraint *)constraintView:(UIView *)viewToBeConstrained ToView:(UIView *)constrainsToView withSize:(CGFloat)size withDistance:(CGFloat)distance withDirection:(enum LayoutDirection)layoutDirection withRelation:(enum RelationType)relationType withSizeType:(enum SizeType)sizeType;
+(Constraint *)constraintView:(UIView *)viewToBeConstrained toSuperViewEdge:(enum SuperViewEdge)superViewEdge withSize:(CGFloat)size withDistance:(CGFloat)distance withRelation:(enum RelationType)relationType withSizeType:(enum SizeType)sizeType;
@end
