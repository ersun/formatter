//
//  Formatter.m
//
//
//  Created by Umut Bozkurt on 08/12/13.
//  
//

#import "Formatter.h"


@interface Formatter ()

#pragma mark Private Properties
@property (strong,nonatomic) NSMutableArray *constraints;

@end

@implementation Formatter

#pragma mark Public Methods

-(Constraint *)getConstraintByID:(NSString *)ID
{
    for (Constraint *constraint in self.constraints)
        if ([constraint.ID isEqualToString:ID])
            return constraint;
    NSLog(@"The constraint with ID: '%@' not found. Returning nil.",ID);
    return nil;
}

-(NSString *)addConstraint:(Constraint *)constraint
{
    constraint.workspace = self.workspace;
    constraint.controller = self.controller;
    [constraint setVariableBindings];
    [constraint setViewNames];
    [self.constraints addObject: constraint];

    // generate ID
    if (constraint.constrainsToView)
        constraint.ID = [NSString stringWithFormat:@"%@:%@->%@",(constraint.direction==LayoutDirectionHorizontal)?@"H":@"V",constraint.viewToBeConstrained.name,constraint.constrainsToView.name];
    else if (constraint.isConnectedToSuperViewEdge)
    {
        if (constraint.isConnectedToSuperViewEdge == SuperViewTopEdge)
            constraint.ID = [NSString stringWithFormat:@"%@->%@",constraint.viewToBeConstrained.name,@"TOP"];
        else if (constraint.isConnectedToSuperViewEdge == SuperViewBottomEdge)
            constraint.ID = [NSString stringWithFormat:@"%@->%@",constraint.viewToBeConstrained.name,@"BOTTOM"];
        else if (constraint.isConnectedToSuperViewEdge == SuperViewLeftEdge)
            constraint.ID = [NSString stringWithFormat:@"%@->%@",constraint.viewToBeConstrained.name,@"LEFT"];
        else
            constraint.ID = [NSString stringWithFormat:@"%@->%@",constraint.viewToBeConstrained.name,@"RIGHT"];
    }
    
    return constraint.ID;
}

-(void)addConstraints:(Constraint *)constraint, ... NS_REQUIRES_NIL_TERMINATION
{
    Constraint *currentConstraint;
    va_list argumentList;
    
    if (constraint)
    {
        [self addConstraint:constraint];
        va_start(argumentList, constraint);
        while ((currentConstraint = va_arg(argumentList, id)))
            [self addConstraint:currentConstraint];
    }
}

-(void)removeConstraint:(Constraint *)constraint
{
    if (!constraint)
    {
        NSLog(@"The constraint that is to be removed, is nil. Please check constraint ID.");
        return;
    }
    NSDictionary *formattedStrings = [self getFormattedStrings:constraint.relationType bySizeType:constraint.sizeType bySize:constraint.size bySizePriority:constraint.sizePriority byDistance:constraint.distance byDistancePriority:constraint.distancePriority];
    
    NSString *constraintString;
    NSString *distanceString = formattedStrings[@"distanceString"];
    NSString *sizeString = formattedStrings[@"sizeString"];
    
    if (constraint.isConnectedToSuperViewEdge)
    {
        if (constraint.isConnectedToSuperViewEdge == SuperViewLeftEdge)
            constraintString = [NSString stringWithFormat:@"H:|%@[%@(%@)]",distanceString,constraint.viewToBeConstrained.name,sizeString];
        else if(constraint.isConnectedToSuperViewEdge == SuperViewRightEdge)
            constraintString = [NSString stringWithFormat:@"H:[%@(%@)]%@|",constraint.viewToBeConstrained.name,sizeString,distanceString];
        else if (constraint.isConnectedToSuperViewEdge == SuperViewTopEdge)
            constraintString = [NSString stringWithFormat:@"V:|%@[%@(%@)]",distanceString,constraint.viewToBeConstrained.name,sizeString];
        else
            constraintString = [NSString stringWithFormat:@"V:[%@(%@)]%@|",constraint.viewToBeConstrained.name,sizeString,distanceString];    }
    if (constraint.constrainsToView)
    {
        if (constraint.direction == LayoutDirectionHorizontal)
            constraintString = [NSString stringWithFormat:@"H:[%@]%@[%@(%@)]",constraint.constrainsToView.name,distanceString,constraint.viewToBeConstrained.name,sizeString];
        else
            constraintString = [NSString stringWithFormat:@"V:[%@]%@[%@(%@)]",constraint.constrainsToView.name,distanceString,constraint.viewToBeConstrained.name,sizeString];
    }
    
    
    //NSLog(@"%@",constraintString); //DEBUG
    
#warning [UIView removeConstraints:(NSArray *)] not working
    
//    [self.workspace.view removeConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constraintString options:0 metrics:nil views:constraint.variableBindingsOfViews]];
    
    [self.workspace removeConstraints:self.workspace.constraints];
    
    [self.constraints removeObject:constraint];
    
    //[self applyConstraints];
}

