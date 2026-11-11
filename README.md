<!-- SPDX-License-Identifier: MIT -->

# music

Scripts and tools for music creation and music software. Each one has its own page under [`docs/`](docs/) with the details.

| Script | What it does | Details |
|--------|--------------|---------|
| [`uninstall_ni_product.sh`](uninstall_ni_product.sh) | Removes a Native Instruments product from a Mac: finds its app, plug-in, preference and library files, lists them, and deletes them after you confirm. macOS only. | [docs/uninstall_ni_product.md](docs/uninstall_ni_product.md) |

## Usage

Make a script executable, then run it:

    chmod +x <script>
    ./<script>

Check each script's page first, since some need a setting changed before they run.

## Adding to this repo

1. Put the script in the top level and make it executable.
2. Add a row to the table above with a one-line description.
3. Add `docs/<script-name>.md` with what it does, what it needs, any cautions and an example.

## License

MIT - see [LICENSE](LICENSE).
