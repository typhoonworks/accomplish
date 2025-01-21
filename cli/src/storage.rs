use std::fs;
use std::io::{self, Write};
use std::path::PathBuf;

pub fn load_key(path: &PathBuf, key: &str) -> Option<String> {
    if path.exists() {
        if let Ok(content) = fs::read_to_string(path) {
            for line in content.lines() {
                if let Some(value) = line.strip_prefix(&format!("{} = ", key)) {
                    return Some(value.trim().to_string());
                }
            }
        }
    }
    None
}

pub fn save_key(path: &PathBuf, key: &str, value: &str) -> io::Result<()> {
    println!("Saving key: {} to path: {:?}", key, path); // Debugging log
    let mut content = if path.exists() {
        fs::read_to_string(path).unwrap_or_default()
    } else {
        String::new()
    };

    content = content
        .lines()
        .filter(|line| !line.starts_with(&format!("{} = ", key)))
        .collect::<Vec<_>>()
        .join("\n");

    content.push_str(&format!("\n{} = {}", key, value));

    let mut file = fs::File::create(path)?;
    file.write_all(content.as_bytes())?;
    Ok(())
}

pub fn clear_key(path: &PathBuf, key: &str) -> io::Result<()> {
    if path.exists() {
        let content = fs::read_to_string(path)?;
        let updated_content = content
            .lines()
            .filter(|line| !line.starts_with(&format!("{} = ", key)))
            .collect::<Vec<_>>()
            .join("\n");

        fs::write(path, updated_content)?;
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;
    use std::path::PathBuf;

    fn get_temp_file() -> PathBuf {
        let temp_dir = std::env::temp_dir();
        temp_dir.join(format!("test_storage_{}.conf", uuid::Uuid::new_v4()))
    }

    #[test]
    fn test_load_key() {
        let temp_file = get_temp_file();
        let key = "test_key";
        let value = "test_value";

        save_key(&temp_file, key, value).unwrap();

        let loaded_value = load_key(&temp_file, key);
        assert_eq!(loaded_value, Some(value.to_string()));

        // Cleanup
        fs::remove_file(temp_file).unwrap();
    }

    #[test]
    fn test_load_key_nonexistent_file() {
        let temp_file = get_temp_file();
        let key = "nonexistent_key";

        let loaded_value = load_key(&temp_file, key);
        assert_eq!(loaded_value, None);
    }

    #[test]
    fn test_save_key_overwrites_existing_key() {
        let temp_file = get_temp_file();
        let key = "test_key";
        let initial_value = "initial_value";
        let new_value = "new_value";

        save_key(&temp_file, key, initial_value).unwrap();
        save_key(&temp_file, key, new_value).unwrap();

        let loaded_value = load_key(&temp_file, key);
        assert_eq!(loaded_value, Some(new_value.to_string()));

        // Cleanup
        fs::remove_file(temp_file).unwrap();
    }

    #[test]
    fn test_save_key_creates_file() {
        let temp_file = get_temp_file();
        let key = "new_key";
        let value = "new_value";

        save_key(&temp_file, key, value).unwrap();

        let loaded_value = load_key(&temp_file, key);
        assert_eq!(loaded_value, Some(value.to_string()));

        // Cleanup
        fs::remove_file(temp_file).unwrap();
    }

    #[test]
    fn test_clear_key() {
        let temp_file = get_temp_file();
        let key = "key_to_clear";
        let value = "value_to_clear";

        save_key(&temp_file, key, value).unwrap();
        clear_key(&temp_file, key).unwrap();

        let loaded_value = load_key(&temp_file, key);
        assert_eq!(loaded_value, None);

        // Cleanup
        fs::remove_file(temp_file).unwrap();
    }

    #[test]
    fn test_clear_key_nonexistent_key() {
        let temp_file = get_temp_file();
        let key = "nonexistent_key";

        let result = clear_key(&temp_file, key);
        assert!(result.is_ok(), "Clearing a nonexistent key should not fail");
    }
}
