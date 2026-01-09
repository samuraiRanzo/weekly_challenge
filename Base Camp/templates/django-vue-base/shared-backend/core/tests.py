from django.test import TestCase
from django.urls import reverse

class BaseCampHealthCheck(TestCase):
    def test_hello_endpoint(self):
        """Verify the Clean Slate shared-backend is responding."""
        url = reverse('hello')
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json()['message'], "Hello from the Clean Slate Backend!")