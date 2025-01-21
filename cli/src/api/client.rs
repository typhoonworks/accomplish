use crate::api::errors::ApiError;
use reqwest::Client;
use serde::de::DeserializeOwned;

pub struct ApiClient {
    base_url: String,
}

impl ApiClient {
    pub fn new(base_url: String) -> Self {
        ApiClient { base_url }
    }

    pub async fn post<T>(&self, endpoint: &str, body: serde_json::Value) -> Result<T, ApiError>
    where
        T: DeserializeOwned,
    {
        let full_url = format!("{}/{}", self.base_url, endpoint);
        let client = Client::new();

        let response = client.post(&full_url).json(&body).send().await;

        match response {
            Ok(resp) if resp.status().is_success() => resp
                .json::<T>()
                .await
                .map_err(|e| ApiError::DecodeError(e.to_string())),
            Ok(resp) => match resp.status().as_u16() {
                400 => {
                    let error_msg = resp
                        .text()
                        .await
                        .unwrap_or_else(|_| "Bad Request".to_string());
                    Err(ApiError::BadRequest(error_msg))
                }
                401 => {
                    let error_msg = resp
                        .text()
                        .await
                        .unwrap_or_else(|_| "Unauthorized".to_string());
                    Err(ApiError::Unauthorized(error_msg))
                }
                404 => {
                    let error_msg = resp
                        .text()
                        .await
                        .unwrap_or_else(|_| "Not Found".to_string());
                    Err(ApiError::NotFound(error_msg))
                }
                500 => {
                    let error_msg = resp
                        .text()
                        .await
                        .unwrap_or_else(|_| "Internal Server Error".to_string());
                    Err(ApiError::ServerError(error_msg))
                }
                _ => {
                    let error_msg = resp
                        .text()
                        .await
                        .unwrap_or_else(|_| "Unexpected Error".to_string());
                    Err(ApiError::Unexpected(error_msg))
                }
            },
            Err(e) => Err(ApiError::Unexpected(e.to_string())),
        }
    }
}
