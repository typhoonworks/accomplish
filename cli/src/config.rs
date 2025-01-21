use crate::storage;
use std::path::PathBuf;

#[allow(unused)]
pub struct Config {
    pub api_base: String,
    pub client_id: String,
    pub config_path: PathBuf,
    pub credentials_path: PathBuf,
}

impl Config {
    pub fn new() -> Self {
        let config_path = dirs_next::home_dir()
            .map(|dir| dir.join(".accomplish/config"))
            .unwrap_or_else(|| PathBuf::from("./config"));

        let credentials_path = dirs_next::home_dir()
            .map(|dir| dir.join(".accomplish/credentials"))
            .unwrap_or_else(|| PathBuf::from("./credentials"));

        let api_base = storage::load_key(&config_path, "api_base")
            .unwrap_or_else(|| "http://localhost:4000".to_string());

        let client_id = storage::load_key(&config_path, "client_id")
            .unwrap_or_else(|| "your_default_client_id".to_string());

        Config {
            api_base,
            client_id,
            config_path,
            credentials_path,
        }
    }
}
