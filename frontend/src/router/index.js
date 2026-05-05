import { createRouter, createWebHistory } from 'vue-router';
import CashFlowDashboardView from '../views/cashflow/CashFlowDashboardView.vue';
import LoginView from '../views/LoginView.vue';
import SettingsView from '../views/SettingsView.vue';
import ProfileView from '../views/ProfileView.vue';
import NotFundView from '../views/NotFundView.vue';
import IncomeDetailView from '../views/cashflow/IncomeDetailView.vue';
import ExpenseDetailView from '../views/cashflow/ExpenseDetailView.vue';
import AddModifiyView from '../views/cashflow/AddModifyTransactionView.vue';
import RegisterView from '../views/RegisterView.vue';
import AdminSettingsView from '../views/AdminSettingsView.vue';
import SetupView from '../views/SetupView.vue';
import { getGlobalSettings } from '../apicalls/apiCalls';

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: LoginView,
  },
  {
    path: '/register',
    name: 'Register',
    component: RegisterView,
  },
  {
    path: '/setup',
    name: 'Setup',
    component: SetupView,
  },
  {
    path: '/admin-settings',
    name: 'AdminSettings',
    component: AdminSettingsView,
    meta: {
      authenticationRequired: true,
    },
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
    // temporary for development; once the full dashboard is included, that will be the endpoint
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
    path: '/cashflow/income',
    name: 'Income',
    component: IncomeDetailView,
    meta: {
      authenticationRequired: true,
    },
  },
  {
    path: '/cashflow/expenses',
    name: 'Expenses',
    component: ExpenseDetailView,
    meta: {
      authenticationRequired: true,
    },
  },
  {
    path: '/addmodifytransaction',
    name: 'AddModifyTransaction',
    component: AddModifiyView,
    props: () => ({
      movement: history.state?.movement ?? null
    }),

    meta: {
      authenticationRequired: true,
    }
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

router.beforeEach(async (to, from, next) => {
  let isInitialized = sessionStorage.getItem('isInitialized');
  
  if (isInitialized === null) {
    try {
        const settings = await getGlobalSettings();
        isInitialized = settings.is_initialized ? 'true' : 'false';
        sessionStorage.setItem('isInitialized', isInitialized);
    } catch (e) {
        console.error("Failed to check initialization status:", e);
        isInitialized = 'true'; // Fallback
    }
  }

  if (isInitialized === 'false' && to.path !== '/setup') {
      return next('/setup');
  }

  if (isInitialized === 'true' && to.path === '/setup') {
      return next('/login');
  }

  const isAuthenticated = !!localStorage.getItem('authToken');
  if (to.meta.authenticationRequired && !isAuthenticated) {
    next('/login');
  } else {
    next();
  }
});

export default router;
