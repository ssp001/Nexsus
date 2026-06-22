from abc import ABC, abstractmethod
from pageindex.client import PageIndexAPIError, PageIndexClient
import logging
from config import settings


class RetriverClient(ABC):
    @abstractmethod
    def retrive_docs(self): ...


class PageIndexRetriver(RetriverClient):
    def __init__(self):
        self.client = PageIndexClient(api_key=settings.pageindex_api_key)
        self.logger = logging.getLogger(__name__)

    async def retrive_docs(self, query: str, document_id: str):
        try:
            for chunk in self.client.chat_completions(
                messages=[
                    {"role": "user", "content": query}
                ],
                doc_id=document_id,
                stream=True
            ):
                self.logger.info("document has been parsed sucssfully")
                return chunk
        except Exception as error:
            self.logger.exception(
                "document has been parsed sucssfully:", error)
            raise PageIndexAPIError("can't retrive docs information")
