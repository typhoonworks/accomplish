# Using LiveBook for Local Development

When working on a local development environment, it's common to repeatedly execute the same series of functions, wether to access or manipulate data. Whilte running `iex` with shell history enables command recall, it’s not the most user-friendly option for working with code that spans multiple lines or when you want to present data more clearly and visually.

To streamline this process, you can connect Livebook to a locally running **Accomplish** application. Here's how:

1. **Start** `accomplish` **with** `--sname` **and** `--cookie` **flags**

    Create an alias in your `~/.zshrc` file (or `.bashrc`, or whatever shell configuration file you prefer) to simplify this process. Adjust the `sname` and `cookie` values as needed.

    ```sh
    alias iexphx='iex --name accomplish@127.0.0.1 --cookie mycookie -S mix phx.server'
    ```

2. **Launch Livebook**

    Start the LiveBook application on your machine.

3. **Open or Create a Notebook**

    You can either open an existing notebook or create a new one.

4. **Configure Runtime Settings**

    - Click the Runtime Settings button or use the shortcut `sr` to access the configuration.
    - Navigate to **Configure > Attached** node and input the `sname` and `cookie` values you specified earlier.

5. **Start Interacting with Your OTP App**

    Once connected, you can run any Elixir code directly against the `accomplish` application.

> **Important Note:**
> The `.iex.exs` file is not automatically loaded in this setup. This means you won’t have any preconfigured aliases and will need to use the full module names for your code.
