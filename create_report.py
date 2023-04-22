import boto3
import datetime

client = boto3.client('dynamodb')
TableName = 'Respiratory-Supplies'

data = client.scan(
    TableName = TableName
)

def generateStockReport(data):
    for item in data['Items']:
        if int(item['Quantity']['N']) <= 3:
            print(item['Item']['S'] + "=" + item['Quantity']['N'])

def generateExpirationReport(data):
    
    today = datetime.date.today()
    #print(today)
    
    for item in data['Items']:
        if len(item['Expiration']['S'].strip()) > 0:
            date = item['Expiration']['S'].strip()
            #print(date)
            expDate = datetime.datetime.strptime(date, '%Y-%m-%d').date()
            daysToExpire = expDate - today
            print(item['Item']['S'] + " expire in " + str(daysToExpire.days) + " days")
    
        
#generateStockReport(data)

generateExpirationReport(data)
