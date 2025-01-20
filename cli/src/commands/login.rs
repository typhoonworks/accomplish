use crate::api::endpoints::initiate_device_code;
use crate::api::client::ApiClient;
use crate::api::errors::ApiError;
use std::error::Error;

pub async fn execute(api_client: &ApiClient, client_id: &str) -> Result<(), Box<dyn Error>> {
    match initiate_device_code(api_client, client_id).await {
        Ok(response) => {
            println!("Device Code: {}", response.device_code);
            println!("User Code: {}", response.user_code);
            println!("Please authenticate by visiting: {}", response.verification_uri);
            Ok(())
        }
        Err(ApiError::BadRequest(msg)) => {
            eprintln!("Bad Request: {}", msg);
            Err(Box::new(ApiError::BadRequest(msg)))
        }
        Err(ApiError::Unauthorized(msg)) => {
            eprintln!("Unauthorized: {}", msg);
            Err(Box::new(ApiError::Unauthorized(msg)))
        }
        Err(ApiError::ServerError(msg)) => {
            eprintln!("Server Error: {}", msg);
            Err(Box::new(ApiError::ServerError(msg)))
        }
        Err(ApiError::DecodeError(msg)) => {
            eprintln!("Error decoding response: {}", msg);
            Err(Box::new(ApiError::DecodeError(msg)))
        }
        Err(e) => {
            eprintln!("Unexpected Error: {}", e);
            Err(Box::new(e))
        }
    }
}
