# Kanji Bites

Kanji Bites adalah aplikasi web sederhana berbasis Laravel untuk latihan kanji dasar menggunakan flashcard.

## Fitur

- menampilkan 10 kanji dasar
- menampilkan arti, onyomi, kunyomi, dan contoh penggunaan
- membuka dan menyembunyikan jawaban
- berpindah ke kartu sebelumnya dan berikutnya

## Tech Stack

- Laravel 12
- Blade
- Vanilla CSS
- Vanilla JavaScript
- PHPUnit
- Laravel Pint
- GitHub Actions

## Menjalankan Project

Clone repository lalu masuk ke folder project.

`git clone https://github.com/KEPL2026/evolusi-pl-24-541430-SV-24905.git`

`cd evolusi-pl-24-541430-SV-24905`

Install dependency.

`composer install`

Siapkan environment.

`cp .env.example .env`

`php artisan key:generate`

Jalankan aplikasi.

`php artisan serve`

Aplikasi dapat dibuka melalui:

`http://127.0.0.1:8000`

## Testing

Menjalankan automated test:

`php artisan test`

Memeriksa format kode:

`./vendor/bin/pint --test`

## Branching Strategy

Project menggunakan branch:

- `main` untuk versi utama aplikasi
- `dev` untuk proses pengembangan
- `feature/progress-tracker` untuk pengembangan fitur progress

Alur Pull Request:

`feature/progress-tracker → dev → main`

## Conventional Commits

Commit menggunakan format Conventional Commits.

Contoh:

`feat(flashcard): add basic kanji flashcard`

`test(flashcard): add flashcard page test`

`ci: add laravel continuous integration workflow`

## Continuous Integration

GitHub Actions menjalankan dua job:

- `tests` untuk menjalankan test Laravel
- `code-style` untuk memeriksa format PHP menggunakan Laravel Pint

## Author

Della Nurizki

## Delivery Pipeline

Project menggunakan workflow GitHub Actions dengan empat tahap:

`build → test → staging → production`

### Build

Job `build` memasang dependency Composer sebagai tahap awal persiapan aplikasi.

### Test

Job `test` menggunakan `needs: build`, menyiapkan environment Laravel, menghasilkan application key, lalu menjalankan `php artisan test` dan Laravel Pint.

### Staging

Job `staging` menggunakan `needs: test`, sehingga tahap ini hanya dapat dilanjutkan apabila automated test berhasil. Deployment staging pada tugas ini masih disimulasikan menggunakan `echo`.

### Production

Job `production` menggunakan `needs: staging` dan hanya diizinkan berjalan pada branch `main`. Job ini menggunakan GitHub Environment `production` dengan required reviewer.

Tujuh langkah deployment Laravel disimulasikan sebagai `echo` pada workflow, sedangkan urutan perintah aslinya disimpan pada `deploy.sh`.

### Deployment Steps

1. mengaktifkan maintenance mode
2. mengambil kode terbaru dari branch `main`
3. memasang dependency production
4. menjalankan migration
5. membangun ulang configuration, route, dan view cache
6. me-restart queue worker
7. menonaktifkan maintenance mode

Pada pengerjaan tugas ini, GitHub organization sedang dalam kondisi flagged sehingga workflow GitHub Actions tidak dapat dieksekusi secara normal. Validasi aplikasi dan automated test tetap dilakukan secara lokal.

## Vue Frontend

Aplikasi memiliki frontend Vue 3 terpisah di folder `frontend/`. Vue menggunakan Vue Router dengan halaman beranda dan halaman daftar kanji.

Data daftar kanji diambil dari endpoint Laravel:

`GET /api/kanji`

Alamat backend tidak ditulis langsung di source code frontend. Nilainya dibaca dari environment variable:

`VITE_API_URL`

Untuk menjalankan frontend secara lokal:

```bash
cd frontend
cp .env.example .env
npm install
npm run dev
```
