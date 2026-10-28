# DelphiInsuranceRBAC — Core Bancassurance & Policy Administration System

![Platform](https://img.shields.io/badge/Platform-Win32%20Native-0078D6?style=flat-square)
![Compiler](https://img.shields.io/badge/Delphi-Borland%20Delphi%207%20%7C%20RAD%20Studio-E62429?style=flat-square)
![Database](https://img.shields.io/badge/Database-Microsoft%20SQL%20Server%20(T--SQL)-CC2927?style=flat-square)
![Data%20Access](https://img.shields.io/badge/Data%20Access-ADO%20%2F%20dbGo%20(OLEDB)-5C2D91?style=flat-square)
![Compliance](https://img.shields.io/badge/Security-RBAC%20%26%20Dual%20Control%20(Maker--Checker)-2EA44F?style=flat-square)

Sistem *enterprise desktop* untuk administrasi polis asuransi dan operasional *bancassurance* berbasis **Borland Delphi 7 VCL & ADO (`dbGo`)** dengan backend **Microsoft SQL Server**. Proyek ini dirancang dengan arsitektur modular 3-Tier untuk menangani siklus penuh penerbitan polis (**Master-Detail**), perhitungan premi aktuaria, serta penegakan kepatuhan **Role-Based Access Control (RBAC)** dan **Segregation of Duties (Maker-Checker / Four-Eyes Principle)**.

---

## 📌 Ikhtisar Arsitektur & Kepatuhan Sistem

Sistem ini memisahkan lapisan presentasi VCL, logika bisnis/otorisasi, dan akses data transaksional ke dalam modul-modul terisolasi:

```
+-------------------------------------------------------------------------------+
|                           PRESENTATION TIER (VCL UI)                          |
|  frmMain (Dashboard Shell) | frmLogin (Session Auth) | frmCustomer (Master)   |
|  frmPolicy (Master-Detail SPAJ) | frmUnderwriting (Approval) | frmUserRole    |
|  * Terintegrasi dengan TActionList yang dikendalikan secara dinamis oleh RBAC |
+---------------------------------------+---------------------------------------+
                                        |
                                        v
+---------------------------------------+---------------------------------------+
|                         BUSINESS LOGIC & SECURITY TIER                        |
|  dmSecurity (RBAC Engine, Permission Matrix, Session Context, Audit Trail)    |
|  dmInsurance (Kalkulasi Premi Aktuaria, Validasi Dual Control Maker-Checker)  |
|  uMD5 (RFC 1321 Native Hash) | uFormatUtils (Currency/Masking) | uAppConst    |
+---------------------------------------+---------------------------------------+
                                        |
                                        v
+---------------------------------------+---------------------------------------+
|                           DATA ACCESS & STORAGE TIER                          |
|  dmConnection (TADOConnection, ACID Transaction: Begin/Commit/RollbackTrans)  |
|  Microsoft SQL Server (T-SQL Relational Schema, DECIMAL(18,2) Precision)      |
+-------------------------------------------------------------------------------+
```

### Fitur Utama
1. **Administrasi Siklus Hidup Polis (Master-Detail)**
   - **Master (`polis_header`)**: Registrasi Surat Permintaan Asuransi Jiwa (SPAJ), penomoran polis otomatis, relasi Pemegang Polis & Tertanggung (CIF), frekuensi pembayaran (*Tahunan, Semesteran, Kuartalan, Bulanan*), dan nilai Uang Pertanggungan.
   - **Detail (`polis_rider_detail`)**: Penambahan manfaat asuransi tambahan (*Hospital Cash Plan, Critical Illness, Personal Accident*) dengan perhitungan tarif premi proporsional secara *real-time*.
   - **State Machine Transaksi**: `DRAFT` ➔ `SUBMITTED` ➔ `INFORCE` (Disetujui) / `REJECTED` (Ditolak) / `LAPSED` (Berakhir/Batal).

2. **Kepatuhan Dual Control (Maker-Checker) & Otorisasi RBAC**
   - **Pemisahan Tugas Ketat (*Segregation of Duties*)**: Petugas *Maker* (Bancassurance Officer) hanya dapat menyusun draft SPAJ dan mengajukannya ke antrean underwriting. Sistem memblokir *Maker* agar tidak dapat menyetujui (*approve*) pengajuan miliknya sendiri, baik di level antarmuka (`TActionList`) maupun validasi di level *DataModule*.
   - **Evaluasi Risiko (*Underwriting*)**: Petugas *Checker* (Underwriter) meninjau profil risiko medis/finansial nasabah, menetapkan *extra risk loading* (premi ekstra) bila diperlukan, dan menerbitkan keputusan akhir.
   - **Manajemen Matriks Izin**: Konfigurasi hak akses granular berbasis `TTreeView` yang langsung berdampak pada ketersediaan menu dan aksi pengguna.

3. **Integritas Transaksi ACID & Forensik Audit Trail**
   - Seluruh perubahan status polis, kalkulasi ulang premi, dan keputusan underwriting dibungkus dalam transaksi database atomik (`BeginTrans`, `CommitTrans`, `RollbackTrans`).
   - Setiap aktivitas autentikasi dan perubahan data kritikal dicatat secara otomatis ke dalam tabel `audit_logs` untuk kebutuhan kepatuhan dan audit internal.

---

## 👥 Matriks Peran & Akun Pengujian Bawaan

Skrip *seed database* menyediakan empat akun standar untuk mensimulasikan alur kerja *Maker-Checker*:

| Username | Password | Role / Jabatan | Hak Akses Operasional | Restriksi Keamanan (RBAC) |
|:---|:---|:---|:---|:---|
| `maker` | `maker123` | **Bancassurance Officer** | Registrasi CIF nasabah, buat draft SPAJ, kelola rider, kirim ke Underwriting | Dilarang melakukan *Approve/Reject* polis & dilarang mengakses modul RBAC |
| `checker` | `checker123` | **Underwriting Officer** | Akses antrean Underwriting, input *extra loading*, *Approve* (`INFORCE`) / *Reject* | Dilarang membuat draft SPAJ baru & dilarang mengubah konfigurasi role |
| `cs` | `cs123` | **Customer Service** | Pencarian polis (*inquiry*), rincian manfaat, cetak ikhtisar sertifikat polis | Mode **Read-Only**; seluruh aksi modifikasi data dinonaktifkan |
| `admin` | `admin123` | **IT Security Admin** | Manajemen akun pengguna, konfigurasi matriks izin `TTreeView`, inspeksi *Audit Trail* | Akses penuh ke administrasi keamanan sistem |

---

## 📂 Struktur Direktori

```text
DelphiInsuranceRBAC/
├── database/                     # Skrip DDL & Seed Data Microsoft SQL Server (T-SQL)
│   ├── 01_schema_rbac.sql        # Skema tabel Users, Roles, Permissions, dan Audit Logs
│   ├── 02_schema_insurance.sql   # Skema tabel Nasabah, Produk, Rider, dan Polis (Master-Detail)
│   └── 03_seed_data.sql          # Data awal akun RBAC, katalog produk aktuaria, dan sampel polis
├── src/                          # Kode sumber Object Pascal (Native Delphi 7)
│   ├── Data/                     # DataModules (uSecurityModule, uInsuranceModule, dll.)
│   ├── Forms/                    # VCL Forms (Main, Login, Policy, Underwriting, UserRole, Customer)
│   └── Utils/                    # Unit utilitas mandiri (uFormatUtils, uAppConst, uMD5)
├── DelphiInsuranceRBAC.dpr       # File utama proyek Delphi
├── DelphiInsuranceRBAC.dof       # Konfigurasi opsi proyek Delphi 7
├── DelphiInsuranceRBAC.cfg       # Konfigurasi compiler command-line (DCC32)
├── build_d7.bat                  # Skrip otomatisasi build menggunakan compiler Delphi 7
└── README.md                     # Dokumentasi utama repositori
```

---

## ⚙️ Panduan Instalasi & Kompilasi

### 1. Persiapan Database (Microsoft SQL Server)
Jalankan skrip T-SQL pada direktori `database/` secara berurutan di instance SQL Server Anda (mendukung SQL Server 2008 R2 ke atas maupun SQL Server LocalDB via SSMS / `sqlcmd`):
1. `database/01_schema_rbac.sql`
2. `database/02_schema_insurance.sql`
3. `database/03_seed_data.sql`

### 2. Kompilasi Proyek
Proyek ini ditulis menggunakan standar Object Pascal murni tanpa ketergantungan komponen pihak ketiga (*100% Native VCL*), sehingga dapat dikompilasi langsung di **Borland Delphi 7** maupun dibuka pada **Embarcadero RAD Studio** versi terbaru (dalam rangka pemeliharaan/migrasi).

Untuk melakukan kompilasi otomatis melalui *command prompt*:
```bat
build_d7.bat
```
File executable hasil kompilasi akan ditempatkan pada direktori `bin\DelphiInsuranceRBAC.exe`.

---

## 🛠️ Catatan Pemeliharaan (Maintenance Log)
- **2012 (Initial Release)**: Pengembangan awal *core system* administrasi polis bancassurance, modul RBAC, dan implementasi *Maker-Checker* di lingkungan Borland Delphi 7 & SQL Server.
- **2026 (Documentation & Compatibility Maintenance)**: Pembaruan dokumentasi repositori, standarisasi skrip otomatisasi build, dan pengujian kompatibilitas koneksi OLEDB/LocalDB pada lingkungan Windows modern.
