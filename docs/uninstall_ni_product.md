<!-- SPDX-License-Identifier: MIT -->

# uninstall_ni_product.sh

Removes a Native Instruments product from a Mac. It finds the product's application, plug-in, preference and library files, shows you the full list, and deletes them only after you confirm.

New to the Terminal? Follow **Getting started** in the [README](../README.md) first. It covers getting the files, opening Terminal in the right folder and running a script. Then come back here for the steps specific to this script.

## Before you run it

- **macOS only.** On any other system the script stops with an error.
- **Back up first.** Deletion is permanent, not moved to the Trash. A Time Machine backup is the safety net.
- **Close your DAW and any Native Instruments apps.** The script doesn't check whether they are running.
- **Run it as your normal user, not with `sudo`.** The script uses your username to find your personal preference files, and it asks for your password itself when it needs to remove system folders.

## Step by step

### 1. Tell the script where your libraries are (one time)

`LIBRARY_PATH` must point to the folder where your Native Instruments sample libraries live. It ships empty, and the script stops with an error (deleting nothing) until you set it.

1. In Finder, find the folder that holds your Native Instruments libraries. Hold the **Option** key, right-click the folder, and choose **Copy "…" as Pathname**.
2. Right-click `uninstall_ni_product.sh`, choose **Open With**, then **TextEdit**.
3. Find the line `LIBRARY_PATH=""`. Click between the two quotation marks and paste with ⌘V. Don't delete or retype the quotation marks. It should end up looking like `LIBRARY_PATH="/Users/Shared/Native Instruments"`.
4. Save with ⌘S. If TextEdit shows a formatting toolbar, choose **Format**, then **Make Plain Text**, before saving, and keep the file name the same.

### 2. Find the exact product name

The name you give the script must match the name of the product's files. It has to be at least 3 characters (not counting spaces) and can't contain a `/`.

In Finder, choose **Go**, then **Go to Folder…**, type `/Library/Audio/Plug-ins/Components`, and look for the product's `.component` file. For `Kontakt 7.component`, the name is `Kontakt 7`. You can also look inside `/Applications/Native Instruments/` for the product's folder name.

### 3. Run it

With Terminal open in the folder (see the README), type this with your product name in quotes, and press Return:

    bash uninstall_ni_product.sh "Kontakt 7"

### 4. Read the list, then decide

The script prints everything it found and asks `Do you want to proceed with deletion? (y/n)`. Type **n** and press Return to cancel with nothing deleted, which makes a safe practice run. Type **y** to delete.

### 5. If it asks for permission

- **Password:** it asks for your Mac password to remove system folders. Nothing shows on screen as you type, which is normal. Press Return when done.
- **Folder or drive access:** if macOS asks to let Terminal access a folder or drive, click **Allow**.

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
- **It only removes what is listed above.** Anything stored elsewhere stays in place.
