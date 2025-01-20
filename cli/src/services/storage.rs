#[cfg(target_os = "macos")]
use keychain::{Keychain, KeychainItem};
#[cfg(target_os = "windows")]
use wincreds::{Cred, CredFlags};
#[cfg(target_os = "linux")]
use std::fs::File;

use std::error::Error;

pub trait TokenStorage {
    fn store_token(&self, token: &str) -> Result<(), Box<dyn Error>>;
    fn retrieve_token(&self) -> Result<String, Box<dyn Error>>;
}

#[cfg(target_os = "macos")]
pub struct KeychainStorage;

#[cfg(target_os = "macos")]
impl TokenStorage for KeychainStorage {
    fn store_token(&self, token: &str) -> Result<(), Box<dyn Error>> {
        let keychain = Keychain::new("com.accomplish.auth")?;
        keychain.add_generic_password("access_token", token)?;
        Ok(())
    }

    fn retrieve_token(&self) -> Result<String, Box<dyn Error>> {
        let keychain = Keychain::new("com.accomplish.auth")?;
        match keychain.get_generic_password("access_token") {
            Ok(token) => Ok(token),
            Err(_) => Err("Token not found in Keychain".into()),
        }
    }
}

#[cfg(target_os = "windows")]
pub struct WindowsCredentialStore;

#[cfg(target_os = "windows")]
impl TokenStorage for WindowsCredentialStore {
    fn store_token(&self, token: &str) -> Result<(), Box<dyn Error>> {
        let cred = Cred {
            target_name: "com.accomplish.auth".to_string(),
            credential_type: 1, // Generic password
            flags: CredFlags::empty(),
            username: None,
            password: Some(token.to_string()),
        };
        cred.add()?;
        Ok(())
    }

    fn retrieve_token(&self) -> Result<String, Box<dyn Error>> {
        match Cred::get("com.accomplish.auth") {
            Ok(cred) => match cred.password {
                Some(password) => Ok(password),
                None => Err("Token not found".into()),
            },
            Err(_) => Err("Token not found in Windows Credential Store".into()),
        }
    }
}

#[cfg(target_os = "linux")]
pub struct LinuxFileStorage;

#[cfg(target_os = "linux")]
impl TokenStorage for LinuxFileStorage {
    fn store_token(&self, token: &str) -> Result<(), Box<dyn Error>> {
        let mut file = File::create("token.txt")?;
        use std::io::Write;
        file.write_all(token.as_bytes())?;
        Ok(())
    }

    fn retrieve_token(&self) -> Result<String, Box<dyn Error>> {
        use std::fs::read_to_string;
        match read_to_string("token.txt") {
            Ok(token) => Ok(token),
            Err(_) => Err("Token not found in file".into()),
        }
    }
}

pub fn get_storage() -> Box<dyn TokenStorage> {
    match std::env::consts::OS {
        "macos" => Box::new(KeychainStorage),
        "windows" => Box::new(WindowsCredentialStore),
        "linux" => Box::new(LinuxFileStorage),
        _ => panic!("Unsupported platform for storing tokens"),
    }
}
