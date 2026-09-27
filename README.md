# Kanji Bites

Kanji Bites adalah aplikasi web sederhana untuk mempelajari kanji dasar. Project ini menggunakan Laravel sebagai backend dan Vue 3 sebagai frontend terpisah.

Laravel menyimpan dan menyediakan data kanji melalui endpoint JSON, sedangkan Vue mengambil data tersebut untuk ditampilkan sebagai daftar kanji yang dapat dicari.

## Fitur

- menampilkan 10 kanji dasar
- menampilkan arti, onyomi, kunyomi, dan contoh penggunaan
- menyediakan endpoint JSON `GET /api/kanji`
- menampilkan data Laravel pada frontend Vue
- menyediakan dua halaman menggunakan Vue Router
- mencari kanji berdasarkan karakter, arti, bacaan, atau contoh
- menyediakan automated test untuk backend dan frontend

## Tech Stack

### Backend

- Laravel 12
- PHP
- SQLite
- PHPUnit
- Laravel Pint

### Frontend

- Vue 3
- Vue Router
- Vite
- Vitest
- ESLint

### Delivery

- Git
- GitHub
- GitHub Actions

## Struktur Project

```text
.
├── app/
├── database/
├── routes/
├── tests/
├── frontend/
│   ├── src/
│   │   ├── router/
│   │   ├── services/
│   │   ├── utils/
│   │   └── views/
│   ├── .env.example
│   ├── package.json
│   └── vite.config.js
├── .github/
│   └── workflows/
│       ├── ci.yml
│       └── frontend.yml
└── deploy.sh
```

## Menjalankan Backend

Clone repository dan masuk ke folder project.

```bash
git clone https://github.com/KEPL2026/evolusi-pl-24-541430-SV-24905.git
cd evolusi-pl-24-541430-SV-24905
```

Install dependency Laravel.

```bash
composer install
```

Siapkan environment.

```bash
cp .env.example .env
php artisan key:generate
```

Jalankan migration dan seeder.

```bash
php artisan migrate --seed
```

Jalankan aplikasi.

```bash
php artisan serve
```

Backend dapat diakses melalui:

```text
http://127.0.0.1:8000
```

## Laravel API

Laravel menyediakan endpoint:

```text
GET /api/kanji
```

Endpoint tersebut membaca data dari tabel `kanji_cards` dan mengembalikannya dalam format JSON.

Contoh struktur response:

```json
{
  "data": [
    {
      "id": 1,
      "character": "日",
      "meaning": "hari / matahari",
      "onyomi": "ニチ・ジツ",
      "kunyomi": "ひ",
      "example": "日本 (にほん) — Jepang"
    }
  ]
}
```

## Menjalankan Frontend

Masuk ke folder frontend.

```bash
cd frontend
```

Siapkan environment.

```bash
cp .env.example .env
```

Konfigurasi alamat backend berada pada:

```text
VITE_API_URL=http://127.0.0.1:8000
```

Install dependency.

```bash
npm install
```

Jalankan Vue.

```bash
npm run dev
```

Frontend dapat diakses melalui:

```text
http://localhost:5173
```

Alamat API tidak ditulis langsung di source code frontend. Nilainya dibaca melalui `VITE_API_URL`.

## Vue Router

Frontend menyediakan dua halaman utama:

```text
/        → halaman beranda
/kanji   → daftar kanji dari Laravel API
```

Halaman `/kanji` mengambil data dari `GET /api/kanji` dan menyediakan pencarian berdasarkan teks yang terdapat pada card.

## Backend Testing

Jalankan automated test Laravel:

```bash
php artisan test
```

Periksa format kode PHP:

```bash
php vendor/bin/pint --test
```

## Frontend Testing

Unit test frontend menggunakan Vitest.

```bash
cd frontend
npm run test
```

Logika pencarian kanji ditempatkan pada fungsi terpisah sehingga unit test dapat berjalan tanpa server Laravel aktif.

Validasi frontend secara lengkap dapat dilakukan dengan:

```bash
npm run lint
npm run test
npm run build
```

Untuk mensimulasikan instalasi dependency pada CI:

```bash
rm -rf node_modules
npm ci
```

## Branching Strategy

Repository menggunakan tiga tingkat branch:

```text
main
└── dev
    └── feature/*
```

