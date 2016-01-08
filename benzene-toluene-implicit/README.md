# benzene-toluene association in implicit solvent

This example computes the binding affinity of benzene with toluene in an implicit solvent model.

A harmonic restraint is used to keep the two molecules from drifting far away from each other.

## Running the simulation.

Set up the simulation to alchemically decouple benzene, putting all the output files in `output/`:
```tcsh
yank prepare binding amber --setupdir=setup --ligand="resname BEN" --store=output --iterations=1000 --restraints=harmonic --gbsa=OBC2 --temperature=300*kelvin --minimize --verbose
```

Run the simulation with verbose output:
```tcsh
yank run --store=output --verbose
```

Clean up and delete all simulation files:
```tcsh
yank cleanup --store=output
```

