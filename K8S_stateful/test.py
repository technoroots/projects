import unittest
import flask_testing
from app import create_app

# your test cases

class testClass(unittest.TestCase):

    def setUp(self):
        """Define test variables and initialize app."""
        self.app = create_app(config_name="development")
        self.client = self.app.test_client


    def test_health_check(self):
        response = self.client().get('/health', follow_redirects=True)
        self.assertEqual(response.status_code, 200)

    def test_search_url(self):
        response = self.client().get('/search', follow_redirects=True)
        self.assertEqual(response.status_code, 200)

    def test_configs_url(self):
        response = self.client().get('/configs', follow_redirects=True)
        self.assertEqual(response.status_code, 200)



if __name__ == '__main__':
    unittest.main()
