# For Cosmos SDK;
# https://github.com/Azure/azure-sdk-for-python/tree/master/sdk/cosmos/azure-cosmos
# pip install azure-cli

import json
import logging
import azure.cosmos.cosmos_client
import azure.cosmos.documents
from azure.cosmos import errors
import sys
import time

def cosmosDocuments(*args):
    try:
        cosmosConfig = {
            'ENDPOINT': endpoint,
            'PRIMARYKEY': primaryKey,
            'DATABASE': database,
            'CONTAINER': container
        }

        database_link = 'dbs/' + cosmosConfig['DATABASE']
        collection_link = database_link + '/colls/' + cosmosConfig['CONTAINER']

        
        databaseConfig = azure.cosmos.database.CosmosClientConnection(url_connection=cosmosConfig['ENDPOINT'],
                                                                      auth={'masterKey': cosmosConfig['PRIMARYKEY']})

        
        j = noSQLPath
        with open(j, "r") as jsonFile:
            data = jsonFile.read()

        jsonData = data
        inf = json.loads(jsonData)
        print(list(databaseConfig.CreateItem(collection_link, inf)))


    except azure.cosmos.errors.CosmosAccessConditionFailedError:
        logging.ERROR('Warning: Please check Cosmos DB access')

    except azure.cosmos.errors.CosmosClientTimeoutError:
        logging.ERROR('ERROR: A timeout error occurred on the client')

    except azure.cosmos.errors.CosmosResourceNotFoundError:
        logging.ERROR('The cosmos resource that was specified was not found.')

    except Exception as e:
        raise e

endpoint = sys.argv[1]
primaryKey = sys.argv[2]
database = sys.argv[3]
container = sys.argv[4]

if __name__ == '__main__':
    cosmosDocuments(endpoint, primaryKey, database, container, noSQLPath)

else:
    print('running as imported module')
    time.sleep(5)
    cosmosDocuments(endpoint, primaryKey, database, container, noSQLPath)