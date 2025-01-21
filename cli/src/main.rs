mod api;
mod auth;
mod commands;
mod config;
mod errors;
mod storage;

// use api::client::ApiClient;
use auth::AuthService;
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
    let config = Config::new();
    let mut auth_service =
        AuthService::new(config.api_base.clone(), config.credentials_path.clone());

    // let api_client = ApiClient::new_with_token(
    //     config.api_base.clone(),
    //     auth_service.get_access_token().cloned(),
    // );

    let cli = Cli::parse();

    match &cli.command {
        Commands::Login => {
            // Login command should bypass authentication check
            if let Err(e) = login::execute(&mut auth_service, &config.client_id).await {
                eprintln!("Error: {}", e);
            }
        }
        _ => {
            // Ensure authenticated for all other commands
            if let Err(_) = auth_service.ensure_authenticated().await {
                eprintln!("You are not authenticated. Please run `accomplish login`.");
                std::process::exit(1);
            }

            match &cli.command {
                Commands::Logout => logout::execute(),
                Commands::Status => status::execute(),
                _ => eprintln!("Unknown command."),
            }
        }
    }
}
