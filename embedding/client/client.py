from abc import ABC, abstractmethod
from pageindex import PageIndexClient, PageIndexAPIError
from config import settings
import logging
import asyncio


class EmbeddingClient(ABC):
    @abstractmethod
    def create_embedded_docs(self) -> dict[str]: ...


class EmbeddingLessProcess(EmbeddingClient):
    def __init__(self):
        self.client = PageIndexClient(api_key=settings.pageindex_api_key)
        self.logger = logging.getLogger(__name__)

    async def create_embedded_docs(self, file_path: str) -> dict[str]:
        """
        args:
        - file_path:str
        """
        file = f"./{file_path}"
        try:
            docs = self.client.submit_document(file_path=file)
            docs_id = docs.get("doc_id")
            tree_result = self.client.get_tree(doc_id=docs_id)
            is_avalavile: bool = False
            while True:
                if tree_result.get("status") != "completed":
                    self.logger.info("tree strucher is processing")

                elif tree_result.get("status") == "completed":
                    is_avalavile = True
                    json_tree = await tree_result.get("result")
                    self.logger.debug(
                        "tree has been parsed suces fully")
                    return json_tree, docs_id
                elif is_avalavile == True:
                    break
                else:
                    asyncio.sleep(5)
        except Exception as error:
            self.logger.exception(
                "can't process the pdf to pasrse the tree")
            raise PageIndexAPIError(error)


class EmbeddingProcess(EmbeddingClient):
    ...
