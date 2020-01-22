// Instalar paquetes para correr 
// directamente en ios.

// Usen esto para una instalación totalmente nueva
// y desinstalar versiones anteriores.


brew update
brew uninstall --ignore-dependencies libimobiledevice
brew uninstall --ignore-dependencies usbmuxd
brew install --HEAD usbmuxd
brew unlink usbmuxd
brew link usbmuxd
brew install --HEAD libimobiledevice
brew install ideviceinstaller