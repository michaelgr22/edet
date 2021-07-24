import json
import ast
import logging
import os

from aws_secretsmanager_client import AwsSecretsManagerClient
from aws_postgresdb_client import AwsPostgresDBClient
from fupa_client import FupaClient

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def connect_to_db():
    secret = get_secret()
    database = os.environ.get('DB')
    logger.info("Connect to dbhost:{}".format(secret['host']))
    db = AwsPostgresDBClient(host=secret['host'],
                             port=secret['port'],
                             database=database,
                             user=secret['username'],
                             password=secret['password'])
    return db


def get_secret():
    stage = os.environ.get('STAGE')

    secret_name = 'edet_pg_d_datafetcher_secret'
    if stage == 'prod':
        secret_name = 'edet_pg_p_datafetcher_secret'

    aws_secret_client = AwsSecretsManagerClient(secret_name, 'eu-central-1')
    secret = ast.literal_eval(aws_secret_client.get_secret())
    return secret


db = connect_to_db()


def get_teams_from_source_table():
    source_table = os.environ.get('SOURCE_TABLE')
    logger.info("Get Teams from Table {}".format(source_table))

    sql = "SELECT teams_source_name, teams_source_class, teams_source_season FROM {};".format(
        source_table)
    teams = db.execute_sql(sql)
    return teams


def insert_league(match):
    tablename = 'leagues.all_leagues'

    sql = """INSERT INTO {} (league_showname, league_name, league_season, league_link)
VALUES (\'{}\', \'{}\',\'{}\' ,\'{}\')
ON CONFLICT (league_name, league_season)
DO UPDATE SET
league_showname = EXCLUDED.league_showname, league_link = EXCLUDED.league_link
RETURNING league_id;""".format(tablename, match['league_showname'], match['league_name'], match['home_season'], match['league_link'])

    id = db.execute_sql(sql)
    return id[0][0]


def insert_team(team):
    tablename = 'teams.all_teams'

    sql = """INSERT INTO {} (team_showname, team_name, team_class, team_season, team_link, team_image_link)
VALUES (\'{}\', \'{}\', \'{}\', \'{}\', \'{}\', \'{}\')
ON CONFLICT (team_name, team_class, team_season)
DO UPDATE SET
team_showname = EXCLUDED.team_showname, team_link = EXCLUDED.team_link, team_image_link = EXCLUDED.team_image_link, 
team_main_league_id = EXCLUDED.team_main_league_id RETURNING team_id;
""".format(tablename, team['showname'], team['teamname'], team['teamclass'], team['season'], team['teamlink'], team['teamimage'])
    id = db.execute_sql(sql)
    return id[0][0]


def insert_match(match, home_team_id, away_team_id, league_id):
    tablename = 'matches.all_matches'

    sql = """INSERT INTO {}
(match_date_time, match_link, match_home_team_id, match_away_team_id, match_home_goals, match_away_goals, match_cancelled, match_league_id)
VALUES
(\'{}\', \'{}\', {}, {}, {}, {}, {}, {})
ON CONFLICT (match_date_time, match_home_team_id, match_away_team_id, match_league_id)
DO UPDATE SET
match_link = EXCLUDED.match_link, match_home_goals = EXCLUDED.match_home_goals, match_away_goals = EXCLUDED.match_away_goals, 
match_cancelled = EXCLUDED.match_cancelled;
""".format(tablename, match['date_time'], match['match_link'], home_team_id, away_team_id,
           match['home_goals'] if isinstance(match['home_goals'], int) else 'NULL', match['away_goals'] if isinstance(match['home_goals'], int) else 'NULL', 'TRUE' if match['cancelled'] else 'FALSE', league_id)
    db.execute_sql(sql)


def insert_leagues_and_teams_and_matches(matches):
    for match in matches:
        logger.info("Insert Match {}".format(match['match_link']))
        league_id = insert_league(match)
        home_team = {'showname': match['home_showname'], 'teamname': match['home_teamname'],
                     'teamclass': match['home_teamclass'], 'season': match['home_season'], 'teamlink': match['home_link'], 'teamimage': match['home_image']}
        away_team = {'showname': match['away_showname'], 'teamname': match['away_teamname'],
                     'teamclass': match['away_teamclass'], 'season': match['away_season'], 'teamlink': match['away_link'], 'teamimage': match['away_image']}
        home_team_id = insert_team(home_team)
        away_team_id = insert_team(away_team)
        insert_match(match, home_team_id, away_team_id, league_id)


def insert_matches_of_teams():
    logger.info("Start")
    teams = get_teams_from_source_table()
    for team in teams:
        print('{}-{}-{}'.format(team[0], team[1], team[2]))
        fupa_client = FupaClient(team[0], team[1], team[2])
        matches = fupa_client.get_matches()
        print(matches[0])
        insert_leagues_and_teams_and_matches(matches)


def lambda_handler(event, context):
    insert_matches_of_teams()
    return {
        "statusCode": 200,
    }
