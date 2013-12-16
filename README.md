Formatter
=========

A simple library for Visual Format Language, Auto Layout. 

Samples:
<pre>
<strong>Add constraint to another view:</strong>
[formatter addConstraint:[Constraint constraintView:sampleView
                                                 ToView:sampleView2
                                               withSize:40
                                           withDistance:3
                                          withDirection:LayoutDirectionVertical
                                           withRelation:RelationTypeEqualTo
                                           withSizeType:SizeTypeEqualTo]];

<strong>Add constraint to super view:</strong>
[formatter addConstraint:[Constraint constraintView:sampleView
                                    toSuperViewEdge:SuperViewTopEdge 
                                           withSize:300 
                                       withDistance:20 
                                       withRelation:RelationTypeEqualTo 
                                       withSizeType:SizeTypeEqualTo]];
<strong>Remove constraint:</strong>
[formatter removeConstraintByID:someID];

<strong>Mofidy existing constraint:</strong>
Constraint *someConstraint = [formatter getConstraintByID:@"V:sampleView1->sampleView2"];
someConstraint.distance += 15;
[formatter updateConstraint:someConstraint];

<strong>Apply constraints after adding, modifying or removing:</strong>
[formatter applyConstraints];
</pre>
