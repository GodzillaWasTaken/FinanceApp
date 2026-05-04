import { defineStore } from 'pinia';
import { ref } from 'vue';

export const useAuthStore = defineStore('auth', () => {
    const token = ref(localStorage.getItem('authToken') || null);
    const refreshToken = ref(localStorage.getItem('refreshToken') || null);
    const isAuthenticated = ref(!!token.value);
    const masterKey = ref(sessionStorage.getItem('masterKey') || null); // E2EE Master Key (cleartext) in session

    function setTokens(access, refresh) {
        token.value = access;
        refreshToken.value = refresh;
        isAuthenticated.value = true;
        localStorage.setItem('authToken', access);
        if (refresh) localStorage.setItem('refreshToken', refresh);
    }

    function setMasterKey(key) {
        masterKey.value = key;
        sessionStorage.setItem('masterKey', key);
    }

    function logout() {
        token.value = null;
        refreshToken.value = null;
        isAuthenticated.value = false;
        masterKey.value = null;
        localStorage.removeItem('authToken');
        localStorage.removeItem('refreshToken');
        sessionStorage.removeItem('masterKey');
    }

    return { token, refreshToken, isAuthenticated, masterKey, setTokens, setMasterKey, logout };
});
