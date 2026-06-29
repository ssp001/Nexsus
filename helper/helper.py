class PageIndexError(Exception):
    def __init__(self, message):
        self.message = message
        super().__init__(self.message)


class DynamodbError(Exception):
    def __init__(self, message):
        self.message = message
        super().__init__(self.message)


class SQSError(Exception):
    def __init__(self, message):
        self.message = message
        super().__init__(self.message)


class StorageBucketError(Exception):
    def __init__(self, message):
        self.message = message
        super().__init__(self.message)


class EventBridgeError(Exception):
    def __init__(self, message):
        self.message = message
        super().__init__(self.message)
