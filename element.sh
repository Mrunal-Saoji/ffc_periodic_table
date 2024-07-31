PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only  -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  re='^[0-9]+$'
  if ! [[ $1 =~ $re ]] ; then
    DATA=$($PSQL "SELECT * FROM elements inner join properties using (atomic_number) inner join types using(type_id) where symbol=CAST('$1' as TEXT) or name=CAST('$1' as TEXT) limit 1;")
  else
    DATA=$($PSQL "SELECT * FROM elements inner join properties using (atomic_number) inner join types using(type_id) where atomic_number=$1;")
  fi

  
  if [[ -z $DATA ]]
  then
    echo -e "I could not find that element in the database."
  else 
    echo "$DATA" | while read TYPEID BAR ATOMIC_NUM BAR SYMBOL BAR NAME BAR WEIGHT BAR MPOINT BAR BPOINT BAR TYPE; do
      echo -e "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $WEIGHT amu. $NAME has a melting point of $MPOINT celsius and a boiling point of $BPOINT celsius."
    done 
  fi
fi

ISNUMERIC(){
  re='^[0-9]+$'
  if ! [[ $1 =~ $re ]] ; then
    echo "error: Not a number" >&2; exit 1
  fi
}

