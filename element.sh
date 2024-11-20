#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [ $# -eq 0 ]
then
  echo "Please provide an element as an argument."
else
  re='^[0-9]+$'
  if [[ $1 =~ $re ]]
  then
    FOUND_ELEMENT=$($PSQL "select (atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius) from elements full join properties using (atomic_number) full join types using (type_id) where atomic_number=$1;")
  else
    FOUND_ELEMENT=$($PSQL "select (atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius) from elements full join properties using (atomic_number) full join types using (type_id) where symbol='$1' or name='$1';")
  fi

  if [[ -z $FOUND_ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    FOUND_ELEMENT=$(echo $FOUND_ELEMENT | tr -d '()')
    IFS=',' read -r ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS <<< $FOUND_ELEMENT
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  fi
fi


