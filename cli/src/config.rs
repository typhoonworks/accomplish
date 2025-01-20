use std::env;
use std::fs;
use std::path::PathBuf;
use dirs_next;

pub struct Config {
    pub api_base: String,
    pub client_id: String,
}

impl Config {
    pub fn new() -> Self {
        let config_path = env::var("ACCOMPLISH_CONFIG_FILE")
            .map(PathBuf::from)
            .unwrap_or_else(|_| {
                dirs_next::home_dir()
                    .map(|dir| dir.join(".accomplish/config"))
                    .unwrap_or_else(|| PathBuf::from("./config"))
            });

        let credentials_path = env::var("ACCOMPLISH_CREDENTIALS_FILE")
            .map(PathBuf::from)
            .unwrap_or_else(|_| {
                dirs_next::home_dir()
                    .map(|dir| dir.join(".accomplish/credentials"))
                    .unwrap_or_else(|| PathBuf::from("./credentials"))
            });

        let api_base = Self::load_from_file(&config_path, "api_base")
            .unwrap_or_else(|| "http://localhost:4000".to_string());

        let client_id = Self::load_from_file(&credentials_path, "client_id")
            .unwrap_or_else(|| "your_default_client_id".to_string());

        Config { api_base, client_id }
    }

    fn load_from_file(path: &PathBuf, key: &str) -> Option<String> {
        if path.exists() {
            let content = fs::read_to_string(path).ok()?;
            for line in content.lines() {
                if let Some(value) = line.strip_prefix(&format!("{} = ", key)) {
                    return Some(value.trim().to_string());
                }
            }
        }
        None
    }
}
