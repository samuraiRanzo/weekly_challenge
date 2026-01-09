import axios from 'axios';

// Create the Axios instance
const apiClient = axios.create({
  // baseURL is now the root to allow /apis/ and /admin-apis/ as siblings
 baseURL: '/',
  headers: { 'Content-Type': 'application/json' },
  timeout: 10000,
});

// SINGLE REQUEST INTERCEPTOR
apiClient.interceptors.request.use(
  (config) => {
    const adminToken = localStorage.getItem('admin_access');
    const userToken = localStorage.getItem('access_token');

    // 1. Prioritize Admin Token for admin-apis routes
    if (config.url.includes('admin-apis')) {
      if (adminToken) {
        config.headers.Authorization = `Bearer ${adminToken}`;
      }
    }
    // 2. Fallback to User Token for regular apis routes
    else if (userToken) {
      config.headers.Authorization = `Bearer ${userToken}`;
    }

    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// RESPONSE INTERCEPTOR (For 401 Unauthenticated handling)
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response && error.response.status === 401) {
      console.warn("Unauthorized request. Token may be expired.");
      // You can add logic here to trigger a logout or token refresh
    }
    return Promise.reject(error);
  }
);

export default apiClient;