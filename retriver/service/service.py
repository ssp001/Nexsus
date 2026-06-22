from client import RetriverClient
from pageindex.client import PageIndexAPIError
import logging


class RetriverService:
    def __init__(self, client: RetriverClient):
        self.client = client
        self.logger = logging.getLogger(__name__)

    async def run_retriver(self, document_id: str, query: str):
        try:
            self.logger.info("retriver opration succesfully completed")
            return self.client.retrive_docs(document_id, query)
        except PageIndexAPIError as error:
            self.logger.exception("embedding service faild:", {error})
            raise RuntimeError(
                "retriver opration unsuccesfull please try again later") from error
