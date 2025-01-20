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
