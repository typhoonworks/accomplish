use reqwest::Client;
use std::error::Error;

pub async fn post_to_api(endpoint: &str) -> Result<reqwest::Response, Box<dyn Error>> {
    let client = Client::new();
    let response = client.post(endpoint).send().await?;
    Ok(response)
}
