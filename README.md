# ipgone-termux-info

Repo kecil untuk cek info iPhone dari Termux di Android lewat kabel data USB/OTG.

Tool ini memakai `libimobiledevice` (`idevice_id`, `idevicepair`, `ideviceinfo`) dan `usbmuxd`. iPhone harus milik sendiri/diizinkan, harus unlock, dan harus menekan **Trust This Computer**. Ini bukan tool bypass iCloud, bukan bypass passcode, dan bukan alat untuk mengambil data diam-diam.

## Yang dibutuhkan

- HP Android dengan Termux terbaru dari F-Droid atau GitHub.
- Dukungan USB OTG/USB host di HP Android.
- Kabel data yang benar-benar mendukung data, bukan charge-only.
- iPhone yang bisa di-unlock dan diberi trust.
- Paket Termux: `libimobiledevice`, `usbmuxd`, dan opsional `termux-api`.

## Install di Termux

```sh
pkg update
pkg install git
git clone https://github.com/faizalgunawan637-spec/ipgone-termux-info.git
cd ipgone-termux-info
chmod +x install.sh bin/iphone-info scripts/doctor.sh
./install.sh
```

Kalau kamu belum upload ke GitHub, pindahkan folder repo ini ke Termux lalu jalankan:

```sh
cd ipgone-termux-info
chmod +x install.sh bin/iphone-info scripts/doctor.sh
./install.sh
```

## Cara pakai

1. Colok iPhone ke HP Android. Pada banyak setup, Android harus menjadi sisi host/OTG.
2. Unlock iPhone.
3. Saat muncul prompt di iPhone, tekan **Trust This Computer** lalu masukkan passcode.
4. Jalankan:

```sh
iphone-info --pair
```

Untuk semua info mentah dari `ideviceinfo`:

```sh
iphone-info --raw
```

Untuk XML/plist:

```sh
iphone-info --xml
```

Kalau ada lebih dari satu iPhone:

```sh
idevice_id -l
iphone-info --udid UDID_DARI_OUTPUT
```

## Troubleshooting

Jalankan:

```sh
./scripts/doctor.sh
```

Masalah umum:

- `idevice_id -l` kosong: cek OTG, kabel data, iPhone sudah unlock, dan prompt Trust.
- `usbmuxd` tidak ditemukan: jalankan `pkg install root-repo` lalu `pkg install usbmuxd libimobiledevice`.
- Pairing gagal: jalankan `pkill usbmuxd; usbmuxd -f -v`, cabut-colok kabel, lalu `iphone-info --pair`.
- Termux dari Play Store lama sering bermasalah. Pakai build dari F-Droid atau GitHub.

## Batasan

Akses USB dari Termux di Android tidak sesederhana Linux desktop. Di sebagian perangkat non-root, `usbmuxd` bisa berjalan; di sebagian lain, permission USB, implementasi vendor, atau kabel membuat iPhone tidak terlihat. Repo ini memberi wrapper dan diagnosa, tetapi tidak bisa memaksa Android memberi akses USB kalau sistemnya menolak.

## File penting

- `bin/iphone-info`: CLI utama.
- `scripts/doctor.sh`: pengecekan environment dan saran perbaikan.
- `install.sh`: installer paket dan command `iphone-info`.

## Referensi teknis

- libimobiledevice: <https://libimobiledevice.org/>
- usbmuxd: <https://github.com/libimobiledevice/usbmuxd>
- Paket Termux libimobiledevice: <https://github.com/termux/termux-packages/blob/master/packages/libimobiledevice/build.sh>
