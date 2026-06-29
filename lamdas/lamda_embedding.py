from config import UserClass
from embedding_processors import PageIndexClass
from cloud_services import StorageBucket, EventBridgeClass
from pyresilience import TimeoutConfig, RetryConfig, resilient

bucket_service = StorageBucket()
json_strucher_processor = PageIndexClass()
eb_service = EventBridgeClass()


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
def lambda_trigeer(context, event):
    try:

        user_id = event["requestContext"]["authorizer"]["claims"]["sub"]
        docs = event["body"]
        document = bucket_service.get_docuemnt_from_bucket(
            file=docs, file_path=docs)
        # json tree maker
        json_tree, doc_id = json_strucher_processor.process_document_jsontree(
            path=document)
        # saving the json tree in user context runtime workflow
        ctx = UserClass(
            sub=user_id,
            json_tree=json_tree,
            doc_id=doc_id
        )
        # Event trigger process has to be done
        event_bridge_respones = eb_service.create_event_for_event_bridge(
            ctx=ctx)
        return event_bridge_respones
    except Exception as error:
        raise RuntimeError(error)
