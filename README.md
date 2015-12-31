# Reactor

Reactor is the firmware generator part of [Fusion](https://github.com/ErgoDox-EZ/fusion).

It takes the JSON's exported by the Fusion project and process them in to ready-to-be-downloaded firmware.

Reactor uses the awesome [qmk_firmware](http://github.com/jackhumbert/qmk_firmware) by Jack Humbert. The firmware is included through a git  subtree. To update the firmware, check out [updating the firmware](#updating-the-firmware).


## General process

- Take JSON input
- Generate a .c template file based on the JSON and the liquid template. Name it something unique
- Create a hex file by compiling that c file. Name it something unique too
- read .hex file and return it

# Local development

You can run the tests with `be guard` - which will watch for changes in ruby files and run whenever they do

## Updating the firmware

The qmk_firmware is included in this repository as a git subtree. Any **changes to qmk_firmware should be made to the [qmk_firmware repository](http://github.com/jackhumbert/qmk_firmware)** not this repository.

To update the subtree from the qmk_firmware repository, pull the updates from qmk_firmware into this repository.

**If you don't have the remote and the subtree setup:**

1. Add the remote for qmk_firmware
    
    `git remote add -f  qmk_firmware git@github.com:jackhumbert/qmk_firmware.git`

2. Add the subtree
    
    `git subtree add --prefix lib/firmware qmk_firmware master --squash`

**If you have the remote and subtree setup:**

1. Fetch the updates

    `git fetch qmk_firmware master`

2. Update the subtree
    
    `git subtree pull --prefix lib/firmware qmk_firmware master --squash`

<sub>[Read more about git subtrees here](http://blogs.atlassian.com/2013/05/alternatives-to-git-submodule-git-subtree/)</sub>

### Compiling firmware

#### Linux

TBD

#### Mac OSX

Using homebrew it's easy to compile the firmware:

    brew tap osx-cross/avr
    brew install avr-libc
    

Next cd into the appropriate folder of the qmk_firmware, say keyboard/ergodox_ez
 
    cd keyboard/ergodox_ez
    
Then run `make` for the default keymap, or
    
    make KEYMAP="yourown"
    
for your own keymap. This requires a files keymap_yourown.c in the subfolder keymaps.
You should end up with a `ergodox_ez.hex` file, which you can use with the [Teensy loader](http://www.pjrc.com/teensy/loader_cli.html) or [Teensy GUI](https://www.pjrc.com/teensy/loader.html)

#### Windows

TBD

## License

MIT, see LICENSE