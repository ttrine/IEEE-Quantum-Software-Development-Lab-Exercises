#!/bin/bash

display_usage() { 
	echo "To run all tests in a lab, give the lab number as an integer positional argument." 
	echo -e "Example: $0 1 \n"

    echo "To run a specific tests in a lab, give the test number as a second positional argument." 
    echo -e "Example: $0 1 3 \n"
}

# Display usage if number of arguments is incorrect
if [  $# -le 0 ] || [  $# -ge 3 ]
then
    display_usage
    exit 1
fi 
 
# Display usage if the user asks for help
if [[ ( $# == "--help") ||  $# == "-h" ]] 
then 
    display_usage
    exit 0
fi

if [  $# -eq 1 ]
then # Run all tests in the lab
    dotnet test --filter "QSharpExercises.Tests.Lab$1."
else # Run only the specified test
    dotnet test --filter "QSharpExercises.Tests.Lab$1.Exercise$2Test+QuantumSimulator.Exercise$2Test"
fi 
