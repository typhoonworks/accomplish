mod api;
mod commands;
mod config;
mod services;

use api::client::ApiClient;
use clap::{Parser, Subcommand};
use config::Config;

use commands::{login, logout, status};

#[derive(Parser)]
#[command(name = "accomplish")]
#[command(about = "Accomplish CLI for managing tasks", long_about = None)]
struct Cli {
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
    let cli = Cli::parse(); // Parse CLI commands using clap
    let config = Config::new(); // Initialize configuration
    let api_client = ApiClient::new(config.api_base.clone()); // Create an API client

    match &cli.command {
        Commands::Login => {
            if let Err(e) = login::execute(&api_client, &config.client_id).await {
                eprintln!("Error: {}", e);
            }
        }
        Commands::Logout => logout::execute(),
        Commands::Status => status::execute(),
    }
}
