import CryptoJS from 'crypto-js';

// --- V2 MODERN CRYPTO ---
// Uses pure AES-256-CBC with explicitly generated IVs.
// Bypasses the insecure MD5 EVP_BytesToKey algorithm.
// Ciphertext format: "IV_HEX:CIPHERTEXT_BASE64"

const ITERATIONS_V2 = 210000;
const KEY_SIZE = 256 / 32; // 8 words = 32 bytes = 256 bits

export function generateMasterKeyV2() {
    return CryptoJS.lib.WordArray.random(32).toString(CryptoJS.enc.Hex);
}

export function generateRecoveryKeyV2() {
    return CryptoJS.lib.WordArray.random(16).toString(CryptoJS.enc.Hex);
}

export function deriveKeyEncryptionKeyV2(password, salt) {
    const derived = CryptoJS.PBKDF2(password, salt, {
        keySize: KEY_SIZE,
        iterations: ITERATIONS_V2,
        hasher: CryptoJS.algo.SHA256
    });
    return derived.toString(CryptoJS.enc.Hex);
}

export function encryptDataV2(text, keyHex) {
    if (!text) return text;
    
    // Parse the hex key into a WordArray so CryptoJS doesn't use MD5 derivation
    const key = CryptoJS.enc.Hex.parse(keyHex);
    // Generate a random 16-byte (128-bit) IV
    const iv = CryptoJS.lib.WordArray.random(16);
    
    // Encrypt using pure AES-CBC
    const encrypted = CryptoJS.AES.encrypt(text, key, { iv: iv });
    
    // Return format: IV(hex) : Ciphertext(base64)
    return iv.toString(CryptoJS.enc.Hex) + ':' + encrypted.toString();
}

export function decryptDataV2(ciphertextPayload, keyHex) {
    if (!ciphertextPayload || !ciphertextPayload.includes(':')) {
        return ciphertextPayload; // Not V2 format
    }
    
    try {
        const parts = ciphertextPayload.split(':');
        const ivHex = parts[0];
        const ciphertextB64 = parts[1];
        
        const key = CryptoJS.enc.Hex.parse(keyHex);
        const iv = CryptoJS.enc.Hex.parse(ivHex);
        
        // Decrypt using pure AES-CBC
        // CryptoJS requires the ciphertext to be formatted as a CipherParams object
        // but passing the base64 string directly with the explicit IV also works.
        const decrypted = CryptoJS.AES.decrypt(ciphertextB64, key, { iv: iv });
        
        const originalText = decrypted.toString(CryptoJS.enc.Utf8);
        return originalText || ciphertextPayload;
    } catch (e) {
        console.error("V2 Decryption Error", e);
        return ciphertextPayload;
    }
}
