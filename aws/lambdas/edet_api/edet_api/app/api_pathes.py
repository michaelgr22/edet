from . import ticker_methods


def mcknews(db, event):
    tablename = 'mck.news'

    if event['queryStringParameters']:
        if 'id' in event['queryStringParameters']:
            sql = """SELECT news_id, news_headline, news_date, news_category, news_imagelink, news_content FROM {}
            WHERE (news_category = 'Fussball' OR news_category = 'Allgemein') and news_id = %s;""".format(tablename)

            id = event['queryStringParameters']['id']
            values = (id,)
            result = db.execute_sql(sql, values=values)
            row = result[0]

            return {'news_id': row[0], 'news_headline': row[1], 'news_date': row[2], 'news_category': row[3], 'news_imagelink': row[4],
                    'news_content': row[5]}
    else:
        sql = """SELECT news_id, news_headline, news_date, news_category, news_imagelink, news_content FROM {}
        WHERE news_category = 'Fussball' OR news_category = 'Allgemein'
        ORDER BY news_date desc;""".format(tablename)
        result = db.execute_sql(sql)

        return list(map(lambda row: {'news_id': row[0], 'news_headline': row[1], 'news_date': row[2], 'news_category': row[3], 'news_imagelink': row[4],
                                     'news_content': row[5]}, result))


def players(db, event):
    teamname = event['queryStringParameters']['teamname']
    teamclass = event['queryStringParameters']['teamclass']
    teamseason = event['queryStringParameters']['teamseason']
    players_tablename = 'teams.players'
    teams_tablename = 'teams.all_teams'

    sql = """SELECT player_id, player_firstname, player_lastname, player_birthday, player_deployments, player_goals, player_position, player_imagelink
    FROM {0}
    JOIN {1} ON {0}.player_team_id={1}.team_id
    WHERE team_name = %s AND team_class = %s AND team_season = %s;""".format(players_tablename, teams_tablename)

    values = (teamname, teamclass, teamseason)
    result = db.execute_sql(sql, values=values)

    return list(map(lambda row: {'player_id': row[0], 'player_firstname': row[1], 'player_lastname': row[2], 'player_birthday': row[3], 'player_deployments': row[4],
                                 'player_goals': row[5], 'player_position': row[6], 'player_imagelink': row[7]}, result))


def teammatches(db, event):
    teamname = event['queryStringParameters']['teamname']
    teamclass = event['queryStringParameters']['teamclass']
    teamseason = event['queryStringParameters']['teamseason']

    matches_tablename = 'matches.all_matches'
    teams_tablename = 'teams.all_teams'
    leagues_tablename = 'leagues.all_leagues'

    sql = """SELECT match_id, match_date_time, 
    home.team_id as match_home_team_id, home.team_image_link as match_home_image_link, home.team_showname as match_home_team_showname, 
    away.team_id as match_away_team_id, away.team_image_link as match_away_image_link, away.team_showname as match_away_team_showname, 
match_link, match_home_goals, match_away_goals, match_cancelled, leagues.league_showname as match_league_showname
FROM {0}
JOIN {1} home ON {0}.match_home_team_id=home.team_id
JOIN {1} away ON {0}.match_away_team_id=away.team_id
JOIN {2} leagues ON {0}.match_league_id=leagues.league_id
WHERE (home.team_name = %s AND home.team_class = %s AND home.team_season = %s) 
OR (away.team_name = %s AND away.team_class = %s AND away.team_season = %s)
ORDER BY match_date_time asc;""".format(matches_tablename, teams_tablename, leagues_tablename)

    values = (teamname, teamclass, teamseason, teamname, teamclass, teamseason)
    result = db.execute_sql(sql, values=values)

    return list(map(lambda row: {'match_id': row[0], 'match_date_time': row[1], 'match_home_team_id': row[2], 'match_home_image_link': row[3],
                                 'match_home_team_showname': row[4], 'match_away_team_id': row[5], 'match_away_image_link': row[6], 'match_away_team_showname': row[7],
                                 'match_link': row[8], 'match_home_goals': row[9], 'match_away_goals': row[10], 'match_cancelled': row[11], 'match_league_showname': row[12]},
                    result))


