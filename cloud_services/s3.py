import boto3
from helper import StorageBucketError
from config import systemsettings
import tempfile
import logging


class StorageBucket:
    """SotorageBucket"""

    def __init__(self):
        self.client = boto3.client("s3")
        self.logger = logging.getLogger(__name__)

    def get_docuemnt_from_bucket(self, file_path: str, file: str) -> None:
        """get_docuemtn_from_bucket()
        ```Args```
        file_path -> temoporary file path where the file is. 
        file -> the cuthual file has to be downloaded
        ```Returns```
        respones
        """
        try:
            path = f"../tmp/{file_path}"
            respones = self.client.download_file(
                Bucket=systemsettings.S3_bucket, key=file, Filename=path)

            self.logger.info(f"object downloded sussefully:{file}")
            return respones
        except Exception as error:
            self.logger.exception("faild to download the pdf")
            raise StorageBucketError(error)
        finally:
            self.client.close()
            self.logger.debug(
                f"{__class__} has benn closed with excution succesfully")
