<!-- SPDX-License-Identifier: MIT -->

# music

Scripts and tools for music creation and music software. Each one has its own page under [`docs/`](docs/) with the details.

| Script | What it does | Details |
|--------|--------------|---------|
| [`uninstall_ni_product.sh`](uninstall_ni_product.sh) | Removes a Native Instruments product from a Mac: finds its app, plug-in, preference and library files, lists them, and deletes them after you confirm. macOS only. | [docs/uninstall_ni_product.md](docs/uninstall_ni_product.md) |

## Getting started

These steps are the same for every script in this repo. Each script's page then covers anything specific to it.

### 1. Get the files

**Easiest, no extra software needed:** on this page, click the green **Code** button, then **Download ZIP**. Double-click the ZIP in your Downloads folder to unzip it, and move the folder somewhere easy to find, such as Documents.

**If you already use git:**

    git clone https://github.com/boogieinit/music.git

Run `git pull` inside that folder any time to get updates. (With the ZIP, you download it again to update, and any setting you typed into a script has to be entered again.)

### 2. Open Terminal in that folder

1. Open **Terminal**: press ⌘ Space, type `Terminal`, and press Return.
2. Type `cd ` (the letters c, d and then a space), drag the folder from Finder into the Terminal window, and press Return.

### 3. Run a script

Type `bash`, a space, the script's file name, and anything its page tells you to add, then press Return. For example:

    bash uninstall_ni_product.sh "Product Name"

Starting with `bash` means you don't have to make the file executable. Read a script's page before you run it: some need a setting changed first, and some delete files.

## Adding to this repo

1. Put the script in the top level and make it executable.
2. Add a row to the table above with a one-line description.
3. Add `docs/<script-name>.md` with what it does, what it needs, any cautions and an example. Anything every script shares (getting the files, opening Terminal, running a script) stays in "Getting started" above, so the script's page only covers what is specific to it.

## License

MIT - see [LICENSE](LICENSE).
