//
//  Formatter.h
//
//
//  Created by Umut Bozkurt on 08/12/13.
//
//

#import <Foundation/Foundation.h>
#import "Constraint.h"

@interface Formatter : NSObject

@property (strong,nonatomic) UIView *workspace;
@property (strong,nonatomic) UIResponder *controller;

-(id)initWithWorkspace:(UIView *)workspace withController:(UIResponder *)controller;

-(NSString *)addConstraint:(Constraint *)constraint;
-(void)addConstraints:(Constraint *)constraint, ... NS_REQUIRES_NIL_TERMINATION;

-(void)removeConstraint:(Constraint *)constraint;
-(void)removeConstraintByID:(NSString *)ID;

-(void)updateConstraint:(Constraint *)constraint;

-(void)applyConstraints;
-(void)applyConstraint:(Constraint *)constraint;
-(void)animateConstraint:(Constraint *)constraint withDuration:(NSTimeInterval)duration withOptions:(UIViewAnimationOptions)options;

-(void)clearConstraintList;

-(Constraint *)getConstraintByID:(NSString *)ID;

@end
