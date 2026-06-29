from dataclasses import asdict
from typing import Dict
import uuid
from pydantic import BaseModel


class UserClass(BaseModel):
    sub: None | str = None
    body: None | bytes = None
    doc_id: None | str = None
    json_tree: None | Dict[str] = None
    user_input: None | str = None
    user_output: None | str = None


class SystemSetting:
    pageindex_api_key: str
    S3_bucket: str
    db_table_name: str
    queue_name: str
    sfn_arn: str
    event_bridge_bus_name: str


userclass = UserClass()
systemsettings = SystemSetting()


def dict_maker(ctx: UserClass) -> Dict:
    return asdict(ctx)


def thread_id_maker() -> uuid:
    return uuid.uuid4()
