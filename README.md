# super_slide_puzzle


## Pre-Setup

- Goto asset folder `/assets` and replace following file with new.
  - icon.png 
    - it's a launcher icon (PNG format only)
    - size: 2040 x 2040
  - splash.png
    - splash screen (PNG format only)
    - size: 1414 x 2000
  - logo.png 
    - app logo for home screen (PNG format only)
    - size: 256 x 256
  - boards/board.png
    - game board image (PNG format only)
    - size: 2040 x 2040

### Not update the config in lib
- Goto `/lib/pre-setup.dart` update the `packageName` variable
```
  String packageName = "com.useapi.slide_puzzle"; // with your new package name
```