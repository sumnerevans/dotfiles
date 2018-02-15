#! /bin/sh
#
# install.sh
#
# This script installs all of my dotfiles to my home directory.

# Sym Links
DOTFILE_DIR=$HOME/dotfiles
INSTALL_DIR=$HOME
SYM_LINKS=$HOME/dotfiles/setup/sym-link-list

# Bin Directory
BIN_DIR=$HOME/bin
BIN_REPO="git@github.com:sumnerevans/scripts.git"

echo "install.sh"
echo
echo "Create Symbolic Links"
echo "============================================================"
echo "DOTFILE_DIR=$DOTFILE_DIR"
echo "INSTALL_DIR=$INSTALL_DIR"
echo "SYM_LINKS=$SYM_LINKS"
echo
echo "BIN_DIR=$BIN_DIR"
echo "BIN_REPO=$BIN_REPO"
echo "============================================================"
echo
read -p "Proceed with installation? (Y/n)" choice
case "$choice" in
    ""|y|Y|yes|Yes|YES ) ;; # Proceed with install
    *) echo "Aborting installation."; exit ;;
esac

echo "Creating symbolic links..."

while read LINK
do
    echo "Linking $LINK"
    if [[ -d "$INSTALL_DIR/$LINK" || -f "$INSTALL_DIR/$LINK" ]]; then
        echo "    $LINK already exists"
        read -p "    Would you like to override? (y/N) " override </dev/tty
        case "$override" in
            y|Y|yes|Yes|YES ) echo "    Overriding $LINK." ;;
            *) continue
        esac
    fi
    echo "    $DOTFILE_DIR/$LINK -> $INSTALL_DIR/$LINK"
    rm -rf "$INSTALL_DIR/$LINK"
    ln -fs "$DOTFILE_DIR/$LINK" "$INSTALL_DIR/$LINK"
done < $SYM_LINKS

echo ""
echo "Clone Bin Directory"
if [[ ! $(command -v git) ]]; then
    read -p "ERROR: git not installed. Please install it before proceeding."
fi
if [[ -d "$BIN_DIR" ]]; then
    echo "bin already exists."
    read -p "    Would you like to override? (y/N) " override </dev/tty
    case "$override" in
        y|Y|yes|Yes|YES )
            echo "    Deleting $BIN_DIR."
            rm -rf $BIN_DIR
            git clone $BIN_REPO $BIN_DIR
            ;;
        *) continue
    esac
else
    git clone $BIN_REPO $BIN_DIR
fi
