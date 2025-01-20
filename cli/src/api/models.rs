// src/api/types.rs
use serde::Deserialize;

#[derive(Debug, Deserialize)]
pub struct DeviceCodeResponse {
    pub interval: u64,
    pub user_code: String,
    pub device_code: String,
    pub expires_in: u64,
    pub verification_uri: String,
    pub verification_uri_complete: String,
}
