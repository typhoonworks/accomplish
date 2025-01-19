use std::env;

pub struct Config {
    pub base_url: String,
}

impl Config {
    pub fn new() -> Self {
        let base_url = env::var("ACCOMPLISH_API_URL").unwrap_or_else(|_| {
            "http://localhost:4000".to_string()
        });

        Config { base_url }
    }

    pub fn get_api_url(&self, endpoint: &str) -> String {
        format!("{}/{}", self.base_url, endpoint)
    }
}
