//
//  CustomCell.m
//  FormatterSampleProject
//
//  Created by Wissen on 28/12/13.
//  Copyright (c) 2013 Umut Bozkurt. All rights reserved.
//

#import "CustomCell.h"
#import "Formatter.h"

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        Formatter *f = [[Formatter alloc] initWithWorkspace:self.contentView withController:self];
        
        self.label = [[UILabel alloc]init];
        self.view = [[UIView alloc]init];
        
        self.label.text = @"asdasd";
        self.view.backgroundColor = [UIColor redColor];
        
        [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.view];
        
        [f addConstraint:[Constraint constraintView:self.label
                                    toSuperViewEdge:SuperViewTopEdge
                                           withSize:40
                                       withDistance:10
                                       withRelation:RelationTypeEqualTo
                                       withSizeType:SizeTypeEqualTo]];
        
        [f addConstraint:[Constraint constraintView:self.view
                                             ToView:self.label
                                           withSize:40
                                       withDistance:10
                                      withDirection:LayoutDirectionHorizontal
                                       withRelation:RelationTypeEqualTo
                                       withSizeType:SizeTypeEqualTo]];
        
        [f addConstraint:[Constraint constraintView:self.view
                                    toSuperViewEdge:SuperViewTopEdge
                                           withSize:40
                                       withDistance:10
                                       withRelation:RelationTypeEqualTo
                                       withSizeType:SizeTypeEqualTo]];
        
        [f addConstraint:[Constraint constraintView:self.label
                                    toSuperViewEdge:SuperViewLeftEdge
                                           withSize:30
                                       withDistance:10
                                       withRelation:RelationTypeEqualTo
                                       withSizeType:SizeTypeEqualTo]];
        
        [f applyConstraints];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
