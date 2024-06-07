from django.test import TestCase
from .models import MyModel

class MyModelTestCase(TestCase):
    def setUp(self):
        # Create test data or perform setup tasks
        self.my_model = MyModel.objects.create(name='Test')

    def test_model_creation(self):
        # Retrieve the object from the database
        obj = MyModel.objects.get(name='Test')
        
        # Verify that the object was created correctly
        self.assertEqual(obj.name, 'Test')

