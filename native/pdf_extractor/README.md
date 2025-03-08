# Native.PdfExtractor

## Overview

`Native.PdfExtractor` is a Rust-powered NIF (Native Implemented Function) for high-performance PDF text extraction in Elixir. It enables efficient parsing of PDF documents and metadata extraction using Rustler.

## Installation

Ensure `rustler` is installed in your `mix.exs` dependencies:

```elixir
defp deps do
  [
    {:rustler, "~> 0.36.1", runtime: false}
  ]
end
```

Then, fetch and compile dependencies:

```sh
mix deps.get
mix deps.compile
```

## Building the NIF

The NIF module is compiled automatically as part of your project. However, you can manually force a build with:

```sh
mix compile
```

## Usage

To load the NIF in Elixir, define a module as follows:

```elixir
defmodule Native.PdfExtractor do
  use Rustler, otp_app: :accomplish, crate: "pdfextractor"

  # These functions are defined in Rust and will be replaced at runtime.
  def extract_text(_pdf_binary), do: :erlang.nif_error(:nif_not_loaded)
  def extract_metadata(_pdf_binary), do: :erlang.nif_error(:nif_not_loaded)
end
```

### Example

Extract text from a PDF file:

```elixir
iex> pdf_binary = File.read!("resume.pdf")
iex> {:ok, %{text: text}} = Native.PdfExtractor.extract_text(pdf_binary)
iex> IO.puts(text)
```

Extract metadata from a PDF:

```elixir
iex> {:ok, metadata} = Native.PdfExtractor.extract_metadata(pdf_binary)
iex> IO.inspect(metadata)
```

## Troubleshooting

### Compilation Issues

If you encounter compilation issues, try:

```sh
rm -rf _build deps
mix deps.get
mix compile
```

Ensure Rust is installed and available:

```sh
rustc --version
```

### NIF Not Loaded

If you see `:nif_not_loaded` errors in IEx, ensure the project is compiled and try:

```sh
mix compile
iex -S mix
```
