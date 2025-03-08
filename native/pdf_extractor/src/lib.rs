use lopdf::{Document, Object};
use pdf_extract;
use rustler::{types::map::map_new, Binary, Encoder, Env, NifResult, Term};
use std::collections::HashMap;

// Atoms returned to Elixir
mod atoms {
    rustler::atoms! {
        ok,
        error,
        extraction_error,
        invalid_pdf,
    }
}

/// Extract PDF text (optionally including metadata)
#[rustler::nif(schedule = "DirtyCpu")]
fn extract_text_nif<'a>(env: Env<'a>, pdf_data: Binary, include_metadata: bool) -> NifResult<Term<'a>> {
    let bytes = pdf_data.as_slice();

    match extract_text_from_pdf(bytes) {
        Ok(text) => {
            let metadata_map = if include_metadata {
                match extract_metadata_from_pdf(bytes) {
                    Ok(meta) => meta,
                    Err(_) => HashMap::new(),
                }
            } else {
                HashMap::new()
            };

            let output_map = map_new(env)
                .map_put("text", text).unwrap()
                .map_put("metadata", metadata_map).unwrap();

            Ok((atoms::ok(), output_map).encode(env))
        }
        Err(err_msg) => {
            Ok((atoms::error(), atoms::extraction_error(), err_msg).encode(env))
        }
    }
}

#[rustler::nif(schedule = "DirtyCpu")]
fn extract_metadata_nif<'a>(env: Env<'a>, pdf_data: Binary) -> NifResult<Term<'a>> {
    let bytes = pdf_data.as_slice();

    match extract_metadata_from_pdf(bytes) {
        Ok(meta_map) => Ok((atoms::ok(), meta_map).encode(env)),
        Err(err_msg) => Ok((atoms::error(), atoms::extraction_error(), err_msg).encode(env))
    }
}

// -------------------------------------------------------------------------
// Internal helpers
// -------------------------------------------------------------------------

fn extract_text_from_pdf(pdf_bytes: &[u8]) -> Result<String, String> {
    let extracted_text = pdf_extract::extract_text_from_mem(pdf_bytes)
        .map_err(|e| format!("PDF text extraction failed: {}", e))?;

    Ok(extracted_text)
}

fn extract_metadata_from_pdf(pdf_bytes: &[u8]) -> Result<HashMap<String, String>, String> {
    let mut result = HashMap::new();
    let doc = Document::load_mem(pdf_bytes)
        .map_err(|e| format!("Failed to parse PDF for metadata: {}", e))?;

    result.insert("page_count".to_string(), doc.get_pages().len().to_string());

    // If trailer["Info"] is a reference, read that dictionary
    if let Ok(Object::Reference(info_ref)) = doc.trailer.get(b"Info") {
        if let Ok(Object::Dictionary(info_dict)) = doc.get_object(*info_ref) {
            // Title
            if let Ok(Object::String(data, _)) = info_dict.get(b"Title") {
                result.insert("title".to_string(), bytes_to_string(data));
            }
            // Author
            if let Ok(Object::String(data, _)) = info_dict.get(b"Author") {
                result.insert("author".to_string(), bytes_to_string(data));
            }
            // Creator
            if let Ok(Object::String(data, _)) = info_dict.get(b"Creator") {
                result.insert("creator".to_string(), bytes_to_string(data));
            }
            // Producer
            if let Ok(Object::String(data, _)) = info_dict.get(b"Producer") {
                result.insert("producer".to_string(), bytes_to_string(data));
            }
            // CreationDate
            if let Ok(Object::String(data, _)) = info_dict.get(b"CreationDate") {
                result.insert("creation_date".to_string(), bytes_to_string(data));
            }
        }
    }

    Ok(result)
}

/// Convert arbitrary PDF byte data into a String (lossy for non-UTF8).
fn bytes_to_string(data: &[u8]) -> String {
    String::from_utf8_lossy(data).to_string()
}

rustler::init!("Elixir.Accomplish.PDFExtractor");