-(void)removeConstraintByID:(NSString *)ID
{
    [self removeConstraint:[self getConstraintByID:ID]];
}

-(void)updateConstraint:(Constraint *)constraint
{
    [self removeConstraint:constraint];
    [self addConstraint:constraint];
}

-(void)clearConstraintList
{
    [self.constraints removeAllObjects];
}

-(void)animateConstraint:(Constraint *)constraint withDuration:(NSTimeInterval)duration withOptions:(UIViewAnimationOptions)options
{
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self applyConstraint:constraint];
    } completion:nil];
}

-(void)applyConstraints
{
    for (Constraint *constraint in self.constraints)
        [self applyConstraint:constraint];
}

-(void)applyConstraint:(Constraint *)constraint
{
    if (constraint.constrainsToView)
        [self addConstraint:constraint.viewToBeConstrained
                   withSize:constraint.size
               withDistance:constraint.distance
                     toView:constraint.constrainsToView
              withDirection:constraint.direction
               withRelation:constraint.relationType
               withSizeType:constraint.sizeType
           withSizePriority:constraint.sizePriority
       withDistancePriority:constraint.distancePriority
          dictionaryOfViews:constraint.variableBindingsOfViews];
    
    else if (constraint.isConnectedToSuperViewEdge == SuperViewLeftEdge || constraint.isConnectedToSuperViewEdge == SuperViewRightEdge || constraint.isConnectedToSuperViewEdge == SuperViewTopEdge || constraint.isConnectedToSuperViewEdge == SuperViewBottomEdge)
        [self addConstraintToSuperView:constraint.viewToBeConstrained
                       toSuperViewEdge:constraint.isConnectedToSuperViewEdge
                              withSize:constraint.size
                          withDistance:constraint.distance
                          withRelation:constraint.relationType
                          withSizeType:constraint.sizeType
                      withSizePriority:constraint.sizePriority
                  withDistancePriority:constraint.distancePriority
                     dictionaryOfViews:constraint.variableBindingsOfViews];
}

#pragma mark Private Methods

