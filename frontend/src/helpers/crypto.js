import CryptoJS from 'crypto-js';

// Constants
const ITERATIONS = 100000;
const KEY_SIZE = 256 / 32;

/**
 * Generates a random 256-bit (32-byte) Master Key.
 * @returns {string} Master Key in hexadecimal format.
 */
export function generateMasterKey() {
    return CryptoJS.lib.WordArray.random(32).toString(CryptoJS.enc.Hex);
}

/**
 * Generates a random Recovery Key (e.g., for offline backup).
 * We use 16 bytes to make it easier to type.
 * @returns {string} Recovery Key in hexadecimal format.
 */
export function generateRecoveryKey() {
    return CryptoJS.lib.WordArray.random(16).toString(CryptoJS.enc.Hex);
}

/**
 * Derives a Key Encryption Key (KEK) using PBKDF2 from the password.
 * We use the username as a salt to make it unique per user.
 * @param {string} password 
 * @param {string} salt (e.g., username)
 * @returns {string} KEK in hexadecimal format.
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
 * Encrypts the Master Key using the KEK (Password or Recovery).
 * @param {string} masterKey 
 * @param {string} kek 
 * @returns {string} Encrypted Master Key.
 */
export function encryptKey(masterKey, kek) {
    return CryptoJS.AES.encrypt(masterKey, kek).toString();
}

/**
 * Decrypts the Master Key using the KEK (Password or Recovery).
 * @param {string} encryptedMasterKey 
 * @param {string} kek 
 * @returns {string|null} Decrypted Master Key or null if it fails.
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
 * Encrypts textual data (e.g., title, description) using the Master Key.
 * @param {string} text 
 * @param {string} masterKey 
 * @returns {string} Ciphertext.
 */
export function encryptData(text, masterKey) {
    if (!text) return text;
    return CryptoJS.AES.encrypt(text, masterKey).toString();
}

/**
 * Decrypts textual data using the Master Key.
 * If decryption fails (e.g., data not encrypted or incorrect key),
 * returns the original text (useful for transition or errors).
 * @param {string} ciphertext 
 * @param {string} masterKey 
 * @returns {string} Plaintext.
 */
export function decryptData(ciphertext, masterKey) {
    if (!ciphertext) return ciphertext;
    try {
        // A simple check to avoid trying to decrypt normal text
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
