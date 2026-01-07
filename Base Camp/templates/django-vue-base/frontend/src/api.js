import axios from 'axios';

// Automatically detect if we are in development or production
const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000/api/';

const apiClient = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Add a request interceptor (useful for Season 2 when you add JWT tokens!)
apiClient.interceptors.request.use((config) => {
  // You can pull your token from localStorage here later
  // const token = localStorage.getItem('token');
  // if (token) config.headers.Authorization = `Bearer ${token}`;
  return config;
});

export default apiClient;