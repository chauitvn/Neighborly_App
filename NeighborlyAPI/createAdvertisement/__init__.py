import os
import pymongo
import logging
import azure.functions as func


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python Create Advertisement function processed a request.')

    request = req.get_json()
    print("--------------->", request)

    if request:
        try:
            url = os.environ['CosmosDBConectionString']
            client = pymongo.MongoClient(url)
            database = client['neighborly-db']
            colection = database['advertisements']

            rec_id1 = colection.insert_one(request)
            return func.HttpResponse(req.get_body())

        except ValueError:
            logging.error(ValueError)
            return func.HttpResponse(
                "Could not connect to MongoDB",
                status_code=500
            )
    else:
        return func.HttpResponse(
            "Please pass name in the body",
            status_code=400
        )
