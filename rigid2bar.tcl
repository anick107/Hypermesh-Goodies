# Transform RBE2 elements to CBAR
# Typical usecase: thermo-elastic analysis
# 1D -> elem types -> BAR2 = CBAR

set defaultProperty 0
set defaultPin 0
set defaultVector 1
set createTags 1

*createmarkpanel elems 1 "Please select the Rigidlink elements to tranform into BAR2"
foreach eid [hm_getmark elems 1] {
	
	set dependentNodes [hm_getentityarray elements $eid dependentnodes]
	set independentNode  [lindex [hm_getentityarray elements $eid nodes] 0]

	# get coordinates of the independent node
	set non_zero_length 0
	set coordX1 [hm_getentityvalue NODE $independentNode "x" 0]
	set coordY1 [hm_getentityvalue NODE $independentNode "y" 0]
	set coordZ1 [hm_getentityvalue NODE $independentNode "z" 0]

	foreach node $dependentNodes {
		set coordX2 [hm_getentityvalue NODE $node "x" 0]
		set coordY2 [hm_getentityvalue NODE $node "y" 0]
		set coordZ2 [hm_getentityvalue NODE $node "z" 0]

		if { $coordX1!=$coordX2 || $coordY1!=$coordY2 || $coordZ1!=$coordZ2 } {
			set non_zero_length 1
			if {$createTags == 1} {
				*tagcreate elems $eid "NON-ZERO LENGTH" "$eid" 10
			}
			break
		}
	}

	if {$non_zero_length == 1} {
		*createvector 1 1.0000 0.0000 0.0000
		foreach node $dependentNodes {
			*barelementcreatewithoffsets $independentNode $node $defaultVector 0 1 $defaultPin $defaultPin $defaultProperty
		}
	}
}