#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE teams, games;")
echo $($PSQL "ALTER SEQUENCE teams_team_id_seq RESTART WITH 1;")
echo $($PSQL "ALTER SEQUENCE games_game_id_seq RESTART WITH 1;")

cat games.csv | while IFS="," read YEAR ROUND WIN OPP WINGOALS OPPGOALS;
do
  if [[ $YEAR != "year" ]]
  then
    # get teams
    GET_NAME_WIN=$($PSQL "SELECT name FROM teams WHERE name='$WIN';")
    if [[ $GET_NAME_WIN != $WIN ]]
    then
      INSERT_WIN_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$WIN');")
      if [[ $INSERT_WIN_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted team $WIN
      fi
    fi
    GET_NAME_OPP=$($PSQL "SELECT name FROM teams WHERE name='$OPP';")
    if [[ $GET_NAME_OPP != $OPP ]]
    then
      INSERT_OPP_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPP');")
      if [[ $INSERT_OPP_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted team $OPP
      fi
    fi    
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WIN OPP WINGOALS OPPGOALS;
do
  if [[ $YEAR != "year" ]]
  then
    # get teams
    GET_WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN';")
    GET_OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP';")
    
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $GET_WIN_ID, $GET_OPP_ID, $WINGOALS, $OPPGOALS);")
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted game year: $YEAR, round: $ROUND, winner: $WIN, opponent: $OPP, winner goals: $WINGOALS, opponent goals: $OPPGOALS
    fi
  fi
done