`main` digunakan untuk versi utama aplikasi.

`dev` digunakan sebagai branch integrasi sebelum perubahan masuk ke `main`.

`feature/*` digunakan untuk mengembangkan perubahan secara terpisah.

Untuk pengembangan Vue dan frontend pipeline digunakan:

```text
feature/vue-frontend-pipeline
```

Alur integrasinya:

```text
feature/vue-frontend-pipeline
        ↓ Pull Request
       dev
        ↓ Pull Request
       main
```

Perubahan tidak dikirim langsung ke `main`.

## Conventional Commits

Riwayat perubahan menggunakan Conventional Commits.

Contoh commit pada project:

```text
feat(api): add kanji json endpoint
feat(frontend): add vue kanji browser
test(frontend): add kanji filter unit test
ci(frontend): add four-job frontend pipeline
test(frontend): require case-insensitive search
fix(frontend): make kanji search case-insensitive
docs: document vue frontend pipeline
```

## Backend Delivery Pipeline

Workflow backend berada pada:

```text
.github/workflows/ci.yml
```

Pipeline terdiri dari empat tahap:

```text
build → test → staging → production
```

Job `build` memasang dependency Composer.

Job `test` berjalan setelah build dan menjalankan automated test Laravel serta Laravel Pint.

Job `staging` berjalan setelah test berhasil dan mensimulasikan proses deployment.

Job `production` hanya diizinkan pada branch `main` dan menggunakan GitHub Environment `production` dengan required reviewer.

Urutan deployment sebenarnya juga disimpan pada `deploy.sh` menggunakan `set -e`.

## Deployment Steps

Urutan deployment backend adalah:

1. mengaktifkan maintenance mode
2. mengambil kode terbaru dari branch `main`
3. memasang dependency production
4. menjalankan migration
5. membangun ulang configuration, route, dan view cache
6. me-restart queue worker
7. menonaktifkan maintenance mode

Pada tugas deployment, proses deploy masih disimulasikan menggunakan `echo` dan belum dikirim ke server sebenarnya.

## Frontend Pipeline

Workflow frontend berada pada:

```text
.github/workflows/frontend.yml
```

Pipeline terdiri dari empat job:

```text
lint → test → build → deploy
```

Setiap job dihubungkan menggunakan `needs:`.

### Lint

Job `lint` menggunakan npm cache, menjalankan `npm ci`, kemudian memeriksa source code menggunakan ESLint.

### Test

Job `test` berjalan setelah lint.

Dependency dipasang menggunakan:

```bash
npm ci
```

Kemudian unit test dijalankan dengan:

```bash
npm run test
```

Vitest menguji logika aplikasi tanpa membutuhkan Laravel aktif.

### Build

Job `build` berjalan setelah test berhasil.

Build Vue dibuat menggunakan:

```bash
npm run build
```

Hasilnya berada pada:

```text
frontend/dist
```

Folder tersebut kemudian diunggah sebagai artifact:

```text
frontend-dist
```

### Deploy

Job `deploy` berjalan setelah build dan hanya diizinkan pada push ke branch `main`.

Job deploy tidak menjalankan `npm run build` kembali.

Artifact `frontend-dist` yang dibuat oleh job build diunduh kembali oleh job deploy. Isi hasil build kemudian ditampilkan melalui:

```bash
ls -R frontend/dist
```

Dengan demikian, hasil yang diuji dan dibangun pada job sebelumnya adalah hasil yang diteruskan ke tahap deploy.

## Repository Hygiene

File environment lokal dan dependency hasil instalasi tidak disimpan ke Git.

Contoh file yang di-ignore:

```text
.env
frontend/.env
vendor/
frontend/node_modules/
frontend/dist/
```

File konfigurasi contoh dan lockfile tetap disimpan:

```text
.env.example
frontend/.env.example
composer.lock
frontend/package-lock.json
```

## Catatan GitHub Actions

Pada saat pengerjaan, organization GitHub kelas sedang dalam kondisi flagged sehingga workflow GitHub Actions tidak dapat dieksekusi secara normal.

Sesuai pengumuman kelas, workflow tetap disiapkan lengkap di repository. Validasi backend dan frontend dilakukan secara lokal melalui automated test, lint, dan build.

## Author

Della Nurizki
