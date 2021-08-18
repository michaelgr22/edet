import json


def ticker_get(db, event):
    match_id = event['queryStringParameters']['match_id']

    ticker_tablename = 'matches.ticker'
    tickeractions_tablename = 'matches.ticker_actions'
    teams_tablename = 'teams.all_teams'
    players_tablename = 'teams.players'

    sql = """SELECT ticker_id, ticker_minute, actions.action_id, actions.action_name, teams.team_id, teams.team_showname, 
ticker_player1_id, players1.player_firstname as player1_firstname, players1.player_lastname as player1_lastname, 
ticker_player2_id, players2.player_firstname as player2_firstname, players2.player_lastname as player2_lastname,
ticker_comment, ticker_match_id
FROM {0}
JOIN {1} actions ON {0}.ticker_action_id=actions.action_id
JOIN {2} teams ON {0}.ticker_team_id=teams.team_id
JOIN {3} players1 ON {0}.ticker_player1_id=players1.player_id
LEFT JOIN {3} players2 ON {0}.ticker_player2_id=players2.player_id
WHERE ticker_match_id = %s
ORDER BY ticker_minute desc;""".format(ticker_tablename, tickeractions_tablename, teams_tablename, players_tablename)

    values = (match_id,)
    result = db.execute_sql(sql, values=values)

    return list(map(lambda row: {'ticker_id': row[0], 'ticker_minute': row[1], 'action_id': row[2], 'action_name': row[3], 'team_id': row[4], 'team_showname': row[5],
                                 'ticker_player1_id': row[6], 'player1_firstname': row[7], 'player1_lastname': row[8], 'ticker_player2_id': row[9],
                                 'player2_firstname': row[10], 'player2_lastname': row[11], 'ticker_comment': row[12], 'ticker_match_id':  row[13]}, result))


def ticker_post_add(db, event):
    body = json.loads(event['body'])

    ticker_tablename = 'matches.ticker'

    sql = """INSERT INTO {} (ticker_minute, ticker_action_id, ticker_team_id, ticker_player1_id, ticker_player2_id, ticker_comment, ticker_match_id)
VALUES (%s, %s,%s ,%s, %s, %s, %s) RETURNING ticker_id;""".format(ticker_tablename)

    values = (body['ticker_minute'], body['ticker_action_id'], body['ticker_team_id'],
              body['ticker_player1_id'], body['ticker_player2_id'], body['ticker_comment'], body['ticker_match_id'])
    result = db.execute_sql(sql, values=values, autocommit=True)
    ticker_id = result[0][0]

    return {'ticker_id': ticker_id}


def ticker_post_delete(db, event):
    body = json.loads(event['body'])

    ticker_tablename = 'matches.ticker'

    sql = """DELETE FROM matches.ticker WHERE ticker_id = %s RETURNING ticker_id""".format(
        ticker_tablename)

    values = (body['ticker_id'],)
    result = db.execute_sql(sql, values=values, autocommit=True)
    ticker_id = result[0][0]

    return {'ticker_id': ticker_id}
