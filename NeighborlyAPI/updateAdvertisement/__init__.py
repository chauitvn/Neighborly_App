import logging
import os
import pymongo
from bson.json_util import dumps
from bson.objectid import ObjectId
import azure.functions as func


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    id = req.params.get('id')
    request = req.get_json()

    if request:
        try:
            url = os.environ['CosmosDBConectionString']
            client = pymongo.MongoClient(url)
            database = client['neighborly-db']
            collection = database['advertisements']
            
            filter_query = {'_id': ObjectId(id)}
            update_query = {"$set": request}
            rec_id1 = collection.update_one(filter_query, update_query)
            return func.HttpResponse(status_code=200)
        except:
            logging.error(ValueError)
            return func.HttpResponse('Could not connect to mongodb', status_code=500)
    else:
        return func.HttpResponse('Please pass name in the body', status_code=400)
