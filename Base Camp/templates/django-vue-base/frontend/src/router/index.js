import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { useAdminStore } from '../stores/admin'

// Lazy-loaded views
const HomeView = () => import('../views/HomeView.vue')
const AboutView = () => import('../views/AboutView.vue')
const LoginView = () => import('../views/LoginView.vue')
const RegisterView = () => import('../views/RegisterView.vue')

// Admin views (lazy)
const AdminLoginView = () => import('../views/admin/AdminLoginView.vue')
const AdminDashboardView = () => import('../views/admin/AdminDashboardView.vue')

const routes = [
  { path: '/', name: 'home', component: HomeView },
  { path: '/about', name: 'about', component: AboutView },
  { path: '/login', name: 'login', component: LoginView },
  { path: '/register', name: 'register', component: RegisterView },

  // Admin routes
  { path: '/admin/login', name: 'admin-login', component: AdminLoginView },
  { path: '/admin', name: 'admin-home', component: AdminDashboardView, meta: { requiresAdmin: true } },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  linkActiveClass: 'active',
  linkExactActiveClass: 'active',
})

router.beforeEach((to) => {
  if (to.meta?.requiresAuth) {
    const auth = useAuthStore()
    if (!auth.isAuthenticated) {
      return { name: 'login', query: { next: to.fullPath } }
    }
  }
  if (to.meta?.requiresAdmin) {
    const admin = useAdminStore()
    if (!admin.isAuthenticated) {
      return { name: 'admin-login', query: { next: to.fullPath } }
    }
  }
  return true
})

export default router
