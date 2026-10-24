#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

$PSQL "TRUNCATE TABLE games, teams;" > /dev/null

teams_sql="INSERT INTO teams (name) VALUES"
while IFS=, read -r year round winner opponent wg og
do
  if [[ "$year" != "year" ]]
  then
    teams_sql+=" ('${winner//\'/\'\'}'), ('${opponent//\'/\'\'}'),"
  fi
done < games.csv
teams_sql="${teams_sql%,} ON CONFLICT (name) DO NOTHING;"
$PSQL "$teams_sql" > /dev/null

declare -A team_ids
while IFS='|' read -r name id
do
  team_ids["$name"]="$id"
done < <($PSQL "SELECT name, team_id FROM teams;")

games_sql="INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES"
while IFS=, read -r year round winner opponent wg og
do
  if [[ "$year" != "year" ]]
  then
    w_id="${team_ids[$winner]}"
    o_id="${team_ids[$opponent]}"
    games_sql+=" (${year}, '${round//\'/\'\'}', ${w_id}, ${o_id}, ${wg}, ${og}),"
  fi
done < games.csv
games_sql="${games_sql%,};"
$PSQL "$games_sql" > /dev/null