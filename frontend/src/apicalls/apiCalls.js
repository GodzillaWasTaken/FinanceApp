import axiosInstance from '../axios';
import { encryptData, decryptData } from '../helpers/crypto';

// Helpers per E2EE
function encryptMovimentoPayload(data) {
    const masterKey = sessionStorage.getItem('masterKey');
    if (!masterKey || !data) return data;
    const encrypted = { ...data };
    if (encrypted.titolo) encrypted.titolo = encryptData(encrypted.titolo, masterKey);
    if (encrypted.descrizione) encrypted.descrizione = encryptData(encrypted.descrizione, masterKey);
    return encrypted;
}

function decryptMovimentoResponse(item) {
    const masterKey = sessionStorage.getItem('masterKey');
    if (!masterKey || !item) return item;
    const decrypted = { ...item };
    if (decrypted.titolo) decrypted.titolo = decryptData(decrypted.titolo, masterKey);
    if (decrypted.descrizione) decrypted.descrizione = decryptData(decrypted.descrizione, masterKey);
    return decrypted;
}

// Helper generico per le richieste API
function apiRequest(endpoint, method = 'GET', data = null, params = null) {
    const config = {
        url: endpoint,
        method,
    };
    if (data) config.data = data;
    if (params) config.params = params;
    return axiosInstance(config).then(res => res.data);
}

// -------------------- CONTI --------------------
export function getConti(page = 1, pageSize = 10) {
    return apiRequest('/api/conti/', 'GET', null, { page, page_size: pageSize });
}
export function getConto(id) {
    return apiRequest(`/api/conti/${id}/`, 'GET');
}
export function createConto(data) {
    return apiRequest('/api/conti/', 'POST', data);
}
export function updateConto(id, data) {
    return apiRequest(`/api/conti/${id}/`, 'PATCH', data);
}
export function deleteConto(id) {
    return apiRequest(`/api/conti/${id}/`, 'DELETE');
}

export function getAllConti() {
    return apiRequest('/api/conti/', 'GET', null, { page_size: 'all' });
}

// -------------------- CATEGORIE --------------------
export function getCategorie(page = 1, pageSize = 10) {
    return apiRequest('/api/categorie/', 'GET', null, { page, page_size: pageSize });
}
export function getCategoria(id) {
    return apiRequest(`/api/categorie/${id}/`, 'GET');
}
export function createCategoria(data) {
    return apiRequest('/api/categorie/', 'POST', data);
}
export function updateCategoria(id, data) {
    return apiRequest(`/api/categorie/${id}/`, 'PATCH', data);
}
export function deleteCategoria(id) {
    return apiRequest(`/api/categorie/${id}/`, 'DELETE');
}

export function getAllCategorie() {
    return apiRequest('/api/categorie/', 'GET', null, { page_size: 'all' });
}

// -------------------- MOVIMENTI --------------------
export function getMovimenti(page = 1, pageSize = 10) {
    return apiRequest('/api/movimenti/', 'GET', null, { page, page_size: pageSize }).then(res => {
        if (res.results) {
            res.results = res.results.map(decryptMovimentoResponse);
        } else if (Array.isArray(res)) {
            res = res.map(decryptMovimentoResponse);
        }
        return res;
    });
}
export function getMovimento(id) {
    return apiRequest(`/api/movimenti/${id}/`, 'GET').then(decryptMovimentoResponse);
}
export function createMovimento(data) {
    const encryptedData = encryptMovimentoPayload(data);
    return apiRequest('/api/movimenti/', 'POST', encryptedData).then(decryptMovimentoResponse);
}
export function updateMovimento(id, data) {
    const encryptedData = encryptMovimentoPayload(data);
    return apiRequest(`/api/movimenti/${id}/`, 'PATCH', encryptedData).then(decryptMovimentoResponse);
}
export function deleteMovimento(id) {
    return apiRequest(`/api/movimenti/${id}/`, 'DELETE');
}

// -------------------- UTENTE (Djoser) --------------------
export function getCurrentUser() {
    return apiRequest('/api/auth/users/me/', 'GET');
}
export function updateCurrentUser(data) {
    return apiRequest('/api/auth/users/me/', 'PATCH', data);
}

// -------------------- AUTHENTICATION & SETTINGS --------------------
export function login(username, password) {
    return apiRequest('/api/auth/jwt/create/', 'POST', { username, password });
}

export function customRegister(data) {
    return apiRequest('/api/auth/register/', 'POST', data);
}

export function getUserProfile() {
    return apiRequest('/api/auth/profile/', 'GET');
}

export function getGlobalSettings() {
    return apiRequest('/api/settings/', 'GET');
}

export function updateRegistrationGlobalSettings(allow_registration) {
    return apiRequest('/api/settings/', 'PATCH', { allow_registration });
}