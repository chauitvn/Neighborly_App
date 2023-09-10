import logging
import os
import pymongo
from bson.json_util import dumps
from bson.objectid import ObjectId
import azure.functions as func


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python Get Post function processed a request.')

    id = req.params.get('id')

    if id:
        try:
            url = os.environ['CosmosDBConectionString']
            client = pymongo.MongoClient(url)
            database = client['neighbourky_app_db']
            colection = database['posts']

            query = {"_id": ObjectId(id)}
            result = colection.find(query)
            result = dumps(result)

            return func.HttpResponse(result, mimetype="application/json", charset='utf-8')
        except ValueError:
            return func.HttpResponse("Database connection error.", status_code=500)
        else:
            return func.HttpResponse("Please pass an id parameter in the query string.", status_code=400)
