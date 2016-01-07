#!/bin/bash

. ~/setclasspath.sh

## Carrega o ambiente de mpi para o Ray
. /hpc/modulos/bash/openmpi-gcc.sh

function parseArgs {
  for arg in $* ; do
        typeset name=`echo $arg | sed "s/=.*//"`
        typeset value=`echo $arg | sed "s/.*=//"`
        export $name=$value
  done
}

######## Parseando argumentos do CSGrid ########
parseArgs $*

echo $RAY_INPUTTYPES
echo $numCPU
echo $RAY_KMERLENGTH
echo $RAY_INPUT_LEFT_SEQUENCE_FILE
echo $RAY_INPUT_RIGHT_SEQUENCE_FILE
echo $RAY_OUTPUT

cmdId=`echo $cmdId | sed 's/\(.*\)\@\(.*\)\.\(.*\)/\1_\2_\3/'`

echo $cmdId

numCPU=$NSLOTS
######## Executando o programa ########
COMMAND="time mpirun -np $numCPU -hostfile $TMPDIR/hostfile $ALGORITHMS_THIRD_DIR/Ray/versions/v_001_000_000/Ray-2.3.1/Ray"

if [ "$RAY_INPUTTYPES" == "LoadPairedEndReads" ]
then
	COMMAND="$COMMAND -k $RAY_KMERLENGTH -p $RAY_INPUT_LEFT_SEQUENCE_FILE $RAY_INPUT_RIGHT_SEQUENCE_FILE -o $RAY_OUTPUT/$cmdId/"
#        COMMAND="mpirun -np $numCPU $COMMAND -k $KMERLENGTH -p $INPUT_LEFT_SEQUENCE_FILE $INPUT_RIGHT_SEQUENCE_FILE -o $OUTPUT/$cmdId/"
    echo "Running Ray with LoadPairedEndReads..."
fi

if [ "$RAY_INPUTTYPES" == "InterleavedSequenceFile" ]
then
	COMMAND="$COMMAND -k $RAY_KMERLENGTH -i $RAY_INPUT_INTERLEVED_SEQUENCE_FILE -o $RAY_OUTPUT/$cmdId/"
    echo "Running Ray with InterleavedSequenceFile..."
fi

if [ "$RAY_INPUTTYPES" == "LoadSingleEndReads" ]
then
	COMMAND="$COMMAND -k $RAY_KMERLENGTH -s $RAY_INPUT_SINGLE_END_SEQUENCE_FILE -o $RAY_OUTPUT/$cmdId/"
    echo "Running Ray with LoadSingleEndReads..."
fi

echo $COMMAND
$COMMAND

if [ $? != 0 ]
then
	 echo "Ray returned an error."
         exit 1
fi
