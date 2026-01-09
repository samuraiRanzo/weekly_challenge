// services/adminAuth.js
import apiClient from '../apis/client'

/**
 * Admin Login
 * Returns: { access, refresh, user: { is_staff, is_superuser } }
 */
export async function adminLogin({ email, password }) {
  // Assuming your Django path is /apis/admin-apis/auth/login/
  const response = await apiClient.post('/admin-api/auth/login/', { email, password })
  return response.data
}

/**
 * Fetch Admin Profile
 */
export async function adminMe() {
  const response = await apiClient.get('/admin-api/auth/me/')
  return response.data
}