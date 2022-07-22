def handler(event, context):
   message = 'Hello for second time {} !'.format(event['key1'])
   return {
       'message' : message
   }
