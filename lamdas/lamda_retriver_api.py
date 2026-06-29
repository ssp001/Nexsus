from cloud_services import StepFunctionExecutor
from config import dict_maker, UserClass, systemsettings

sfn = StepFunctionExecutor()


def lambda_handeler(context, event):
    try:
        user_id = user_id = event["requestContext"]["authorizer"]["claims"]["sub"]
        thread_id = event.get("thread_id")
        query = event.get("query")
        ctx = UserClass(
            user_id=user_id,
            thread_id=thread_id,
            user_input=query
        )
        context = dict_maker(ctx=ctx)
        sfn.execute_and_wait(
            execution_name=f"{user_id}_execution",
            payload=context,
            poll_interval=9,
            state_machine_arn=systemsettings.sfn_arn,
            timeout_seconds=30)
        return {
            "thread_id": context.get("thread_id"),
            "user_id": context.get("user_id"),
            "query": context.get("query")
        }

    except Exception as error:
        raise RuntimeError(error)
