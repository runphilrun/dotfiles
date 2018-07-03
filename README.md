# ~/.dotfiles
Customization settings for a reproducable Ubuntu setup.

## Usage
Download configuration files (i.e. dotfiles) individually as needed, or run the automated installer to acquire and configure all applications.

### Using dotfiles individually
Most dotfiles, such as `.zshrc` and `.spacemacs` should be placed in the user's home directory (`~`).

### Run the automated installer
Clone this repository.
```
git clone https://github.com/runphilrun/dotfiles.git ~/.dotfiles
```
Grant executable permissions to the automated `install.sh` script to download and configure the system.
```
chmod -x ~/.dotfiles install.sh
```
Run the automated installer. The script will check for existing applications and attempt to download them (and their dependencies) if they are missing.
