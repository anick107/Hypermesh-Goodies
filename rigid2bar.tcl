# Transform RBE2 elements to CBAR
# Typical usecase: thermo-elastic analysis
# 1D -> elem types -> BAR2 = CBAR

set defaultProperty 0
set defaultPin 0
set defaultVector 1

*createmarkpanel elems 1 "Please select the Rigidlink elements to tranform into BAR2"
foreach eid [hm_getmark elems 1] {
	
	set dependentNodes [hm_getentityarray elements $eid dependentnodes]
	set independentNode  [lindex [hm_getentityarray elements $eid nodes] 0]

	*createvector 1 1.0000 0.0000 0.0000
	foreach node $dependentNodes {
		*barelementcreatewithoffsets $independentNode $node $defaultVector 0 1 $defaultPin $defaultPin $defaultProperty
	}
}