use keyring::{Entry, Error as KeyringError};

const SERVICE_NAME: &str = "accomplish";

pub fn set(key: &str, secret: &str) -> Result<(), KeyringError> {
    let entry = Entry::new(SERVICE_NAME, key)?;
    entry.set_password(secret)?;
    Ok(())
}

pub fn get(key: &str) -> Result<String, KeyringError> {
    let entry = Entry::new(SERVICE_NAME, key)?;
    entry.get_password()
}

pub fn delete(key: &str) -> Result<(), KeyringError> {
    let entry = Entry::new(SERVICE_NAME, key)?;
    entry.delete_credential()?;
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use serial_test::serial;

    fn check_secret_in_keyring(key: &str, expected_secret: &str) -> Result<(), KeyringError> {
        let retrieved_secret = get(key)?;
        assert_eq!(retrieved_secret, expected_secret); // Direct comparison of values
        Ok(())
    }

    #[test]
    #[serial]
    fn test_set_and_get_secret() {
        let key = "test-oauth-token";
        let secret = "some-oauth-token";

        delete(key).ok();

        assert!(set(key, secret).is_ok());

        assert!(check_secret_in_keyring(key, secret).is_ok());
    }

    #[test]
    #[serial]
    fn test_set_and_delete_secret() {
        let key = "test-refresh-token";
        let secret = "some-refresh-token";

        delete(key).ok();

        assert!(set(key, secret).is_ok());

        assert!(check_secret_in_keyring(key, secret).is_ok());

        assert!(delete(key).is_ok());

        let result = get(key);
        assert!(
            result.is_err(),
            "Expected error when retrieving deleted secret"
        );
    }

    #[test]
    #[serial]
    fn test_get_non_existing_secret() {
        let key = "non-existing-secret";

        let result = get(key);
        assert!(
            result.is_err(),
            "Expected error when retrieving non-existing secret"
        );
    }

    #[test]
    #[serial]
    fn test_delete_non_existing_secret() {
        let key = "non-existing-secret";

        let result = delete(key);
        assert!(
            result.is_err(),
            "Expected error when deleting non-existing secret"
        );
    }

    #[test]
    #[serial]
    fn test_set_multiple_secrets() {
        let key1 = "test-oauth-token";
        let secret1 = "some-oauth-token";
        let key2 = "test-refresh-token";
        let secret2 = "some-refresh-token";

        delete(key1).ok();
        delete(key2).ok();

        assert!(set(key1, secret1).is_ok());
        assert!(set(key2, secret2).is_ok());

        assert!(check_secret_in_keyring(key1, secret1).is_ok());
        assert!(check_secret_in_keyring(key2, secret2).is_ok());
    }
}
