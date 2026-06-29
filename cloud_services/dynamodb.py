import logging
from config import SystemSetting
import boto3
from botocore.exceptions import ClientError


class DynamoDbClass:
    def __init__(self):
        self.client = boto3.client('dynamodb')
        self.logger = logging.getLogger(__name__)

    def get_document_id_client(self, user_id, doc_id_val: str):
        """
        Queries DynamoDB using the low-level client interface to find a record
        by Partition Key (doc_id) and Sort Key (thre_id).
        """
        # Initialize the low-level client
        client = boto3.client('dynamodb', region_name='us-east-1')

        try:
            response = client.query(
                TableName=SystemSetting.db_table_name,
                # Define the filter using the primary key attributes
                KeyConditionExpression='doc_id = :d_id AND thre_id = :t_id',
                # Map the placeholders to explicit DynamoDB types ('S' for String)
                ExpressionAttributeValues={
                    ':user_id': {'S': user_id},
                    ':doc_id': {'S': doc_id_val}
                },
                # ProjectionExpression ensures only 'doc_id' is sent back over the network
                ProjectionExpression='doc_id'
            )

            items = response.get('doc_id')

            if items:
                # Extract doc_id from the first matching dictionary item
                # The structure returned looks like: {'doc_id': {'S': 'your_actual_id'}}
                retrieved_id = items[0]['doc_id']['S']
                self.logger.info(
                    f"✅ Success! Found Document ID: {retrieved_id}")
                return retrieved_id
            else:
                self.logger.exception("❌ No matching document found.")
                return None

        except ClientError as e:
            self.logger.exception(
                f"AWS Error: {e.response['Error']['Message']}")
            return None

    # --- Example Usage ---
    # result = get_document_id_client('YourTableName', 'doc_12345', 'thread_9988')
