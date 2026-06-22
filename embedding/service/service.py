from client import EmbeddingClient
from pageindex import PageIndexAPIError
import logging


class EmbeddingService:
    def __init__(self, client: EmbeddingClient):
        self.client = client
        self.logger = logging.getLogger(__name__)

    def cerate_knowladgebase(self, file) -> dict[str]:
        try:
            self.logger.info("embedding opration succesfully completed")
            return self.client.create_embedded_docs(file)
        except PageIndexAPIError as error:
            self.logger.exception("embedding service faild:", {error})
            raise RuntimeError(
                "embedding opration unsuccesfull please try again later") from error
