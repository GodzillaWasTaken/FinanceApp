/**
 * =========================================================================
 * END-TO-END ENCRYPTION (E2EE) ROUTER
 * =========================================================================
 * This file acts as an interceptor to provide backward compatibility.
 * 
 * V1 (Legacy): Used MD5 and EVP_BytesToKey within CryptoJS. 
 *              Produces ciphertexts starting with 'U2FsdGVkX1'.
 *              Maintained ONLY for reading existing data in the DB.
 * 
 * V2 (Modern): Uses pure AES-256-CBC with explicitly generated 16-byte IVs.
 *              Produces ciphertexts in the format 'IV(hex):Ciphertext(b64)'.
 *              Used for ALL new encryptions (new items, or when editing old items).
 * =========================================================================
 */

import { deriveKeyEncryptionKeyV1, decryptKeyV1, decryptDataV1 } from './crypto_v1';
import { generateMasterKeyV2, generateRecoveryKeyV2, deriveKeyEncryptionKeyV2, encryptDataV2, decryptDataV2 } from './crypto_v2';

// ---------------------------------------------------------
// 1. KEY GENERATION (Always V2)
// ---------------------------------------------------------
export function generateMasterKey() {
    return generateMasterKeyV2();
}

export function generateRecoveryKey() {
    return generateRecoveryKeyV2();
}

// ---------------------------------------------------------
// 2. KEK DERIVATION (Context Aware)
// ---------------------------------------------------------
// During Login, if the `encrypted_master_key` is V1, we must use V1 (100k iterations).
// Otherwise we use V2 (210k iterations).
export function deriveKeyEncryptionKey(password, salt, isLegacyV1 = false) {
    if (isLegacyV1) {
        return deriveKeyEncryptionKeyV1(password, salt);
    }
    return deriveKeyEncryptionKeyV2(password, salt);
}

// ---------------------------------------------------------
// 3. MASTER KEY ENCRYPTION / DECRYPTION
// ---------------------------------------------------------
export function encryptKey(masterKey, kek) {
    return encryptDataV2(masterKey, kek);
}

export function decryptKey(encryptedMasterKey, kek) {
    if (!encryptedMasterKey) return null;
    if (encryptedMasterKey.startsWith('U2FsdGVkX1')) {
        return decryptKeyV1(encryptedMasterKey, kek);
    }
    return decryptDataV2(encryptedMasterKey, kek);
}

// ---------------------------------------------------------
// 4. DATA ENCRYPTION / DECRYPTION
// ---------------------------------------------------------
// Always encrypt using the modern V2 algorithm.
export function encryptData(text, masterKey) {
    if (!text) return text;
    return encryptDataV2(text, masterKey);
}

// Decrypt intelligently based on the ciphertext signature.
export function decryptData(ciphertext, masterKey) {
    if (!ciphertext) return ciphertext;
    
    if (ciphertext.startsWith('U2FsdGVkX1')) {
        return decryptDataV1(ciphertext, masterKey);
    } else if (ciphertext.includes(':')) {
        return decryptDataV2(ciphertext, masterKey);
    }
    
    // Fallback if not encrypted (e.g. legacy plain text before E2E)
    return ciphertext;
}
