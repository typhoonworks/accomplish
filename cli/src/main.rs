mod commands;
mod config;

use clap::{Parser, Subcommand};
use config::Config;

use commands::{login, logout, status};

#[derive(Parser)]
#[command(name = "accomplish")]
#[command(about = "Accomplish CLI for managing tasks", long_about = None)]
struct CLI {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Log in to your account
    Login,

    /// Log out from your account
    Logout,

    /// Check the current authentication status
    Status,
}

#[tokio::main]
async fn main() {
    let cli = CLI::parse();
    let config = Config::new(); // Initialize configuration

    match &cli.command {
        Commands::Login => {
            if let Err(e) = login::execute(&config).await {
                eprintln!("Error: {}", e);
            }
        }
        Commands::Logout => logout::execute(),
        Commands::Status => status::execute(),
    }
}
