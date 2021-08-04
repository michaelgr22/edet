
import logging
import os

from aws_dbconnector_client import AwsDBConnectorClient
from fupa_client import FupaClient

logger = logging.getLogger()
logger.setLevel(logging.INFO)


database = os.environ.get('DB')
secret_name = 'edet_pg_d_datafetcher_secret' if os.environ.get(
    'STAGE') == 'dev' else 'edet_pg_p_datafetcher_secret'
secret_region = 'eu-central-1'
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


def get_team_id(team):
    teams_table = 'teams.all_teams'
    logger.info("Get TeamID from Table {}".format(teams_table))

    sql = "SELECT team_id FROM {} WHERE team_name = %s and team_class = %s and team_season = %s;".format(
        teams_table)
    values = (team[0], team[1], team[2])
    team_id = db.execute_sql(sql, values)
    return team_id[0][0]


def insert_player(player, team_id):
    tablename = 'teams.players'
    logger.info("Insert Players in Table {} for team_id {}".format(
        tablename, team_id))

    sql = """INSERT INTO {}
(player_firstname, player_lastname, player_birthday, player_deployments, player_goals, player_position, player_imagelink, player_playerlink, player_team_id)
VALUES (%s, %s, %s,%s,%s, %s,%s, %s, %s)
ON CONFLICT (player_firstname, player_lastname, player_team_id)
DO UPDATE SET
player_birthday = EXCLUDED.player_birthday, player_deployments = EXCLUDED.player_deployments, player_goals = EXCLUDED.player_goals, player_position = EXCLUDED.player_position, 
player_imagelink = EXCLUDED.player_imagelink, player_playerlink = EXCLUDED.player_playerlink;""".format(tablename)
    values = (player['firstname'], player['surname'], player['birthday'], player['deployments'],
              player['goals'], player['position'], player['imagelink'], player['playerlink'], team_id)

    db.execute_sql(sql, values=values, autocommit=True)


def insert_players(players, team_id):
    for player in players:
        try:
            insert_player(player, team_id)
        except Exception as e:
            print("ERROR: {}: Player {} {} in team_id {} can't be inserted".format(
                e, player['firstname'], player['surname'], team_id))


def insert_players_of_teams():
    logger.info("Start")
    teams = get_teams_from_source_table()
    for team in teams:
        fupa_client = FupaClient(team[0], team[1], team[2])
        players = fupa_client.get_squad()
        team_id = get_team_id(team)
        insert_players(players, team_id)


def lambda_handler(event, context):
    insert_players_of_teams()
    return {
        "statusCode": 200,
    }
