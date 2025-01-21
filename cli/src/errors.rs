use std::fmt;

#[derive(Debug)]
pub struct CLIError {
    pub message: String,
}

impl fmt::Display for CLIError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", self.message)
    }
}

impl std::error::Error for CLIError {}

#[derive(Debug)]
pub struct UnauthenticatedError;

impl std::fmt::Display for UnauthenticatedError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "User is not authenticated. Please log in.")
    }
}

impl std::error::Error for UnauthenticatedError {}
