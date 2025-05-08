from config.mongo import mongodb



def get_all_conversation(username: str):
    res = mongodb.conv.find({"username": username})
    return

def get_conversation_by_id(id: str):
    return