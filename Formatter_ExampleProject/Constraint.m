//
//  Constraint.m
//
//
//  Created by Umut Bozkurt on 09/12/13.
//  
//

#import "Constraint.h"

@interface Constraint ()

#pragma mark Private Properties
@property (strong, nonatomic) UIViewController *workspace;

@end

@implementation Constraint

#pragma mark Public Methods

//--------GET/SET--------

-(void)setConstrainsToView:(UIView *)constrainsToView
{
    if (self.workspace)
    {
        NSMutableDictionary *varBindings = [self.variableBindingsOfViews mutableCopy];
        constrainsToView.name = [self getVariableName:constrainsToView];
        [varBindings setObject:constrainsToView forKey: constrainsToView.name];
        self.variableBindingsOfViews = varBindings;
    }
    
    _constrainsToView = constrainsToView;
}

-(void)setViewToBeConstrained:(UIView *)viewToBeConstrained
{
    if (self.workspace)
    {
        NSMutableDictionary *varBindings = [self.variableBindingsOfViews mutableCopy];
        viewToBeConstrained.name = [self getVariableName:viewToBeConstrained];
        [varBindings setObject:viewToBeConstrained forKey: viewToBeConstrained.name];
        self.variableBindingsOfViews = varBindings;
    }
    
    _viewToBeConstrained = viewToBeConstrained;
}

// setting variable bindings dictionary of views
-(void)setVariableBindings
{
    NSMutableDictionary *varBindings;
    
    if (self.variableBindingsOfViews)
        varBindings = [self.variableBindingsOfViews mutableCopy];
    else
        varBindings = [[NSMutableDictionary alloc]init];
    
    if (self.constrainsToView)
    {
        [varBindings setObject:self.constrainsToView forKey:[self getVariableName:self.constrainsToView]];
        _variableBindingsOfViews = varBindings;
    }
    if (self.viewToBeConstrained)
    {
        [varBindings setObject:self.viewToBeConstrained forKey:[self getVariableName:self.viewToBeConstrained]];
        _variableBindingsOfViews = varBindings;
    }
}

-(void)setViewNames
{
    if (self.workspace)
    {
        if (!self.constrainsToView.name)
            self.constrainsToView.name = [self getVariableName:self.constrainsToView];
        if (!self.viewToBeConstrained.name)
            self.viewToBeConstrained.name = [self getVariableName:self.viewToBeConstrained];
    }
}

-(id)copy
{
    Constraint *copy = [[Constraint alloc] init];
    
    copy.viewToBeConstrained = self.viewToBeConstrained;
    copy.constrainsToView = self.constrainsToView;
    copy.isConnectedToSuperViewEdge = self.isConnectedToSuperViewEdge;
    copy.sizePriority = self.sizePriority;
    copy.distancePriority = self.distancePriority;
    copy.relationType = self.relationType;
    copy.direction = self.direction;
    copy.distance = self.distance;
    copy.size = self.size;
    copy.sizeType = self.sizeType;
    copy.workspace = self.workspace;
    copy.isConnectedToSuperViewEdge = self.isConnectedToSuperViewEdge;
    copy.variableBindingsOfViews = self.variableBindingsOfViews;
    
    return copy;
}

#pragma mark Class Methods

+(Constraint *)constraintView:(UIView *)viewToBeConstrained ToView:(UIView *)constrainsToView withSize:(CGFloat)size withDistance:(CGFloat)distance withDirection:(enum LayoutDirection)layoutDirection withRelation:(enum RelationType)relationType withSizeType:(enum SizeType)sizeType
{
    return [[Constraint alloc]initWithView:viewToBeConstrained constrainsToView:constrainsToView withSize:size withDistance:distance withDirection:layoutDirection withRelation:relationType withSizeType:sizeType];
}

