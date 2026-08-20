import CryptoJS from 'crypto-js';

// --- V1 LEGACY CRYPTO ---
// Uses MD5 derivation (EVP_BytesToKey) inside CryptoJS
// Maintained ONLY for backward compatibility with old data.

const ITERATIONS_V1 = 100000;
const KEY_SIZE = 256 / 32;

export function deriveKeyEncryptionKeyV1(password, salt) {
    const derived = CryptoJS.PBKDF2(password, salt, {
        keySize: KEY_SIZE,
        iterations: ITERATIONS_V1,
        hasher: CryptoJS.algo.SHA256
    });
    return derived.toString(CryptoJS.enc.Hex);
}

export function decryptKeyV1(encryptedMasterKey, kek) {
    try {
        const bytes = CryptoJS.AES.decrypt(encryptedMasterKey, kek);
        const originalText = bytes.toString(CryptoJS.enc.Utf8);
        return originalText || null;
    } catch (e) {
        return null;
    }
}

export function decryptDataV1(ciphertext, masterKey) {
    if (!ciphertext) return ciphertext;
    try {
        const bytes = CryptoJS.AES.decrypt(ciphertext, masterKey);
        const originalText = bytes.toString(CryptoJS.enc.Utf8);
        return originalText || ciphertext;
    } catch (e) {
        return ciphertext;
    }
}
