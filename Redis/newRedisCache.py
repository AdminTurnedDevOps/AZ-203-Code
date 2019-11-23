# Within credentials array;
# 1. client_id = Client ID for your app registration. It's called "Application (client) id"
# 2. secret = Your certificate secret. Under the same app registration, you will have to generate a cert under "Certificates & secrets"
# 3. tenant = Tenant ID for your app registration. It's called "Directory (tenant) ID"

import azure.mgmt.redis
from azure.mgmt.redis.models import Sku, RedisCreateParameters
from azure.common.credentials import ServicePrincipalCredentials
import azure.common.exceptions
from msrestazure.azure_exceptions import CloudError
import sys
import logging

def newRedisCache(clientId, password, tenant, subscriptionId):
    
    logging.warning(msg='Please confirm you have the azure Python SDK installed. If you do not, run pip install azure')

    try:
        credentials = ServicePrincipalCredentials(
            client_id=clientId,
            secret=password,
            tenant=tenant
        )

        redis_connect = azure.mgmt.redis.RedisManagementClient(credentials, subscriptionId)
        rg_name = input('Please enter resource group name: ')
        cache = input('Please enter the name for your new Redis cache: ')


        createRedis = redis_connect.redis.create(
            rg_name,
            cache,
            RedisCreateParameters(sku = Sku(name = input('Please enter Sky type. For example: Basic: '),
                                            family = input('Please enter family. For example: C: '),
                                            capacity = int(input('Please enter capacity. For example: 1: '))),
                                            location = input('Please enter location. For example: eastus: '))
                                            )
        print('Creating Redis Cache')
    
    except azure.common.exceptions.AuthenticationError:
        logging.error('ERROR: There was an authentication issue. Please confirm your client id, secret, tenant, subscription, and try again')

    except CloudError as clo:
        logging.error(clo)
    
    except Exception as e:
        logging.error(e)


clientId = sys.argv[1]
password = sys.argv[2]
tenant = sys.argv[3]
subscriptionId = sys.argv[4]

newRedisCache(clientId, password, tenant, subscriptionId)