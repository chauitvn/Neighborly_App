import logging
import os
import pymongo
from bson.json_util import dumps
import azure.functions as func


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python Get Advertisement function processed a request.')

    try:
        url = os.environ['CosmosDBConectionString']
        client = pymongo.MongoClient(url)
        database = client['neighborly-db']
        colection = database['advertisements']

        result = colection.find()
        result = dumps(result)

        return func.HttpResponse(result, mimetype="application/json", charset='utf-8')
    except ValueError:
        print("could not connect to mongodb")
        return func.HttpResponse("could not connect to mongodb",
                                 status_code=400)
