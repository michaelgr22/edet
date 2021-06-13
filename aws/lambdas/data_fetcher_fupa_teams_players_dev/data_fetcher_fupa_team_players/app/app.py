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
    database = 'fupa_teams'
    logger.info("Connect to dbhost:{}".format(secret['host']))
    db = AwsPostgresDBClient(host=secret['host'],
                             port=secret['port'],
                             database=database,
                             user=secret['username'],
                             password=secret['password'])
    return db


def get_secret():
    stage = os.environ.get('STAGE')

    secret_name = 'edet_pg_d_datafetcher'
    if stage == 'prod':
        secret_name = 'edet_pg_p_datafetcher'

    aws_secret_client = AwsSecretsManagerClient(secret_name, 'eu-central-1')
    secret = ast.literal_eval(aws_secret_client.get_secret())
    return secret


db = connect_to_db()


def get_teams_from_db():
    logger.info("Get Teams from DB")
    sql = "SELECT teamname, teamclass, season FROM general.all_teams;"
    return db.select_sql(sql)


def drop_table_if_exists(table):
    logger.info("Drop Table {} if exists".format(table))
    sql = "DROP TABLE IF EXISTS \"{}\";".format(table)
    db.execute_sql(sql)


def create_table(table):
    logger.info("Create Table " + table)
    sql = """CREATE TABLE \"{}\" (
                id serial PRIMARY KEY,
                firstname TEXT,
                surname TEXT,
                age SMALLINT NOT NULL,
                deployments SMALLINT NOT NULL,
                goals SMALLINT NOT NULL,
                position TEXT NOT NULL,
                imagelink TEXT
                );""".format(table)
    db.execute_sql(sql)


def insert_players_of_team(table, players):
    logger.info("Insert Players in table {}".format(table))
    for player in players:
        name = player['name'].split(' ')
        sql = "INSERT INTO \"{}\" (firstname, surname, age, deployments, goals, position, imagelink) VALUES (\'{}\', \'{}\', {}, {}, {}, \'{}\', \'{}\')".format(
            table, name[0], name[1], player['age'], player['deployments'],
            player['goals'], player['position'], player['imagelink'])
        db.execute_sql(sql)
    logger.info("Players inserted succesfully")


def insert():
    teams = get_teams_from_db()
    for team in teams:
        fupa_client = FupaClient(team[0], team[1], team[2])
        players = None
        try:
            logger.info("Get Players for {}-{}-{}".format(
                team[0], team[1], team[2]))
            players = fupa_client.get_squad()
        except:
            logger.error("Get Players for {}-{}-{} failed".format(
                team[0], team[1], team[2]))
        if players:
            tablename = "teams.{}_{}_{}_players".format(
                team[0], team[1], team[2])
            drop_table_if_exists(tablename)
            create_table(tablename)
            insert_players_of_team(tablename, players)


def lambda_handler(event, context):
    statuscode = 200
    try:
        insert()
    except:
        statuscode = 400
    return {
        "statusCode": statuscode,
    }
