from service import RetriverService

retriver_service = RetriverService()


async def lamda_fuction(event, context):
    user_id = event.get("sub")
    document_id = event.get("document_id")
    query = event.get("query")
    respones = await retriver_service.run_retriver(document_id=document_id, query=query)
    return respones
