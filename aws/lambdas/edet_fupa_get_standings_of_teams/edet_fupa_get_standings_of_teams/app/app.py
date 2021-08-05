import logging
import os

from aws_dbconnector_client import AwsDBConnectorClient
from fupa_client import FupaClient

logger = logging.getLogger()
logger.setLevel(logging.INFO)


database = os.environ.get('DB')
secret_name = os.environ.get('SECRET')
secret_region = os.environ.get('REGION')
aws_dbconnector_client = AwsDBConnectorClient(
    secret_name, secret_region, database, 'postgres')
db = aws_dbconnector_client.get_db()


def get_teams_from_source_table():
    source_table = os.environ.get('SOURCE_TABLE')
    logger.info("Get Teams from Table {}".format(source_table))

    sql = "SELECT teams_source_name, teams_source_class, teams_source_season FROM {};".format(
        source_table)
    teams = db.execute_sql(sql)
    return teams


def get_league_id(standing):
    tablename = 'leagues.all_leagues'
    logger.info("Get League Id from Table {}".format(tablename))

    sql = """INSERT INTO {} (league_showname, league_name, league_season, league_link)
VALUES (%s, %s, %s, %s)
ON CONFLICT (league_name, league_season)
DO UPDATE SET
league_showname = EXCLUDED.league_showname, league_link = EXCLUDED.league_link
RETURNING league_id;""".format(tablename)
    values = (standing['league_showname'], standing['league_name'],
              standing['league_season'], standing['leaguelink'])

    id = db.execute_sql(sql, values=values, autocommit=True)
    return id[0][0]


def insert_team(team, league_id):
    tablename = 'teams.all_teams'
    logger.info("Insert team {} in Table {} with league_id {}".format(
        team['showname'], tablename, league_id))

    sql = """INSERT INTO {} (team_showname, team_name, team_class, team_season, team_link, team_image_link, team_main_league_id)
VALUES (%s, %s, %s, %s, %s, %s, %s)
ON CONFLICT (team_name, team_class, team_season)
DO UPDATE SET
team_showname = EXCLUDED.team_showname, team_link = EXCLUDED.team_link, team_image_link = EXCLUDED.team_image_link, 
team_main_league_id = EXCLUDED.team_main_league_id RETURNING team_id;
""".format(tablename)
    values = (team['showname'], team['teamname'], team['teamclass'],
              team['season'], team['teamlink'], team['teamimage'], league_id)
    id = db.execute_sql(sql, values=values, autocommit=True)
    return id[0][0]


def insert_standing(team_standing, team_id, league_id):
    tablename = 'leagues.standings'
    logger.info("Insert Standing in Table {}".format(tablename))

    sql = """INSERT INTO {} 
(standings_position, standings_team_id, standings_games, standings_wins, standings_draws, standings_loses, standings_goals, standings_countered_goals, standings_points, standings_league_id)
VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
ON CONFLICT (standings_team_id, standings_league_id)
DO UPDATE SET
standings_position = EXCLUDED.standings_position, standings_games = EXCLUDED.standings_games, standings_wins = EXCLUDED.standings_wins, standings_draws = EXCLUDED.standings_draws, 
standings_loses = EXCLUDED.standings_loses, standings_goals = EXCLUDED.standings_goals, standings_countered_goals = EXCLUDED.standings_countered_goals, 
standings_points = EXCLUDED.standings_points;
""".format(tablename)
    values = (team_standing['position'], team_id, team_standing['games'], team_standing['wins'], team_standing['draws'],
              team_standing['loses'], team_standing['goals'], team_standing['countered_goals'], team_standing['points'], league_id)
    db.execute_sql(sql, values=values, autocommit=True)


def insert_teams_and_standings(standing, league_id):
    for team in standing['standings']:
        team_id = insert_team(team, league_id)
        insert_standing(team, team_id, league_id)


def insert_standings_of_teams():
    logger.info("Start")
    teams = get_teams_from_source_table()
    for team in teams:
        fupa_client = FupaClient(team[0], team[1], team[2])
        standing = fupa_client.get_standing()
        league_id = get_league_id(standing)
        insert_teams_and_standings(standing, league_id)


def lambda_handler(event, context):
    insert_standings_of_teams()
    return {
        "statusCode": 200,
    }
