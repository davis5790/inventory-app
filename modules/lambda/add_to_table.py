import boto3

# Connect to S3, DynamoDB and select the table that we will use.
s3_client = boto3.client("s3")
dynamodb = boto3.resource("dynamodb")

table = dynamodb.Table("Respiratory-Supplies")

def lambda_handler(event, context):
    
    # Retrieve the csv data from the s3 bucket
    bucket_name = "inventory-app-bucket-4242"
    s3_file_name = "test/test.csv"
    response = s3_client.get_object(Bucket=bucket_name,Key=s3_file_name)

    # Parse the data into a form that is usable for us to upload to dynamodb
    data = response['Body'].read().decode("utf-8")
    supplies = data.split("\n")

    # Loop through data and upload contents to database
    for supply in supplies[1:-1]:
        # print(supply)
        supply_data = supply.split(",")

        # add to dynamodb
        table.put_item(
            Item = {
                "Id"        : int(supply_data[0]),
                "Item"      :  supply_data[1],
                "Quantity"   : int(supply_data[2]),
                "Expiration" : supply_data[3]
            }
        )