from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated

class HelloView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        user = request.user  # Get the authenticated user
        name = request.data.get('name') or user.username or 'default_name'
        return Response({'message': f'Hello, {name}!'})
