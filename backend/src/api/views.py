from rest_framework.views import APIView
from rest_framework.response import Response

class HelloView(APIView):
    def post(self, request):
        name = request.data.get('name', 'default_name') 
        return Response({'message': f'Hello, {name}!'})
