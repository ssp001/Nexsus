from service import EmbeddingService
from client import EmbeddingLessProcess

embedding_service = EmbeddingService(client=EmbeddingLessProcess())


def lambda_event(context, event):

    key = event.get("key")

    json_tree, docs_id = embedding_service.cerate_knowladgebase(file=key)
    return {
        "json_tree": json_tree,
        "document_id": docs_id
    }
