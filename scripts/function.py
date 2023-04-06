def lambda_handler(event, content):
    message = 'Hello {} !'.format(event['key1'])
    return {
        'message' : message
    }