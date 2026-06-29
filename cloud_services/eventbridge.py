import boto3
from helper import EventBridgeError
from config import systemsettings, UserClass
import logging
import json


class EventBridgeClass:
    def __init__(self):
        self.client = boto3.client('events')
        self.logger = logging.getLogger(__name__)

    def create_event_for_event_bridge(self, ctx: UserClass | None = None):
        try:
            event = {
                'Source': 'my.application',
                'DetailType': 'db_putobject_event',
                'Detail': json.dumps(ctx),
                'EventBusName': "defult"
            }
            self.logger.info("event has been created")
            response = self.client.put_events(Entries=[event])
            self.logger.info(f"Event sent to EventBridge: {response}")
            return response
        except Exception as error:
            self.logger.exception("event bridge has an error:", {error})
            raise EventBridgeError(
                "error occured can't make a event bridge instance in this request")
        finally:
            self.client.close()
            self.logger.debug(
                f"{__class__} has benn closed with excution succesfully")
