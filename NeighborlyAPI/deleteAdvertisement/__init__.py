import os
import logging
import pymongo
import azure.functions as func
from bson.objectid import ObjectId


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python Delete Advertisement function processed a request.')

    id = req.params.get('id')

    if id:
        try:
            url = os.environ['CosmosDBConectionString']
            client = pymongo.MongoClient(url)
            database = client['neighbourky_app_db']
            colection = database['advertisements']

            query = {"_id": ObjectId(id)}
            colection.delete_one(query)

            return func.HttpResponse(
                "Advertisement deleted",
                status_code=200
            )
        except ValueError:
            print("Could not connect to MongoDB")
            return func.HttpResponse(
                "Could not connect to MongoDB",
                status_code=500
            )
    else:
        return func.HttpResponse(
            "Please pass an Id in the query string",
            status_code=400
        )
