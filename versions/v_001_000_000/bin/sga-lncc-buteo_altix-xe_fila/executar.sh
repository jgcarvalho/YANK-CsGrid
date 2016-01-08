#!/bin/bash
################# valores de teste #####
# ESSE BLOCO DEVE SER COMENTADO EM PRODUÇÂO
DIRECTORY="setup"
DSLSTRING="BEN"
MINIMIZE="NO"
NEQUIL=0
NSTEPS=500
NITER=100
RESTRAINTS="harmonic"
GBSA=""
NBMETHOD=""
CUTOFF=1.0
CONSTRAINTS=""
TEMPERATURE=298.9
PRESSURE=1.0
STORE="store"

# . ~/setclasspath.sh

## Carrega o ambiente de mpi para o Ray
# . /hpc/modulos/bash/openmpi-gcc.sh

function parseArgs {
  for arg in $* ; do
        typeset name=`echo $arg | sed "s/=.*//"`
        typeset value=`echo $arg | sed "s/.*=//"`
        export $name=$value
  done
}

######## Parseando argumentos do CSGrid ########
parseArgs $*

echo $DIRECTORY
echo $DSLSTRING
echo $STORE
echo $MINIMIZE
echo $NEQUIL
echo $NSTEPS
echo $NITER
echo $RESTRAINTS
echo $GBSA
echo $NBMETHOD
echo $CUTOFF
echo $CONSTRAINTS
echo $TEMPERATURE
echo $PRESSURE

#echo $numCPU

cmdId=`echo $cmdId | sed 's/\(.*\)\@\(.*\)\.\(.*\)/\1_\2_\3/'`

echo $cmdId

numCPU=$NSLOTS



######## Executando o programa ########

COMMAND="mkdir $STORE; yank prepare binding amber --setupdir=$DIRECTORY --ligand=\"resname $DSLSTRING\" --store=$STORE  --verbose"

if [[ $MINIMIZE == "TRUE" ]]; then
  COMMAND="$COMMAND --minimize"
fi

if [ "$NEQUIL" -gt 0 ]; then
  COMMAND="$COMMAND --equilibrate=$NEQUIL"
fi

if [ "$NSTEPS" -gt 0 ]; then
  COMMAND="$COMMAND --nsteps=$NSTEPS"
fi

if [ "$NITER" -gt 0 ]; then
  COMMAND="$COMMAND --iterations=$NITER"
fi

if [[ $RESTRAINTS != "" ]]; then
  COMMAND="$COMMAND --restraints=$RESTRAINTS"
fi

if [[ $GBSA != "" ]]; then
  COMMAND="$COMMAND --gbsa=$GBSA"
fi

if [[ $NBMETHOD != "" ]]; then
  COMMAND="$COMMAND --nbmethod=$NBMETHOD"
fi

if [ "${CUTOFF%.*}" -gt 0 ]; then
  COMMAND="$COMMAND --cutoff=\"$CUTOFF*nanometer\""
fi

if [[ $CONSTRAINTS != "" ]]; then
  COMMAND="$COMMAND --constraints=$CONSTRAINTS"
fi

if [ "${TEMPERATURE%.*}" -gt 0 ]; then
  COMMAND="$COMMAND --temperature=\"$TEMPERATURE*kelvin\""
fi

if [ "${PRESSURE%.*}" -gt 0 ]; then
  COMMAND="$COMMAND --pressure=\"$PRESSURE*atmosphere\""
fi

COMMAND="$COMMAND; yank run --store=$STORE --verbose; yank analyze --store=$STORE"


echo $COMMAND
eval $COMMAND

if [ $? != 0 ]
then
	 echo "Yank returned an error."
         exit 1
fi
