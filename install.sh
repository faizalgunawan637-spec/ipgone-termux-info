#!/usr/bin/env bash
set -Eeuo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bin_dir="${PREFIX:-/data/data/com.termux/files/usr}/bin"

if ! command -v pkg >/dev/null 2>&1; then
  printf 'Script ini ditujukan untuk Termux. Command pkg tidak ditemukan.\n' >&2
  exit 1
fi

pkg update

if ! pkg install -y libimobiledevice usbmuxd termux-api; then
  printf '\nInstall pertama gagal. Mencoba aktifkan root-repo lalu ulangi paket USB...\n' >&2
  pkg install -y root-repo
  pkg install -y libimobiledevice usbmuxd termux-api
fi

mkdir -p "$bin_dir" "${PREFIX:-/data/data/com.termux/files/usr}/var/lib/lockdown" "${PREFIX:-/data/data/com.termux/files/usr}/var/run"
cp "$repo_dir/bin/iphone-info" "$bin_dir/iphone-info"
chmod +x "$bin_dir/iphone-info" "$repo_dir/scripts/doctor.sh"

cat <<'EOF'

Install selesai.

Langkah berikutnya:
  1. Colok iPhone ke HP Android dengan kabel data/OTG.
  2. Unlock iPhone, tekan Trust This Computer.
  3. Jalankan: iphone-info --pair
  4. Kalau gagal: ./scripts/doctor.sh
EOF
