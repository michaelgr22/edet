def ticker_get(db, event):
    match_id = event['queryStringParameters']['match_id']

    ticker_tablename = 'matches.ticker'
    tickeractions_tablename = 'matches.ticker_actions'
    teams_tablename = 'teams.all_teams'
    players_tablename = 'teams.players'

    sql = """SELECT ticker_id, ticker_date_time, actions.action_name, teams.team_id, teams.team_showname, 
ticker_player1_id, players1.player_firstname as player1_firstname, players1.player_lastname as player1_lastname, 
ticker_player2_id, players2.player_firstname as player2_firstname, players2.player_lastname as player2_lastname,
ticker_comment, ticker_match_id
FROM {0}
JOIN {1} actions ON {0}.ticker_action_id=actions.action_id
JOIN {2} teams ON {0}.ticker_team_id=teams.team_id
JOIN {3} players1 ON {0}.ticker_player1_id=players1.player_id
LEFT JOIN {3} players2 ON {0}.ticker_player2_id=players2.player_id
WHERE ticker_match_id = %s
ORDER BY ticker_date_time asc;""".format(ticker_tablename, tickeractions_tablename, teams_tablename, players_tablename)

    values = (match_id,)
    result = db.execute_sql(sql, values=values)

    return list(map(lambda row: {'ticker_id': row[0], 'ticker_date_time': row[1], 'action_name': row[2], 'team_id': row[3], 'team_showname': row[4],
                                 'ticker_player1_id': row[5], 'player1_firstname': row[6], 'player1_lastname': row[7], 'ticker_player2_id': row[8],
                                 'player2_firstname': row[9], 'player2_lastname': row[10], 'ticker_comment': row[11], 'ticker_match_id':  row[12]}, result))


def ticker_post(db, event):
    pass
