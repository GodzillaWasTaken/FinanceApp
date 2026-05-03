import CryptoJS from 'crypto-js';

// Costanti
const ITERATIONS = 100000;
const KEY_SIZE = 256 / 32;

/**
 * Genera una Master Key casuale a 256-bit (32 byte).
 * @returns {string} Master Key in formato esadecimale.
 */
export function generateMasterKey() {
    return CryptoJS.lib.WordArray.random(32).toString(CryptoJS.enc.Hex);
}

/**
 * Genera una Recovery Key casuale (es. per il salvataggio offline).
 * Usiamo 16 byte per renderla più facile da digitare.
 * @returns {string} Recovery Key in formato esadecimale.
 */
export function generateRecoveryKey() {
    return CryptoJS.lib.WordArray.random(16).toString(CryptoJS.enc.Hex);
}

/**
 * Deriva una Key Encryption Key (KEK) usando PBKDF2 dalla password.
 * Usiamo lo username come salt per renderlo unico per utente.
 * @param {string} password 
 * @param {string} salt (es. username)
 * @returns {string} KEK in formato esadecimale.
 */
export function deriveKeyEncryptionKey(password, salt) {
    const derived = CryptoJS.PBKDF2(password, salt, {
        keySize: KEY_SIZE,
        iterations: ITERATIONS,
        hasher: CryptoJS.algo.SHA256
    });
    return derived.toString(CryptoJS.enc.Hex);
}

/**
 * Cifra la Master Key usando la KEK (Password o Recovery).
 * @param {string} masterKey 
 * @param {string} kek 
 * @returns {string} Master Key cifrata.
 */
export function encryptKey(masterKey, kek) {
    return CryptoJS.AES.encrypt(masterKey, kek).toString();
}

/**
 * Decifra la Master Key usando la KEK (Password o Recovery).
 * @param {string} encryptedMasterKey 
 * @param {string} kek 
 * @returns {string|null} Master Key decifrata o null se fallisce.
 */
export function decryptKey(encryptedMasterKey, kek) {
    try {
        const bytes = CryptoJS.AES.decrypt(encryptedMasterKey, kek);
        const originalText = bytes.toString(CryptoJS.enc.Utf8);
        return originalText || null;
    } catch (e) {
        return null;
    }
}

/**
 * Cifra un dato testuale (es. titolo, descrizione) usando la Master Key.
 * @param {string} text 
 * @param {string} masterKey 
 * @returns {string} Ciphertext.
 */
export function encryptData(text, masterKey) {
    if (!text) return text;
    return CryptoJS.AES.encrypt(text, masterKey).toString();
}

/**
 * Decifra un dato testuale usando la Master Key.
 * Se la decifratura fallisce (es. dato non cifrato o chiave errata),
 * restituisce il testo originale (utile per la transizione o errori).
 * @param {string} ciphertext 
 * @param {string} masterKey 
 * @returns {string} Testo in chiaro.
 */
export function decryptData(ciphertext, masterKey) {
    if (!ciphertext) return ciphertext;
    try {
        // Un semplice check per non tentare di decifrare testo normale
        if (!ciphertext.startsWith('U2FsdGVkX1')) {
            return ciphertext;
        }
        const bytes = CryptoJS.AES.decrypt(ciphertext, masterKey);
        const originalText = bytes.toString(CryptoJS.enc.Utf8);
        return originalText || ciphertext;
    } catch (e) {
        return ciphertext;
    }
}
