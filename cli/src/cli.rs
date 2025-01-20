use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(name = "accomplish")]
#[command(about = "Accomplish CLI for managing tasks", long_about = None)]
pub struct CLI {
    #[command(subcommand)]
    pub command: Commands,
}

#[derive(Subcommand)]
pub enum Commands {
    /// Log in to your account
    Login,

    /// Log out from your account
    Logout,

    /// Check the current authentication status
    Status,
}
