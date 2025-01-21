# Blinking Cat Ears

Dump of code for blinking cat ears using an ESP32 and Toit/Jaguar.

Setup: follow the Toit/Jaguar ["Get Started" guide](https://docs.toit.io/getstarted/device) to install Toit and Jaguar and flash your ESP32.

## Included Programs

In `src/`:

- `breathe.toit` generates a breathing animation on an LED
- `breathe-server.toit` listens to HTTP requests and accepts JSON to control a breathing animation
- `ping.toit` example of how to call home if you're building a cat ear botnet ;3

## Running

First install necessary dependencies: `jag pkg install` will read `package.yaml` and install to `.packages/`.

To run a program once, use `jag run <path/to/program.toit>`.

Install a program into a persistant "container" to keep it on the device and run it on boot: `jag container install <container-name> <path/to/program.toit>`.

## Toit Miscellanea

- High level Toit language guides and docs: https://docs.toit.io/language
- API documentation: https://libs.toit.io/
