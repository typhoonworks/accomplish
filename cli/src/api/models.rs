// src/api/types.rs
use serde::Deserialize;

#[derive(Debug, Deserialize)]
pub struct DeviceCodeResponse {
    // pub interval: u64,
    pub user_code: String,
    // pub device_code: String,
    // pub expires_in: u64,
    pub verification_uri: String,
    pub verification_uri_complete: String,
}

#[derive(Deserialize, Debug)]
pub struct TokenResponse {
    pub access_token: String,
    pub token_type: String,
    pub expires_in: u64,
    pub refresh_token: String,
    pub scope: String,
}
