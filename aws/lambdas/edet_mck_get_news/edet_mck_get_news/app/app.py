import logging
import os

from aws_dbconnector_client import AwsDBConnectorClient
from mck_homepage_client import MckHomepageClient

logger = logging.getLogger()
logger.setLevel(logging.INFO)


database = os.environ.get('DB')
secret_name = os.environ.get('SECRET')
secret_region = os.environ.get('REGION')
aws_dbconnector_client = AwsDBConnectorClient(
    secret_name, secret_region, database, 'postgres')
db = aws_dbconnector_client.get_db()


def insert_news_item(item):
    tablename = 'mck.news'
    logger.info("Insert News in Table {}".format(tablename))

    sql = """INSERT INTO {}
(news_headline, news_date, news_category, news_imagelink, news_content, news_deleted)
VALUES (%s, %s, %s, %s, %s, %s)
ON CONFLICT (news_headline, news_date, news_category)
DO UPDATE SET
news_imagelink = EXCLUDED.news_imagelink, news_content = EXCLUDED.news_content;""".format(tablename)
    values = (item['headline'], item['date'], item['category'],
              item['imagelink'], item['content'], 'false')

    db.execute_sql(sql, values=values, autocommit=True)


def insert_news():
    logger.info("Start")
    mck_client = MckHomepageClient()
    news = mck_client.get_news(10)
    for item in news:
        insert_news_item(item)


def lambda_handler(event, context):
    insert_news()
    return {
        "statusCode": 200,
    }
