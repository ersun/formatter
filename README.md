Formatter
=========

A simple library for Visual Format Language, Auto Layout. 

_Samples:_
<pre>
*Add constraint to another view:*
[formatter addConstraint:[Constraint constraintView:sampleView
                                                 ToView:sampleView2
                                               withSize:40
                                           withDistance:3
                                          withDirection:LayoutDirectionVertical
                                           withRelation:RelationTypeEqualTo
                                           withSizeType:SizeTypeEqualTo]];

*Add constraint to super view:*
[formatter addConstraint:[Constraint constraintView:sampleView
                                    toSuperViewEdge:SuperViewTopEdge 
                                           withSize:300 
                                       withDistance:20 
                                       withRelation:RelationTypeEqualTo 
                                       withSizeType:SizeTypeEqualTo]];
*Remove constraint:*
[formatter removeConstraintByID:someID];

*Mofidy existing constraint:*
Constraint *someConstraint = [formatter getConstraintByID:@"V:sampleView1->sampleView2"];
someConstraint.distance += 15;
[formatter updateConstraint:someConstraint];

*Apply constraints after adding, modifying or removing:*
[formatter applyConstraints];
</pre>