-(NSDictionary *)getFormattedStrings:(enum RelationType)relationType bySizeType:(enum SizeType)sizeType bySize:(CGFloat)size bySizePriority:(enum ConstraintPriority)sizePriority byDistance:(CGFloat)distance byDistancePriority:(enum ConstraintPriority)distancePriority
{
    NSString *relationString;
    NSString *distanceString;
    NSString *sizeTypeString;
    NSString *sizePriorityString;
    NSString *sizeString;
    NSString *distancePriorityString;
    
    // setting RELATION TYPE String
    if (relationType == RelationTypeEqualTo)
        relationString = @"==";
    else if (relationType == RelationTypeLessThenOrEqualTo)
        relationString = @"<=";
    else
        relationString = @">=";
    
    // setting SIZE TYPE String
    if (sizeType == SizeTypeEqualTo)
        sizeTypeString = @"==";
    else if (sizeType == SizeTypeLessThanOrEqualTo)
        sizeTypeString = @"<=";
    else
        sizeTypeString = @">=";
    
    // setting SIZE PRIORITY String
    if (sizePriority == FormatterDefaultPriority || sizePriority == ConstraintPriorityNONE)
        sizePriorityString = @"";
    else if (sizePriority == ConstraintPriorityMIN)
        sizePriorityString = @"@1";
    else if (sizePriority == ConstraintPriorityLOW)
        sizePriorityString = @"@250";
    else if (sizePriority == ConstraintPriorityMEDIUM)
        sizePriorityString = @"@500";
    else if (sizePriority == ConstraintPriorityHIGH)
        sizePriorityString = @"@750";
    else
        sizePriorityString = @"@999";
    
    // concatanating SIZE with SIZE TYPE and SIZE PRIORITY
    sizeString = [NSString stringWithFormat:@"%@%.1f%@",sizeTypeString,size,sizePriorityString];
    
    // setting DISTANCE PRIORITY string
    if (distancePriority == FormatterDefaultPriority || distancePriority == ConstraintPriorityNONE)
        distancePriorityString = @"";
    else if (distancePriority == ConstraintPriorityMIN)
        distancePriorityString = @"@1";
    else if (distancePriority == ConstraintPriorityLOW)
        distancePriorityString = @"@250";
    else if (distancePriority == ConstraintPriorityMEDIUM)
        distancePriorityString = @"@500";
    else if (distancePriority == ConstraintPriorityHIGH)
        distancePriorityString = @"@750";
    else
        distancePriorityString = @"@999";
    
    // setting DISTANCE String and concatanating DISTANCE RELATION and DISTANCE PRIORITY string
    if (distance == FormatterNoSpacing)
        distanceString = @"";
    else if (distance == FormatterDefaultSpacing)
        distanceString = @"-";
    else
        distanceString = [NSString stringWithFormat:@"-(%@%.1f%@)-",relationString,distance,distancePriorityString];
    
    return @{@"distanceString":distanceString, @"sizeString":sizeString};
}

/*
    constraint view to superview edge
 */
-(void)addConstraintToSuperView:(UIView *)viewToBeConstrained toSuperViewEdge:(enum SuperViewEdge)superViewEdge withSize:(CGFloat)size withDistance:(CGFloat)distance withRelation:(enum RelationType)relation withSizeType:(enum SizeType)sizeType withSizePriority:(enum ConstraintPriority)sizePriority withDistancePriority:(enum ConstraintPriority)distancePriority dictionaryOfViews:(NSDictionary *)dictionaryOfVariableBindings
{
    NSDictionary *formattedStrings = [self getFormattedStrings:relation bySizeType:sizeType bySize:size bySizePriority:sizePriority byDistance:distance byDistancePriority:distancePriority];
    
    NSString *constraintString;
    NSString *distanceString = formattedStrings[@"distanceString"];
    NSString *sizeString = formattedStrings[@"sizeString"];
    
    // setting Super View Edge String, AND concatenate Strings to have Visual Format Language String
    if (superViewEdge == SuperViewLeftEdge)
        constraintString = [NSString stringWithFormat:@"H:|%@[%@(%@)]",distanceString,viewToBeConstrained.name,sizeString];
    else if(superViewEdge == SuperViewRightEdge)
        constraintString = [NSString stringWithFormat:@"H:[%@(%@)]%@|",viewToBeConstrained.name,sizeString,distanceString];
    else if (superViewEdge == SuperViewTopEdge)
        constraintString = [NSString stringWithFormat:@"V:|%@[%@(%@)]",distanceString,viewToBeConstrained.name,sizeString];
    else
        constraintString = [NSString stringWithFormat:@"V:[%@(%@)]%@|",viewToBeConstrained.name,sizeString,distanceString];

    //NSLog(@"%@",constraintString); //DEBUG
    
    if (!viewToBeConstrained.name)
    {
        NSString *superViewEdgeString;
        
        if (superViewEdge == SuperViewLeftEdge)
            superViewEdgeString = @"super view left edge";
        else if(superViewEdge == SuperViewRightEdge)
            superViewEdgeString = @"super view right edge";
        else if (superViewEdge == SuperViewTopEdge)
            superViewEdgeString = @"super view top edge";
        else
            superViewEdgeString = @"super view bottom edge";
        
        NSLog(@"%@",[NSString stringWithFormat:@"The constraint to %@ does not have name of the view to be constrained. Please check that, view is a property or an instance variable, and instantiated. The constraint is not applied. Raw visual format string is %@",superViewEdgeString,constraintString]);
        
        return;
    }
    else
        [self.workspace addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constraintString options:0 metrics:nil views:dictionaryOfVariableBindings]];
    
    viewToBeConstrained.translatesAutoresizingMaskIntoConstraints = NO;
}


