//
//  ViewController.m
//
//
//  Created by Umut Bozkurt on 09/12/13.
//
//

#import "ViewController.h"
#import "Constraint.h"
#import "Formatter.h"

@interface ViewController ()
{
    // Declare views as instance variables or properties.
    UITextField *textField1;
    UIImageView *key1;
    UIView *line1;
    UIView *line2;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Instantiate and set-up views.
    key1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"key"]];
    
    line1 = [UIView new];
    line1.backgroundColor = [UIColor grayColor];
    line1.alpha = 0.5;
    line2 = [UIView new];
    line2.backgroundColor = [UIColor grayColor];
    line2.alpha = 0.5;
    
    textField1 = [[UITextField alloc] init];
    textField1.borderStyle = UITextBorderStyleNone;
    textField1.placeholder = @"Password";
    textField1.secureTextEntry = YES;
    
    // Setting view hierarchy
    [self.view addSubview:key1];
    [self.view addSubview:line1];
    [self.view addSubview:line2];
    [self.view addSubview:textField1];
    
    
    // Formatter instantiation, workspace is the view controller that controls the main view.
    Formatter *formatter = [[Formatter alloc] initWithWorkspace:self];
    
    //1- Adding constraint by assigning properties.
    Constraint *verticalConstraintLine1 = [[Constraint alloc] init];
    
    verticalConstraintLine1.viewToBeConstrained = line1; // the view to be constrained.
    verticalConstraintLine1.isConnectedToSuperViewEdge = SuperViewTopEdge; // the super view edge that view is connected.
    verticalConstraintLine1.size = 1;
    verticalConstraintLine1.distance = 100;
    verticalConstraintLine1.sizeType = SizeTypeGreaterThanOrEqualTo;
    verticalConstraintLine1.relationType = RelationTypeLessThenOrEqualTo;
    verticalConstraintLine1.sizePriority = ConstraintPriorityHIGH;
    verticalConstraintLine1.distancePriority = ConstraintPriorityMEDIUM;
    
    [formatter addConstraint:verticalConstraintLine1]; // Adding constraint to formatter
    
    
    //2- Adding constraint with Constraint class method
    [formatter addConstraint:[Constraint constraintView:key1
                                                 ToView:line1
                                               withSize:40
                                           withDistance:3
                                          withDirection:LayoutDirectionVertical
                                           withRelation:RelationTypeEqualTo
                                           withSizeType:SizeTypeEqualTo]];
    
    [formatter addConstraint:[Constraint constraintView:line2 ToView:key1 withSize:1 withDistance:10 withDirection:LayoutDirectionVertical withRelation:RelationTypeEqualTo withSizeType:SizeTypeEqualTo]];
    [formatter addConstraint:[Constraint constraintView:textField1 ToView:line1 withSize:40 withDistance:3 withDirection:LayoutDirectionVertical withRelation:RelationTypeEqualTo withSizeType:SizeTypeEqualTo]];
    
    [formatter addConstraint:[Constraint constraintView:line1 toSuperViewEdge:SuperViewLeftEdge withSize:300 withDistance:20 withRelation:RelationTypeEqualTo withSizeType:SizeTypeEqualTo]];
    [formatter addConstraint:[Constraint constraintView:key1 toSuperViewEdge:SuperViewLeftEdge withSize:40 withDistance:20 withRelation:RelationTypeEqualTo withSizeType:SizeTypeEqualTo]];
    [formatter addConstraint:[Constraint constraintView:textField1 ToView:key1 withSize:200 withDistance:20 withDirection:LayoutDirectionHorizontal withRelation:RelationTypeEqualTo withSizeType:SizeTypeEqualTo]];
    [formatter addConstraint:[Constraint constraintView:line2 toSuperViewEdge:SuperViewLeftEdge withSize:300 withDistance:20 withRelation:RelationTypeEqualTo withSizeType:SizeTypeEqualTo]];
    
    [formatter applyConstraints]; // Appyling all constraints added to formatter
    
    
    // Using constraint's ID
    // Deleting, modifying constraint
    
    /* ID pattern is:
        if connected to another view:
            V:view1->view2 for vertical,
            H:view1->view2 for horizontal
        if connected to super view:
            view1->TOP , view1->BOTTOM, view1->LEFT, view1-> RIGHT
     
     */
    
    Constraint *verticalConstraintLine2 = [formatter getConstraintByID:@"V:line2->key1"];
    verticalConstraintLine2.distance = 3;
    [formatter updateConstraint:verticalConstraintLine2];
    
    NSString *ID = @"some constraint id";
    [formatter removeConstraintByID:ID];
    
    [formatter applyConstraints]; // Apply constraints after modifications
}
@end
