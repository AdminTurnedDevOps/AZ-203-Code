import azure.cosmos.cosmos_client as cosmosAuth
import azure.cosmos.errors as errors
import getpass
import sys

def cosmosCreateDbAndContainer(url, id, collection_id):
    print('Please type in primary key for Cosmos Account found under "keys"')
    p = getpass.getpass()

    try:
        # The password will be your Cosmos Primary Key
        auth = cosmosAuth.CosmosClient(url, {'masterKey': p})
        auth.CreateDatabase({"id": id})
        coll = {
            "id": f"{collection_id}",
            "indexingPolicy": {
                "indexingMode": "lazy",
                "automatic": False
            }
        }
        link = 'dbs/' + id
        auth.CreateContainer(link, coll)

    except errors.HTTPFailure as e:
            if e.status_code == 400:
                print('Request URL is invalid')
    except errors.HTTPFailure as t:
        if t.status_code == 409:
            print('ID already exists')

    except errors.HTTPFailure as b:
        if b.status_code == 404:
            print('Resource Not Found')

url = sys.argv[1]
id = sys.argv[2]
collection_id = sys.argv[3]

if __name__ == '__main__':
    cosmosCreateDbAndContainer(url, id, collection_id)

else:
    print('Running as an imported module...')
    cosmosCreateDbAndContainer(url, id, collection_id)