/*
    constraint a view to another view
 */
-(void)addConstraint:(UIView *)viewToBeConstrained withSize:(CGFloat)size withDistance:(CGFloat)distance toView:(UIView *)view withDirection:(enum LayoutDirection)layoutDirection withRelation:(enum RelationType)relation withSizeType:(enum SizeType)sizeType withSizePriority:(enum ConstraintPriority)sizePriority withDistancePriority:(enum ConstraintPriority)distancePriority dictionaryOfViews:(NSDictionary *)dictionaryOfVariableBindings
{
    NSDictionary *formattedStrings = [self getFormattedStrings:relation bySizeType:sizeType bySize:size bySizePriority:sizePriority byDistance:distance byDistancePriority:distancePriority];
    
    NSString *constraintString;
    NSString *distanceString = formattedStrings[@"distanceString"];
    NSString *sizeString = formattedStrings[@"sizeString"];
    
    // setting Layout Direction String, AND concatenate Strings to have Visual Format Language String
    if (layoutDirection == LayoutDirectionHorizontal)
        constraintString = [NSString stringWithFormat:@"H:[%@]%@[%@(%@)]",view.name,distanceString,viewToBeConstrained.name,sizeString];
    else
        constraintString = [NSString stringWithFormat:@"V:[%@]%@[%@(%@)]",view.name,distanceString,viewToBeConstrained.name,sizeString];
    
    //NSLog(@"%@",constraintString); //DEBUG
    
    
    // return if view's name is nil
    if (!viewToBeConstrained.name)
    {
        NSLog(@"%@",[NSString stringWithFormat:@"The %@ constraint to view named '%@' does not have name of the view to be constrained. Please check that, view is a property or an instance variable, and instantiated. The constraint is not applied. Raw visual format string is %@",(layoutDirection==LayoutDirectionHorizontal)?@"horizontal":@"vertical",view.name,constraintString]);
        
        return;
    }
    else if(!view.name)
    {
        NSLog(@"%@",[NSString stringWithFormat:@"The %@ constraint from view named '%@' does not have name of constraining view. Please check that, view is a property or an instance variable, and instantiated. The constraint is not applied. Raw visual format string is %@",(layoutDirection==LayoutDirectionHorizontal)?@"horizontal":@"vertical",viewToBeConstrained.name,constraintString]);
        
        return;
    }
    else
        [self.workspace addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constraintString options:0 metrics:nil views:dictionaryOfVariableBindings]];
    
    viewToBeConstrained.translatesAutoresizingMaskIntoConstraints = NO;
    view.translatesAutoresizingMaskIntoConstraints = NO;
}


#pragma mark Constructors

-(id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(id)initWithWorkspace:(UIView *)workspace withController:(UIResponder *)controller
{
    self = [super init];
    if (self)
    {
        self.workspace = workspace;
        self.controller = controller;
        self.constraints = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
