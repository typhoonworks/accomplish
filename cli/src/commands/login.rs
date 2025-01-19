use reqwest::Client;
use std::error::Error;
use crate::config::Config;

pub async fn execute(config: &Config) -> Result<(), Box<dyn Error>> {
    let api_url = config.get_api_url("api/cli/auth/initiate");
    let client = Client::new();

    match client.post(&api_url).send().await {
        Ok(response) => {
            if response.status().is_success() {
                let json: serde_json::Value = response.json().await.unwrap();
                if let Some(verification_url) = json["verification_url"].as_str() {
                    println!("Please authenticate by visiting: {}", verification_url);
                } else {
                    println!("Unexpected response: {}", json);
                }
            } else {
                println!("Failed to initiate login: HTTP {}", response.status());
            }
        }
        Err(err) => {
            println!("Error occurred: {}", err);
        }
    }

    Ok(())
}
