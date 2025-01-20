use axum::{
  extract::Query,
  http::StatusCode,
  response::{Html, IntoResponse},
  routing::get,
  Router,
};
use serde::Deserialize;
use std::{net::SocketAddr, sync::Arc};
use tokio::sync::{Mutex, oneshot};

#[derive(Deserialize)]
struct CallbackParams {
  device_code: String,
}

pub async fn start_callback_server(tx: oneshot::Sender<String>) -> Result<(), Box<dyn std::error::Error>> {
  // Wrap the Sender in an Arc<Mutex<Option<Sender>>> for safe sharing and ownership transfer
  let shared_tx = Arc::new(Mutex::new(Some(tx)));

  let app = Router::new().route(
      "/callback",
      get({
          let shared_tx = Arc::clone(&shared_tx);
          move |Query(params): Query<CallbackParams>| handle_callback(params, shared_tx)
      }),
  );

  let addr = SocketAddr::from(([127, 0, 0, 1], 8000));
  println!("Listening on http://{}", addr);

  axum::Server::bind(&addr)
      .serve(app.into_make_service())
      .await?;

  Ok(())
}

async fn handle_callback(
  params: CallbackParams,
  shared_tx: Arc<Mutex<Option<oneshot::Sender<String>>>>,
) -> impl IntoResponse {
  if params.device_code.is_empty() {
      (
          StatusCode::BAD_REQUEST,
          Html(r#"
              <!DOCTYPE html>
              <html>
              <head>
                  <title>Callback Error</title>
              </head>
              <body>
                  <h1>Missing Code</h1>
                  <p>We couldn't find the required code in the callback.</p>
              </body>
              </html>
          "#),
      )
  } else {
      // Lock the Mutex and take ownership of the Sender
      if let Some(tx) = shared_tx.lock().await.take() {
          let _ = tx.send(params.device_code.clone());
      }
      (
          StatusCode::OK,
          Html(r#"
              <!DOCTYPE html>
              <html>
              <head>
                  <title>Success</title>
              </head>
              <body>
                  <h1>Authorization Successful!</h1>
                  <p>You can close this tab now.</p>
              </body>
              </html>
          "#),
      )
  }
}
