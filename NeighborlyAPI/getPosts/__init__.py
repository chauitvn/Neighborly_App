import logging
import os
import pymongo
from bson.json_util import dumps
import azure.functions as func


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python Get Posts function processed a request.')

    try:
        url = os.environ['CosmosDBConectionString']
        client = pymongo.MongoClient(url)
        database = client['neighborky_app_db']
        colection = database['posts']

        result = colection.find()
        result = dumps(result)

        return func.HttpResponse(result, mimetype="application/json", charset='utf-8')
    except ValueError:
        return func.HttpResponse("Bad request.", status_code=400)
