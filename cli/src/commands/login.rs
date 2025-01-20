use crate::api::endpoints::initiate_device_code;
use crate::api::endpoints::exchange_device_code_for_token;
use crate::api::client::ApiClient;
use crate::api::errors::ApiError;
use crate::services::callback_server;
use webbrowser;
use std::error::Error;
use tokio::sync::oneshot;

pub async fn execute(api_client: &ApiClient, client_id: &str) -> Result<(), Box<dyn Error>> {
    let (tx, rx) = oneshot::channel();
    tokio::spawn(async move {
        if let Err(err) = callback_server::start_callback_server(tx).await {
            eprintln!("Callback server error: {}", err);
        }
    });

    match initiate_device_code(api_client, client_id).await {
        Ok(response) => {
            display_device_verification_message(
                &response.verification_uri,
                &response.user_code,
            );

            open_browser(&response.verification_uri_complete).ok();

            match rx.await {
                Ok(code) => {
                    println!("Successfully received code: {}", code);
                    match exchange_device_code_for_token(api_client, &code).await {
                        Ok(token_response) => {
                            println!("Access Token: {}", token_response.access_token);
                            println!("Token Type: {}", token_response.token_type);
                            println!("Expires In: {}", token_response.expires_in);
                            println!("Refresh Token: {}", token_response.refresh_token);
                            println!("Scope: {}", token_response.scope);
                            Ok(())
                        }
                        Err(err) => {
                            eprintln!("Error exchanging device code for token: {}", err);
                            Err("Failed to exchange device code for token.".into())
                        }
                    }
                }
                Err(_) => {
                    eprintln!("Failed to receive authorization code.");
                    Err("Authorization failed.".into())
                }
            }
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

pub fn display_device_verification_message(verification_url: &str, user_code: &str) {
    println!(
        "
Please authenticate by visiting the URL below and entering the code:

Verification URL: {verification_url}
User Code: {user_code}

Press Enter to open the URL in your default browser...
",
        verification_url = verification_url,
        user_code = user_code
    );

    // Wait for user to press Enter
    let mut input = String::new();
    std::io::stdin().read_line(&mut input).ok();
}

pub fn open_browser(url: &str) -> Result<(), String> {
    if webbrowser::open(url).is_ok() {
        Ok(())
    } else {
        Err(format!("Failed to open the browser. Please open the URL manually: {url}"))
    }
}



