use crate::api::client::ApiClient;
use crate::api::errors::ApiError;
use serde::Deserialize;

#[derive(Deserialize, Debug)]
pub struct DeviceGrantResponse {
    pub device_code: String,
    pub user_code: String,
    pub verification_uri: String,
}

pub async fn initiate_device_code(
    api_client: &ApiClient,
    client_id: &str,
) -> Result<DeviceGrantResponse, ApiError> {
    let payload = serde_json::json!({
        "client_id": client_id,
        "scope": "user:read,user:write"
    });

    let response = api_client.post("auth/device/code", payload).await?;

    response
        .json::<DeviceGrantResponse>()
        .await
        .map_err(|e| ApiError::DecodeError(e.to_string()))
}
