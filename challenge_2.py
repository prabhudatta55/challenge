import json
import requests

#Function to call REST API requests
def get_item(access_token, url):
    headers = {}
    headers["Authorization"] = "Bearer %s" % access_token
    headers["Content-type"] = "application/json"
    try:
        r = requests.get(url, headers=headers)
        r.raise_for_status()
        response_json = None
        response_json = json.loads(r.content)
        item = response_json

    except Exception as e:
        raise e

    return item

#Provide subscription and resource group name for fetching respective resource metrics
subscriptionId =""
resource_group_name =""
#API access token required to authenticate
authtoken =""
url="https://management.azure.com/subscriptions/"+subscriptionId+"/resourceGroups/"+resource_group_name+"/providers/Microsoft.Storage/storageAccounts?api-version=2017-10-01"
response=get_item(authtoken,url)
value=response['value']

#Store the API response to a JSON file
with open("output_metadata.json", "w") as outfile:
    json.dump(value, outfile)