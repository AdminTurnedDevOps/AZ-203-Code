import os
import time
import logging

context = os.system('az account show')
if context is None:
    logging.warning('No AZ account is set. Please ensure you have AZ CLI installed and you have logged in with your account credentials')
    time.sleep(5)
    exit()
else:
    print('Proceeding...')

resource_group = input('Please enter resource group name: ')
cosmos_account = input('Please enter Cosmos account name: ')

os.system(f'az cosmosdb create --resource-group {resource_group} --name {cosmos_account}')