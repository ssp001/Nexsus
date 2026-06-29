import logging
import polling2
from pageindex import PageIndexClient
from config import SystemSetting
from helper import PageIndexError


class PageIndexClass:
    def __init__(self):
        self.client = PageIndexClient(api_key=SystemSetting.pageindex_api_key)
        self.logger = logging.getLogger(__name__)

    def process_document_jsontree(self, path: str) -> dict:
        try:
            # Create a temporary file to store the PDF
            self.logger.info(
                "pdf path has been created going to futher process")
            # method to get the document JSON tree
            response = self.client.submit_document(file_path=path)
            # parse the doc_id
            document_id = response["doc_id"]
            # Process the document JSON tree using the PageIndexClient
            self.logger.info("strating polling process for pagenidex api call")
            tree_result = polling2.poll(
                target=lambda: self.client.get_tree(doc_id=document_id),
                step=5,
                timeout=120,
                check_success=lambda tree_result: tree_result.get(
                    "status") == "completed"
            )
            self.logger.info("json tree has been created")
            json_tree = tree_result.get("result")
            return json_tree, document_id
        except Exception as e:
            self.logger.error(f"Error processing document JSON tree: {e}")
            raise PageIndexError("pageindex api call timeout")

    async def retrive_document(self, query: str, doc_id: str):
        try:
            self.logger.info("startring parsing opration")
            # make retriver call
            for chunk in await self.client.chat_completions(
                messages=[
                    {"role": "user", "content": query}
                ],
                doc_id=f"{doc_id}",
                stream=True
            ):
                self.logger.info("parsing opration sucess full")
                yield chunk
        except Exception as error:
            self.logger.exception(
                f"an error occured pageindex api error:{error}")
            raise PageIndexError("can't parse the the document")
