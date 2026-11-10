# uninstall_ni_product.sh

Removes a Native Instruments product from a Mac. It finds the product's application, plug-in, preference and library files, shows you the full list, and deletes them only after you confirm.

## Before you run it

- **macOS only.** On any other system the script stops with an error.
- **Set `LIBRARY_PATH` first.** Near the top of the script, `LIBRARY_PATH` points to the folder where your Native Instruments sample libraries live. The script ships with an example path on the author's drive, so change it to match your own setup before you run it.
- **Run it as your normal user, not with `sudo`.** The script uses your username to find your personal preference files, and it asks for your password itself when it needs to remove system folders.
- **Know the product name.** The name you pass must match the name of the product's files, for example the name of its plug-in in `/Library/Audio/Plug-ins/Components`.

## Usage

    chmod +x uninstall_ni_product.sh
    ./uninstall_ni_product.sh "Product Name"

Quote the name if it has spaces.

## What happens

1. **Search.** The script looks in the locations below and prints everything it finds.
2. **Review.** It shows the complete list of files and folders that will be deleted.
3. **Confirm.** It asks `Do you want to proceed with deletion? (y/n)`. Anything other than `y` cancels, and nothing is deleted.
4. **Delete.** It removes each item and prints `Done` or `Error` for each one.
5. **Summary.** It reports how many items were deleted and whether any failed.

If nothing is found for the name, it says so and exits without deleting anything.

**To preview without deleting,** run it and answer `n` at the prompt.

## Where it looks

| Location | What it is |
|----------|------------|
| `/Applications/Native Instruments/<name>` | The application |
| `/Library/Audio/Plug-ins/Components/<name>.component` | Audio Units plug-in |
| `/Library/Audio/Plug-ins/VST/<name>.vst` | VST plug-in |
| `/Library/Application Support/Digidesign/Plug-ins/<name>.dpm` | Pro Tools plug-in (older format) |
| `/Library/Application Support/Avid/Audio/Plug-ins/<name>.aaxplugin` | Pro Tools AAX plug-in |
| `/Library/Application Support/Native Instruments/<name>` | Shared support files |
| `/Library/Application Support/Native Instruments/Service Center/<name>.xml` | Service Center registration |
| `/Users/Shared/Native Instruments/installed_products/<name>.json` | Installed-product record |
| `/Library/Preferences/com.native-instruments.<name>.plist` | System preferences |
| `~/Library/Preferences/com.native-instruments.<name>.plist` | Your preferences |
| `~/Library/Application Support/Native Instruments/<name>` | Your support files |
| `<LIBRARY_PATH>/<name>` | The product's content, if the folder name matches exactly |
| Any folder in `<LIBRARY_PATH>` whose name **contains** the product name | Sample libraries and content |

## Cautions

- **Deletion is permanent.** Items are removed with `rm -rf`, not moved to the Trash. Back up anything you might want first.
- **Library folders are matched by partial name.** Any folder in `LIBRARY_PATH` whose name contains the text you typed is included, so a short or generic name can match more than you expect. Read the list carefully before you type `y`.
- **It asks for your password.** Items under `/Library`, `/Applications` and `/Volumes` are removed with `sudo`.
- **Close your DAW and any Native Instruments apps first.** The script doesn't check whether they are running.
- **It only removes what is listed above.** Anything stored elsewhere stays in place.
