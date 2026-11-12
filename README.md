<!-- SPDX-License-Identifier: MIT -->

# music

Scripts and tools for music creation and music software, grouped in a folder for each vendor or program. Each folder has its own README listing what is in it.

| Folder | What's in it |
|--------|--------------|
| [`native-instruments/`](native-instruments/) | Tools for Native Instruments software on a Mac, such as removing a product completely. |

## Getting started

These steps are the same for every script in this repo. Each folder's README and each script's page then cover anything specific to it.

### 1. Get the files

**Easiest, no extra software needed:** on this page, click the green **Code** button, then **Download ZIP**. Double-click the ZIP in your Downloads folder to unzip it (you get a folder called `music-main`), and move that folder somewhere easy to find, such as Documents.

**If you already use git:**

    git clone https://github.com/boogieinit/music.git

Run `git pull` inside that folder any time to get updates. (With the ZIP, you download it again to update, and any setting you typed into a script has to be entered again.)

### 2. Open Terminal in the folder of the tool you want

1. Open **Terminal**: press ⌘ Space, type `Terminal`, and press Return.
2. Type `cd ` (the letters c, d and then a space), drag the tool's folder from Finder into the Terminal window (for example the `native-instruments` folder inside `music-main`), and press Return.

### 3. Run a script

Type `bash`, a space, the script's file name, and anything its page tells you to add, then press Return. For example:

    bash uninstall_ni_product.sh "Product Name"

Starting with `bash` means you don't have to make the file executable. Read a script's page before you run it: some need a setting changed first, and some delete files.

## License

MIT - see [LICENSE](LICENSE).
