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
