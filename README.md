DelphiInsuranceRBAC - Core Bancassurance & Policy Administration
================================================================

Aplikasi desktop berbasis Borland Delphi 7 VCL & ADO (dbGo) dengan database
Microsoft SQL Server untuk simulasi administrasi penerbitan polis asuransi
(Master-Detail) serta manajemen hak akses Role-Based Access Control (RBAC)
dengan prinsip Dual Control (Maker-Checker).

Fitur Utama
-----------
1. Administrasi Polis Asuransi (Master-Detail)
   - Input pengajuan SPAJ, data Pemegang Polis dan Tertanggung (CIF).
   - Perhitungan premi dasar dan penambahan manfaat tambahan (Rider).
   - Alur status polis: DRAFT -> SUBMITTED -> INFORCE / REJECTED / LAPSED.

2. Otorisasi RBAC & Maker-Checker
   - Maker (Bancassurance Officer): Input data nasabah dan pengajuan SPAJ.
   - Checker (Underwriter): Evaluasi risiko dan persetujuan/penolakan polis.
   - Customer Service: Akses inquiry (Read-Only) dan cetak ringkasan polis.
   - Administrator: Pengaturan pengguna, matriks hak akses, dan audit log.

Akun Pengujian Default
----------------------
- maker   / maker123   (Bancassurance Officer - Maker)
- checker / checker123 (Underwriting Officer - Checker)
- cs      / cs123      (Customer Service - Inquiry)
- admin   / admin123   (IT Security Administrator)

Kompilasi Proyek
----------------
1. Jalankan skrip SQL di folder database/ secara berurutan pada SQL Server:
   - 01_schema_rbac.sql
   - 02_schema_insurance.sql
   - 03_seed_data.sql
2. Buka DelphiInsuranceRBAC.dpr menggunakan Borland Delphi 7 atau jalankan
   skrip build_d7.bat.
