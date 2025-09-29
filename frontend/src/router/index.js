import { createRouter, createWebHistory } from 'vue-router';
import CashFlowDashboardView from '../views/CashFlowDashboardView.vue';
import LoginView from '../views/LoginView.vue';
import SettingsView from '../views/SettingsView.vue';
import ProfileView from '../views/ProfileView.vue';
import NotFundView from '../views/NotFundView.vue';


const routes = [
  {
    path: '/login',
    name: 'Login',
    component: LoginView,
  },
  {
    path: '/cashflow',
    name: 'CashFlowDashboard',
    component: CashFlowDashboardView,
    meta: {
      authenticationRequired: true,
    },
  },
  {
      // temporanea per sviluppo una volta inclusa la dashbpard completa sarà quella l'endpoint
    path: '/',
    name: 'Home',
    component: CashFlowDashboardView,
    meta: {
      authenticationRequired: true,
    },
  },
  {
    path: '/settings',
    name: 'Settings',
    component: SettingsView,
    meta: {
      authenticationRequired: true,
    },
  },
  {
    path: '/profile',
    name: 'Profile',
    component: ProfileView,
    meta: {
      authenticationRequired: true,
    },
  },
  {
    path: '/:catchAll(.*)', 
    name: 'NotFound',     
    component: NotFundView, 
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach((to, from, next) => {
  const isAuthenticated = !!localStorage.getItem('authToken');
  if (to.meta.authenticationRequired && !isAuthenticated) {
    next('/login');
  } else {
    next();
  }
});

export default router;
