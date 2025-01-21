use crate::api::client::ApiClient;
use crate::api::errors::ApiError;
use crate::api::models::DeviceCodeResponse;
use crate::api::models::TokenResponse;
use serde_json::json;

pub async fn initiate_device_code(
    api_client: &ApiClient,
    client_id: &str,
) -> Result<DeviceCodeResponse, ApiError> {
    let body = json!({
        "client_id": client_id,
        "scope": "user:read,user:write"
    });

    let device_code_response: DeviceCodeResponse =
        api_client.post("auth/device/code", body).await?;

    Ok(device_code_response)
}

pub async fn exchange_device_code_for_token(
    api_client: &ApiClient,
    device_code: &str,
) -> Result<TokenResponse, ApiError> {
    let body = json!({
        "device_code": device_code
    });

    let token_response: TokenResponse = api_client.post("auth/device/token", body).await?;

    Ok(token_response)
}

#[cfg(test)]
mod tests {
    use super::*;
    use mockito::{mock, Matcher};
    use serde_json::json;
    use tokio;

    #[tokio::test]
    async fn test_initiate_device_code() {
        let _m = mock("POST", "/auth/device/code")
            .match_body(Matcher::Json(json!({
                "client_id": "test-client-id",
                "scope": "user:read,user:write"
            })))
            .with_status(200)
            .with_body(
                r#"{
               "user_code": "user_code_456",
               "verification_uri": "http://example.com",
               "verification_uri_complete": "http://example.com?user_code=user_code_456"
           }"#,
            )
            .create();

        let api_client = ApiClient::new(mockito::server_url());

        let result = initiate_device_code(&api_client, "test-client-id").await;

        match result {
            Ok(device_code_response) => {
                assert_eq!(device_code_response.user_code, "user_code_456");
                assert_eq!(device_code_response.verification_uri, "http://example.com");
                assert_eq!(
                    device_code_response.verification_uri_complete,
                    "http://example.com?user_code=user_code_456"
                );
            }
            Err(e) => panic!("Expected Ok, but got Err: {:?}", e),
        }
    }

    #[tokio::test]
    async fn test_exchange_device_code_for_token() {
        let _m = mock("POST", "/auth/device/token")
            .match_body(Matcher::Json(json!({
                "device_code": "device_code_123"
            })))
            .with_status(200)
            .with_body(
                r#"{
                "access_token": "access_token_789",
                "token_type": "bearer",
                "expires_in": 3600,
                "refresh_token": "refresh_token_101",
                "scope": "user:read,user:write"
            }"#,
            )
            .create();

        let api_client = ApiClient::new(mockito::server_url());

        let result = exchange_device_code_for_token(&api_client, "device_code_123").await;

        match result {
            Ok(token_response) => {
                assert_eq!(token_response.access_token, "access_token_789");
                assert_eq!(token_response.token_type, "bearer");
                assert_eq!(token_response.expires_in, 3600);
                assert_eq!(token_response.refresh_token, "refresh_token_101");
                assert_eq!(token_response.scope, "user:read,user:write");
            }
            Err(e) => panic!("Expected Ok, but got Err: {:?}", e),
        }
    }
}
