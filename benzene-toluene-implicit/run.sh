#!/bin/bash

#
# Benzene-toluene example run script (serial mode)
#

# Set defaults
export NITERATIONS=${NITERATIONS:=100}

# Create output directory.
if [ ! -e output ]; then
    echo "Making output directory..."
    mkdir output
fi

# Clean up any leftover files
echo "Cleaning up previous simulation..."
yank cleanup --store=output

# Set up calculation.
echo "Setting up binding free energy calculation..."
yank prepare binding amber --setupdir=setup --ligand="resname BEN" --store=output --iterations=$NITERATIONS --restraints=harmonic --gbsa=OBC2 --temperature="302.5*kelvin" --verbose

# Run the simulation with verbose output:
echo "Running simulation..."
yank run --store=output --verbose

# Analyze the data
echo "Analyzing data..."
yank analyze --store=output

