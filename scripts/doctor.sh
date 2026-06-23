#!/usr/bin/env bash
set -Eeuo pipefail

PREFIX_DIR="${PREFIX:-/data/data/com.termux/files/usr}"

check_cmd() {
  local cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    printf '[OK]   %s -> %s\n' "$cmd" "$(command -v "$cmd")"
  else
    printf '[MISS] %s\n' "$cmd"
  fi
}

section() {
  printf '\n== %s ==\n' "$1"
}

section "Environment"
printf 'Shell: %s\n' "${SHELL:-unknown}"
printf 'PREFIX: %s\n' "$PREFIX_DIR"
printf 'Android/Kernel: '
uname -a || true

section "Commands"
check_cmd pkg
check_cmd termux-usb
check_cmd usbmuxd
check_cmd idevice_id
check_cmd idevicepair
check_cmd ideviceinfo

section "Termux directories"
mkdir -p "$PREFIX_DIR/var/lib/lockdown" "$PREFIX_DIR/var/run" 2>/dev/null || true
for dir in "$PREFIX_DIR/var/lib/lockdown" "$PREFIX_DIR/var/run"; do
  if [[ -d "$dir" ]]; then
    printf '[OK]   %s\n' "$dir"
  else
    printf '[MISS] %s\n' "$dir"
  fi
done

section "Android USB list"
if command -v termux-usb >/dev/null 2>&1; then
  termux-usb -l || true
else
  printf 'termux-usb belum ada. Install termux-api dan app Termux:API dari sumber yang sama dengan Termux.\n'
fi

section "iPhone detection"
if command -v idevice_id >/dev/null 2>&1; then
  idevice_id -l || true
else
  printf 'idevice_id belum ada.\n'
fi

section "Pair status"
if command -v idevicepair >/dev/null 2>&1; then
  idevicepair list || true
  idevicepair validate || true
else
  printf 'idevicepair belum ada.\n'
fi

section "Common fixes"
cat <<'EOF'
1. Install Termux dari F-Droid atau GitHub, bukan versi lama dari Play Store.
2. Android harus menjadi USB host/OTG. Kalau kabel USB-C to Lightning/USB-C tidak terdeteksi, coba adapter OTG lain.
3. Unlock iPhone, buka layar utama, lalu tekan "Trust This Computer" dan masukkan passcode.
4. Restart daemon: pkill usbmuxd; usbmuxd -f -v
5. Kalau paket usbmuxd tidak ditemukan: pkg install root-repo lalu pkg install usbmuxd libimobiledevice
EOF
