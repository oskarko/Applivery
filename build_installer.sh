#!/bin/bash

set -e

# VARIABLES
APP_NAME="MarvelComicsApp"
IDENTIFIER="com.oscargarrucho.marvelcomicsapp"
VERSION="1.0"
EXPORT_APP_PATH="$HOME/Desktop/${APP_NAME}.app"
PKG_DIR="Build"

# CLEANUP
rm -rf "$PKG_DIR"
mkdir -p "$PKG_DIR/Payload/Applications"
mkdir -p "$PKG_DIR/LaunchAgent"

# COPY .app
if [ ! -d "$EXPORT_APP_PATH" ]; then
  echo "❌ ERROR: No se encontró la app en $EXPORT_APP_PATH"
  echo "Asegúrate de exportarla desde Xcode con Distribute > Custom > Copy App"
  exit 1
fi

cp -R "$EXPORT_APP_PATH" "$PKG_DIR/Payload/Applications/"
echo "✅ App copiada a Payload"

# CREATE .plist
cat > "$PKG_DIR/LaunchAgent/${IDENTIFIER}.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>${IDENTIFIER}</string>
  <key>ProgramArguments</key>
  <array>
    <string>/Applications/${APP_NAME}.app/Contents/MacOS/${APP_NAME}</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
</dict>
</plist>
EOF

# BUILD .pkg para la app
pkgbuild \
  --identifier ${IDENTIFIER} \
  --install-location /Applications \
  --component "$PKG_DIR/Payload/Applications/${APP_NAME}.app" \
  "$PKG_DIR/${APP_NAME}.pkg"

echo "✅ pkg de la app generado"

# BUILD .pkg para el LaunchAgent (usa /Library/LaunchAgents para todos los usuarios)
pkgbuild \
  --identifier ${IDENTIFIER}.launchagent \
  --install-location /Library/LaunchAgents \
  --root "$PKG_DIR/LaunchAgent" \
  "$PKG_DIR/LaunchAgent.pkg"

echo "✅ pkg del LaunchAgent generado"

# COMBINAR EN UN SOLO .pkg
mkdir -p dist
productbuild \
  --identifier ${IDENTIFIER}.fullinstaller \
  --version "$VERSION" \
  --package "$PKG_DIR/${APP_NAME}.pkg" \
  --package "$PKG_DIR/LaunchAgent.pkg" \
  "dist/${APP_NAME}-Full.pkg"

echo "🎉 Instalador generado: dist/${APP_NAME}-Full.pkg"