def standings(db, event):
    teamname = event['queryStringParameters']['teamname']
    teamclass = event['queryStringParameters']['teamclass']
    teamseason = event['queryStringParameters']['teamseason']

    standings_tablename = 'leagues.standings'
    teams_tablename = 'teams.all_teams'

    sql = """SELECT standings_id, standings_position, teams.team_id as standings_team_id, teams.team_image_link as standings_team_image_link, 
    teams.team_showname as standings_team_showname, standings_games, standings_wins, 
    standings_draws, standings_loses, standings_goals, standings_countered_goals, standings_points 
FROM {0}
JOIN {1} team_leagues ON {0}.standings_league_id=team_leagues.team_main_league_id
JOIN {1} teams ON {0}.standings_team_id=teams.team_id
WHERE (team_leagues.team_name = %s AND team_leagues.team_class = %s AND team_leagues.team_season = %s)
ORDER BY standings_position asc;""".format(standings_tablename, teams_tablename)

    values = (teamname, teamclass, teamseason)
    result = db.execute_sql(sql, values=values)

    return list(map(lambda row: {'standings_id': row[0], 'standings_position': row[1], 'standings_team_id': row[2], 'standings_team_image_link': row[3],
                                 'standings_team_showname': row[4], 'standings_games': row[5], 'standings_wins': row[6],
                                 'standings_draws': row[7], 'standings_loses': row[8], 'standings_goals': row[9], 'standings_countered_goals': row[10],
                                 'standings_points': row[11]}, result))


def mainleague(db, event):
    teamname = event['queryStringParameters']['teamname']
    teamclass = event['queryStringParameters']['teamclass']
    teamseason = event['queryStringParameters']['teamseason']

    leagues_tablename = 'leagues.all_leagues'
    teams_tablename = 'teams.all_teams'

    sql = """SELECT league_id, league_showname, league_name, league_season 
FROM {0}
JOIN {1} AS teams ON {0}.league_id=teams.team_main_league_id
WHERE teams.team_name = %s AND teams.team_class = %s AND teams.team_season = %s;""".format(leagues_tablename, teams_tablename)

    values = (teamname, teamclass, teamseason)
    result = db.execute_sql(sql, values=values)
    row = result[0]

    return {'league_id': row[0], 'league_showname': row[1], 'league_name': row[2], 'league_season': row[3]}


def leaguematches(db, event):
    teamname = event['queryStringParameters']['teamname']
    teamclass = event['queryStringParameters']['teamclass']
    teamseason = event['queryStringParameters']['teamseason']

    matches_tablename = 'matches.all_matches'
    teams_tablename = 'teams.all_teams'
    leagues_tablename = 'leagues.all_leagues'

    sql = """SELECT match_id, match_date_time, 
    home.team_id as match_home_team_id, home.team_image_link as match_home_image_link, home.team_showname as match_home_team_showname, 
    away.team_id as match_away_team_id, away.team_image_link as match_away_image_link, away.team_showname as match_away_team_showname,  
match_link, match_home_goals, match_away_goals, match_cancelled, leagues.league_showname as match_league_showname
FROM {0}
JOIN {1} teams ON {0}.match_league_id=teams.team_main_league_id
JOIN {1} home ON {0}.match_home_team_id=home.team_id
JOIN {1} away ON {0}.match_away_team_id=away.team_id
JOIN {2} leagues ON {0}.match_league_id=leagues.league_id
WHERE teams.team_name = %s AND teams.team_class = %s AND teams.team_season = %s
ORDER BY match_date_time asc;""".format(matches_tablename, teams_tablename, leagues_tablename)

    values = (teamname, teamclass, teamseason)
    result = db.execute_sql(sql, values=values)

    return list(map(lambda row: {'match_id': row[0], 'match_date_time': row[1], 'match_home_team_id': row[2], 'match_home_image_link': row[3],
                                 'match_home_team_showname': row[4], 'match_away_team_id': row[5], 'match_away_image_link': row[6], 'match_away_team_showname': row[7],
                                 'match_link': row[8], 'match_home_goals': row[9], 'match_away_goals': row[10], 'match_cancelled': row[11], 'match_league_showname': row[12]},
                    result))


def ticker(db, event):
    if event['path'].startswith('/ticker/actions'):
        return ticker_methods.ticker_get_actions(db, event)
    elif event['httpMethod'] == 'GET':
        return ticker_methods.ticker_get(db, event)
    elif event['httpMethod'] == 'POST':
        if event['path'] == '/ticker/add':
            return ticker_methods.ticker_post_add(db, event)
        elif event['path'] == '/ticker/delete':
            return ticker_methods.ticker_post_delete(db, event)
