Formatter
=========

A simple wrapper for Visual Format Language. 

<h4>Samples:</h4>
<pre>
<strong>Add constraint to another view:</strong>
[formatter addConstraint:[Constraint constraintView:<i>sampleView</i>
                                             ToView:<i>sampleView2</i>
                                           withSize:<i>40</i>
                                       withDistance:<i>3</i>
                                      withDirection:<i>LayoutDirectionVertical</i>
                                       withRelation:<i>RelationTypeEqualTo</i>
                                       withSizeType:<i>SizeTypeEqualTo</i>]];

<strong>Add constraint to super view:</strong>
[formatter addConstraint:[Constraint constraintView:<i>sampleView</i>
                                    toSuperViewEdge:<i>SuperViewTopEdge</i> 
                                           withSize:<i>300</i> 
                                       withDistance:<i>20</i> 
                                       withRelation:<i>RelationTypeEqualTo</i> 
                                       withSizeType:<i>SizeTypeEqualTo</i>]];
<strong>Remove constraint:</strong>
[formatter removeConstraintByID:<i>someID</i>];

<strong>Mofidy existing constraint:</strong>
Constraint *someConstraint = [formatter getConstraintByID:<i>@"V:sampleView1->sampleView2"</i>];
someConstraint.distance += 15;
[formatter updateConstraint:<i>someConstraint</i>];

<strong>Apply constraints after adding, modifying or removing:</strong>
[formatter applyConstraints];
</pre>
