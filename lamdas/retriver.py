from cloud_services import DynamoDbClass
from embedding_processors import PageIndexClass
from pyresilience import TimeoutConfig, RetryConfig, resilient

service = DynamoDbClass()
retriver_service = PageIndexClass()


@resilient(
    retry=RetryConfig(
        max_attempts=3,
        delay=1.0,
        backoff_factor=2.0
    ),
    timeout=TimeoutConfig(
        seconds=15
    )
)
def lambda_handeler(context, event):
    try:
        user_id = event.get("user_id")
        thread_id = event.get("doc_id")
        query = event.get("query")
        document_id = service.get_document_id_client(
            thre_id_val=thread_id, user_id=user_id)
        respones = retriver_service.retrive_document(
            doc_id=document_id, query=query)
        return {
            "user_id": user_id,
            "respones": respones
        }

    except Exception as error:
        raise RuntimeError(error)
