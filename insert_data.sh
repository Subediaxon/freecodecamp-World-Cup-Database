#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
echo -e "Wait for it..."
CT=0 #cycle counter
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WG OG
do
  let CT+=1
  if [[ $YEAR != "year" ]]
  then
    W_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    O_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $W_ID ]]
    then
      ITR=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      W_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
    if [[ -z $O_ID ]]
    then
      ITR=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      O_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
    ITR=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $W_ID, $O_ID, $WG, $OG)")
  fi
  echo $CT
done
echo -e "DONE"


