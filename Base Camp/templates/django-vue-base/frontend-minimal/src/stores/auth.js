import { defineStore } from 'pinia'
import { apiLogin, apiRegister, apiRefresh, apiUser } from '../services/auth'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    // Load initial state directly from individual localStorage keys
    access: localStorage.getItem('access_token') || null,
    refresh: localStorage.getItem('refresh_token') || null,
    user: null, // User object usually needs to be fetched fresh
    loading: false,
    error: null,
  }),

  getters: {
    isAuthenticated: (state) => !!state.access,
  },

  actions: {
    /**
     * Helper to sync tokens to localStorage
     */
    persistTokens(access, refresh) {
      this.access = access;
      this.refresh = refresh;
      if (access) localStorage.setItem('access_token', access);
      if (refresh) localStorage.setItem('refresh_token', refresh);
    },

    async login({ email, password }) {
      this.error = null
      this.loading = true
      try {
        const data = await apiLogin({ email, password })

        // data expected: { access, refresh, user }
        this.persistTokens(data.access, data.refresh)
        this.user = data.user

        return data
      } catch (e) {
        // Use the error message from Django if available
        this.error = e.response?.data?.detail || e.message || 'Login failed'
        throw e
      } finally {
        this.loading = false
      }
    },

    async register(payload) {
      this.error = null
      this.loading = true
      try {
        const user = await apiRegister(payload)
        // Auto-login after registration
        if (payload.email && payload.password) {
          return await this.login({ email: payload.email, password: payload.password })
        }
        this.user = user
        return user
      } catch (e) {
        this.error = e.response?.data?.detail || 'Registration failed'
        throw e
      } finally {
        this.loading = false
      }
    },

    async loadUser() {
      if (!this.access) return null
      try {
        const data = await apiUser()
        this.user = data
        return data
      } catch (e) {
        // If apiUser fails, the token might be invalid/expired
        if (this.refresh) {
            return await this.refreshAccess()
        }
        this.logout()
        return null
      }
    },

    async refreshAccess() {
      if (!this.refresh) {
        this.logout()
        return null
      }
      try {
        const data = await apiRefresh(this.refresh)
        this.persistTokens(data.access, this.refresh)
        return data.access
      } catch (e) {
        this.logout()
        return null
      }
    },

    logout() {
      this.access = null
      this.refresh = null
      this.user = null
      this.error = null
      localStorage.removeItem('access_token')
      localStorage.removeItem('refresh_token')
    }
  }
})