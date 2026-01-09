import { defineStore } from 'pinia'
import { adminLogin, adminMe } from '../services/adminAuth'
import { apiRefresh } from '../services/auth' // We reuse the same refresh logic

export const useAdminStore = defineStore('admin', {
  state: () => ({
    // Use unique keys for admin to prevent session mixing
    access: localStorage.getItem('admin_access') || null,
    refresh: localStorage.getItem('admin_refresh') || null,
    admin: null,
    loading: false,
    error: null,
  }),

  getters: {
    isAuthenticated: (state) => !!state.access,
    isAdmin: (state) => Boolean(state.admin?.is_staff || state.admin?.is_superuser),
  },

  actions: {
    persistAdminTokens(access, refresh) {
      this.access = access
      this.refresh = refresh
      if (access) localStorage.setItem('admin_access', access)
      if (refresh) localStorage.setItem('admin_refresh', refresh)
    },

    async login({ email, password }) {
      this.error = null
      this.loading = true
      try {
        const data = await adminLogin({ email, password })

        this.persistAdminTokens(data.access, data.refresh)
        this.admin = data.user

        return data
      } catch (e) {
        this.error = e.response?.data?.detail || 'Admin login failed'
        throw e
      } finally {
        this.loading = false
      }
    },

    async loadMe() {
      if (!this.access) return null
      try {
        const me = await adminMe()
        this.admin = me
        return me
      } catch (e) {
        // Attempt silent refresh if fetch fails
        if (this.refresh) {
          return await this.refreshAdminAccess()
        }
        this.logout()
        return null
      }
    },

    async refreshAdminAccess() {
      if (!this.refresh) {
        this.logout()
        return null
      }
      try {
        // Reuse the standard refresh service
        const data = await apiRefresh(this.refresh)
        this.persistAdminTokens(data.access, this.refresh)
        return data.access
      } catch (e) {
        this.logout()
        return null
      }
    },

    logout() {
      this.access = null
      this.refresh = null
      this.admin = null
      this.error = null
      localStorage.removeItem('admin_access')
      localStorage.removeItem('admin_refresh')
    }
  }
})