# Reactor

Reactor is the firmware generator part of Fusion. The intention for it is to be installed as a service somewhere.
It will take the JSON's exported by the Fusion project and process them in to ready-to-be-uploaded firmware.

Reactor uses the awesome [qmk_firmware](http://github.com/jackhumbert/qmk_firmware) by Jack Humbert.

## Fusion
Fusion is a web-based, open source keyboard-layout maker.

It's supports multiple keyboard types: Ergodox EZ, and [ortholinear](http://ortholinearkeyboards.com)'s Planck and Preonic are currently supported.

As long as your keyboard firmware supports/uses [keycode.h](keycode.h) it should be relatively easy to get it supported.

This project will output [JSON file](keyboard_layout.json) for the full layout (including layers).

## General process

0. Take the JSON from the request
1. Generate a UUID
2. Copy a cloned http://github.com/jackhumbert/qmk_firmware to /tmp/{uuid}
3. Generate a .c file based on the JSON into the appropriate folder (/tmp/{uuid}/keyboard/{type}/keymaps/keymap_{uuid}.c)
4. cd /tmp/{uuid}/keyboard/{type} && make KEYMAP="{uuid}"
5. take the {type}.hex and serve it back in the response