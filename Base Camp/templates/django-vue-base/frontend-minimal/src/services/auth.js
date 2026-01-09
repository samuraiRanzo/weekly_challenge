// auth.js - Specialized service for Django JWT endpoints
import apiClient from '../apis/client'

/**
 * Registers a new user.
 * Axios automatically stringifies the payload.
 */
export async function apiRegister(payload) {
  const response = await apiClient.post('api/auth/register/', payload)
  return response.data
}

/**
 * Logs in a user.
 * On success, your interceptor in client.js will start
 * using the token once you save it to localStorage.
 */
export async function apiLogin({ email, password }) {
  // Expected response from Django: { access, refresh, user }
  const response = await apiClient.post('api/auth/login/', { email, password })
  return response.data
}

/**
 * Manually refresh the access token using the refresh token.
 */
export async function apiRefresh(refreshToken) {
  // Expected response: { access }
  const response = await apiClient.post('api/auth/refresh/', { refresh: refreshToken })
  return response.data
}

/**
 * Fetches the current authenticated user's profile.
 * The 'Authorization' header is added automatically by the client.js interceptor.
 */
export async function apiUser() {
  const response = await apiClient.get('api/auth/user/')
  return response.data
}