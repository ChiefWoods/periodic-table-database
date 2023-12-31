#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  RESULT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE CAST(atomic_number AS VARCHAR) = '$1' OR symbol = '$1' OR name = '$1'")

  if [[ -z $RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    read ATOMIC_NUMBER BAR SYMBOL BAR NAME <<< $RESULT
    read TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT <<< $($PSQL "SELECT type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties, types WHERE atomic_number = $ATOMIC_NUMBER AND properties.type_id = types.type_id")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi
