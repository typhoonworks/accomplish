use crate::api::client::ApiClient;
use crate::api::endpoints::check_token_info;
use crate::api::errors::ApiError;
use crate::errors::UnauthenticatedError;
use crate::storage::{clear_key, load_key, save_key};
use std::error::Error;
use std::path::PathBuf;

pub struct AuthService {
    api_client: ApiClient,
    access_token: Option<String>,
    credentials_path: PathBuf,
}

impl AuthService {
    pub fn new(api_base: String, credentials_path: PathBuf) -> Self {
        let access_token = load_key(&credentials_path, "oauth_token");

        let mut api_client = ApiClient::new(&api_base);
        if let Some(ref token) = access_token {
            api_client.set_access_token(token.clone());
        }

        AuthService {
            api_client,
            access_token,
            credentials_path,
        }
    }

    pub fn api_client(&self) -> &ApiClient {
        &self.api_client
    }

    // pub fn get_access_token(&self) -> Option<&String> {
    //     self.access_token.as_ref()
    // }

    /// Ensure the user is authenticated by validating the current token.
    /// If the token is invalid, the user will be considered unauthenticated.
    pub async fn ensure_authenticated(&mut self) -> Result<(), Box<dyn Error>> {
        if let Some(token) = &self.access_token {
            match check_token_info(&self.api_client, &token).await {
                Ok(response) if response.active => Ok(()), // Token is valid
                Ok(_) => {
                    // Token is not active but no error occurred
                    Err(Box::new(UnauthenticatedError))
                }
                Err(ApiError::Unauthorized(_)) => {
                    // Token is explicitly unauthorized
                    self.clear_tokens();
                    Err(Box::new(UnauthenticatedError))
                }
                Err(e) => {
                    // Handle unexpected errors (do not clear tokens)
                    Err(Box::new(e))
                }
            }
        } else {
            Err(Box::new(UnauthenticatedError))
        }
    }

    /// Clears the stored tokens from memory and the credentials file.
    pub fn clear_tokens(&mut self) {
        self.access_token = None;
        let _ = clear_key(&self.credentials_path, "oauth_token");
    }

    /// Save a new token to the credentials file and update in-memory token.
    pub fn save_access_token(&mut self, token: &str) -> Result<(), Box<dyn Error>> {
        save_key(&self.credentials_path, "oauth_token", token)?;
        self.access_token = Some(token.to_string());
        Ok(())
    }
}
