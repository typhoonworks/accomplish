use crate::api::client::ApiClient;
use crate::api::errors::ApiError;
use crate::api::models::DeviceCodeResponse;
use serde::Deserialize;
use serde_json::json;

#[derive(Deserialize, Debug)]
pub struct DeviceGrantResponse {
    pub device_code: String,
    pub user_code: String,
    pub verification_uri: String,
}

pub async fn initiate_device_code(
  api_client: &ApiClient,
  client_id: &str,
) -> Result<DeviceCodeResponse, ApiError> {
  let body = json!({
      "client_id": client_id,
      "scope": "user:read,user:write"
  });


  let response = api_client.post("auth/device/code", body).await?;
  let device_code_response: DeviceCodeResponse = response
      .json()
      .await
      .map_err(|e| ApiError::DecodeError(e.to_string()))?;

  Ok(device_code_response)
}

#[derive(Deserialize, Debug)]
pub struct TokenResponse {
    pub access_token: String,
    pub token_type: String,
    pub expires_in: u64,
    pub refresh_token: String,
    pub scope: String,
}

pub async fn exchange_device_code_for_token(
  api_client: &ApiClient,
  device_code: &str,
) -> Result<TokenResponse, ApiError> {
  let body = json!({
      "device_code": device_code
  });

  let response = api_client.post("auth/device/token", body).await?;
  let token_response: TokenResponse = response
      .json()
      .await
      .map_err(|e| ApiError::DecodeError(e.to_string()))?;

  Ok(token_response)
}