+(Constraint *)constraintView:(UIView *)viewToBeConstrained toSuperViewEdge:(enum SuperViewEdge)superViewEdge withSize:(CGFloat)size withDistance:(CGFloat)distance withRelation:(enum RelationType)relationType withSizeType:(enum SizeType)sizeType
{
    return [[Constraint alloc]initWithView:viewToBeConstrained constrainsToSuperViewEdge:superViewEdge withSize:size withDistance:distance withRelation:relationType withSizeType:sizeType];
}

#pragma mark Private Methods

//----------------------GETTING VARIABLE NAME------------------------
/*
 Returns nil if variable is not found
 Credits: http://stackoverflow.com/users/298166/hacksignal
          http://stackoverflow.com/questions/2484778/anyway-to-get-string-from-variable-name
 */

-(NSString *)getVariableName:(id)instanceVariable
{
    unsigned int numberOfInstanceVariables; //out Parameter
    NSString *variableName;
    Ivar *instanceVariables = class_copyIvarList(self.workspace.class, &numberOfInstanceVariables);
    // Ivar = instance variable
    
    for(int i = 0; i < numberOfInstanceVariables; i++)
    {
        Ivar currentInstanceVariable = instanceVariables[i];
        if ([object_getIvar(self.workspace, currentInstanceVariable) isEqual:instanceVariable])
        {
            variableName = [NSString stringWithUTF8String:ivar_getName(currentInstanceVariable)];
            break;
        }
    }
    
    free(instanceVariables);
    
    // erases "_" before instance variables to get properties' names too.
    
    return ([variableName characterAtIndex:0] == '_') ? [variableName substringFromIndex:1] : variableName;
}


#pragma mark Constructors

-(id)init
{
    self = [super init];
    if (self) {
        self.sizePriority = FormatterDefaultPriority;
        self.distancePriority = FormatterDefaultPriority;
        self.sizeType = SizeTypeEqualTo;
        self.relationType = RelationTypeEqualTo;
    }
    return self;
}

-(id)initWithView:(UIView *)viewToBeConstrained constrainsToView:(UIView *)constrainsToView withSize:(CGFloat)size withDistance:(CGFloat)distance withDirection:(enum LayoutDirection)layoutDirection withRelation:(enum RelationType)relationType withSizeType:(enum SizeType)sizeType
{
    self = [super init];
    if (self)
    {
        self.viewToBeConstrained = viewToBeConstrained;
        self.constrainsToView = constrainsToView;
        self.size = size;
        self.distance = distance;
        self.direction = layoutDirection;
        self.relationType = relationType;
        self.sizeType = sizeType;
        self.sizePriority = FormatterDefaultPriority;
        self.distancePriority = FormatterDefaultPriority;
        _ID = [NSString stringWithFormat:@"%@->%@",self.viewToBeConstrained.name,self.constrainsToView.name];
    }
    return self;
}

-(id)initWithView:(UIView *)viewToBeConstrained constrainsToSuperViewEdge:(enum SuperViewEdge)superViewEdge withSize:(CGFloat)size withDistance:(CGFloat)distance withRelation:(enum RelationType)relationType withSizeType:(enum SizeType)sizeType
{
    self = [super init];
    if (self)
    {
        self.viewToBeConstrained = viewToBeConstrained;
        self.isConnectedToSuperViewEdge = superViewEdge;
        self.size = size;
        self.distance = distance;
        self.relationType = relationType;
        self.sizeType = sizeType;
        self.sizePriority = FormatterDefaultPriority;
        self.distancePriority = FormatterDefaultPriority;
        if (superViewEdge == SuperViewTopEdge)
            _ID = [NSString stringWithFormat:@"%@->%@",self.viewToBeConstrained.name,@"TOP"];
        else if (superViewEdge == SuperViewBottomEdge)
            _ID = [NSString stringWithFormat:@"%@->%@",self.viewToBeConstrained.name,@"BOTTOM"];
        else if (superViewEdge == SuperViewLeftEdge)
            _ID = [NSString stringWithFormat:@"%@->%@",self.viewToBeConstrained.name,@"LEFT"];
        else
            _ID = [NSString stringWithFormat:@"%@->%@",self.viewToBeConstrained.name,@"RIGHT"];
    }
    return self;
}

@end
