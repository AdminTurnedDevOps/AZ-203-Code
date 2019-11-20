from azure.common.credentials import ServicePrincipalCredentials
from azure.mgmt.network import NetworkManagementClient
import logging
import getpass
import azure.common.exceptions

# Within credentials array;
# 1. client_id = Client ID for your app registration. It's called "Application (client) id"
# 2. secret = Your certificate secret. Under the same app registration, you will have to generate a cert under "Certificates & secrets"
# 3. tenant = Tenant ID for your app registration. It's called "Directory (tenant) ID"

def listVnets(clientId, tenant, subscription):

    try:
        logging.log('Obtaining secret')
        passw = getpass.getpass(prompt='Password: ')

        credentials = ServicePrincipalCredentials(
            client_id = clientId,
            secret = passw,
            tenant = tenant
        )

        logging.log('Obtaining network management information')
        net = NetworkManagementClient(credentials, subscription)

        logging.log('Printing vNets')
        for i in net.virtual_networks.list_all():
            print(i)

    except azure.common.exceptions.AuthenticationError:
        logging.error('ERROR: There was an authentication issue. Please confirm your client id, secret, tenant, subscription, and try again')
        
    except Exception as e:
        logging.error(e)


listVnets(clientId=, tenant=, subscription=)