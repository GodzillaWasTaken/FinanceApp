import axiosInstance from '../axios';

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

// -------------------- MOVIMENTI --------------------
export function getMovimenti(page = 1, pageSize = 10) {
    return apiRequest('/api/movimenti/', 'GET', null, { page, page_size: pageSize });
}
export function getMovimento(id) {
    return apiRequest(`/api/movimenti/${id}/`, 'GET');
}
export function createMovimento(data) {
    return apiRequest('/api/movimenti/', 'POST', data);
}
export function updateMovimento(id, data) {
    return apiRequest(`/api/movimenti/${id}/`, 'PATCH', data);
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