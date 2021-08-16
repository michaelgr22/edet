import json
import os

from aws_dbconnector_client import AwsDBConnectorClient
from . import api_pathes

database = os.environ.get('DB')
secret_name = os.environ.get('SECRET')
secret_region = os.environ.get('REGION')
aws_dbconnector_client = AwsDBConnectorClient(
    secret_name, secret_region, database, 'postgres')
db = aws_dbconnector_client.get_db()


def get_response(event):
    print(event['path'])
    if event['path'] == '/mcknews':
        return api_pathes.mcknews(db, event)
    elif event['path'] == '/players':
        return api_pathes.players(db, event)
    elif event['path'] == '/teammatches':
        return api_pathes.teammatches(db, event)
    elif event['path'] == '/leaguematches':
        return api_pathes.leaguematches(db, event)
    elif event['path'] == '/standings':
        return api_pathes.standings(db, event)
    elif event['path'] == '/mainleague':
        return api_pathes.mainleague(db, event)
    elif event['path'].startswith('/ticker'):
        return api_pathes.ticker(db, event)


def lambda_handler(event, context):
    statusCode = 200
    response = {}

    try:
        response = get_response(event)
        if not response:
            statusCode = 401
    except Exception as e:
        print(e)
        statusCode = 400

    responseObject = {}
    responseObject['statusCode'] = statusCode
    responseObject['headers'] = {}
    responseObject['headers']['Content-Type'] = 'application/json'
    responseObject['body'] = json.dumps(response, default=str)

    return responseObject
