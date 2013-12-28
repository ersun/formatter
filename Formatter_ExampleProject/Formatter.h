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

-(id)initWithWorkspace:(UIView *)workspace;

-(NSString *)addConstraint:(Constraint *)constraint;

-(void)removeConstraint:(Constraint *)constraint;
-(void)removeConstraintByID:(NSString *)ID;

-(void)updateConstraint:(Constraint *)constraint;

-(void)applyConstraints;
-(void)applyConstraint:(Constraint *)constraint;

-(void)clearConstraintList;

-(Constraint *)getConstraintByID:(NSString *)ID;

@end
