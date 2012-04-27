-- ============================================================================
-- SCRIPT 03: SEED DATA INISIALISASI (T-SQL / SQL Server)
-- Database: DelphiInsuranceDB
-- ============================================================================

-- 1. SEED ROLES
IF NOT EXISTS (SELECT 1 FROM roles WHERE role_code = 'ROLE_ADMIN')
    INSERT INTO roles (role_code, role_name, description) VALUES ('ROLE_ADMIN', 'IT Security Administrator', 'Akses penuh administrasi RBAC & Audit Trail');

IF NOT EXISTS (SELECT 1 FROM roles WHERE role_code = 'ROLE_MAKER')
    INSERT INTO roles (role_code, role_name, description) VALUES ('ROLE_MAKER', 'Bancassurance Officer (Maker)', 'Registrasi Nasabah & Pembuatan Draft SPAJ Polis');

IF NOT EXISTS (SELECT 1 FROM roles WHERE role_code = 'ROLE_CHECKER')
    INSERT INTO roles (role_code, role_name, description) VALUES ('ROLE_CHECKER', 'Underwriting Officer (Checker)', 'Evaluasi Risiko, Penetapan Loading & Approval Polis');

IF NOT EXISTS (SELECT 1 FROM roles WHERE role_code = 'ROLE_CS')
    INSERT INTO roles (role_code, role_name, description) VALUES ('ROLE_CS', 'Customer Service (Inquiry)', 'Inquiry Status Polis & Cetak Sertifikat Ringkasan');
GO

-- 2. SEED PERMISSIONS
MERGE INTO permissions AS target
USING (VALUES
    ('AUTH', 'LOGIN_APP', 'Login Aplikasi', 'Izin untuk masuk ke aplikasi desktop'),
    ('RBAC', 'SEC_MANAGE_USERS', 'Kelola Pengguna', 'Tambah/Edit/Nonaktifkan akun pengguna'),
    ('RBAC', 'SEC_MANAGE_ROLES', 'Kelola Peran & Hak Akses', 'Konfigurasi matriks permission peran'),
    ('RBAC', 'SEC_VIEW_AUDIT', 'Melihat Audit Trail', 'Melihat catatan kronologis audit log'),
    ('CLIENT', 'CUST_VIEW', 'Lihat Data Nasabah', 'Melihat daftar dan profil nasabah CIF'),
    ('CLIENT', 'CUST_MANAGE', 'Kelola Data Nasabah', 'Registrasi dan update data nasabah'),
    ('POLICY', 'POL_VIEW', 'Lihat Daftar Polis', 'Melihat ringkasan dan rincian polis'),
    ('POLICY', 'POL_CREATE_DRAFT', 'Buat Draft SPAJ', 'Input draft permohonan asuransi baru'),
    ('POLICY', 'POL_EDIT_DRAFT', 'Ubah Draft SPAJ', 'Mengubah komponen premi dan rider draft'),
    ('POLICY', 'POL_SUBMIT_UW', 'Submit ke Underwriting', 'Mengirim draft polis ke antrean checker'),
    ('UW', 'UW_ACCESS_QUEUE', 'Akses Antrean Underwriting', 'Membuka antrean pengajuan polis pending'),
    ('UW', 'UW_APPROVE', 'Persetujuan Polis (Approve)', 'Otorisasi polis menjadi aktif (Inforce)'),
    ('UW', 'UW_REJECT', 'Tolak Polis (Reject)', 'Menolak permohonan asuransi'),
    ('UW', 'UW_SET_LOADING', 'Tetapkan Extra Loading', 'Menetapkan premi tambahan risiko medis/finansial'),
    ('POLICY', 'POL_LAPSE_VOID', 'Batalkan Polis', 'Mengubah status polis menjadi lapsed/batal'),
    ('PRINT', 'POL_PRINT_CERT', 'Cetak Sertifikat Polis', 'Cetak ikhtisar pertanggungan polis')
) AS source (module_group, perm_code, perm_name, description)
ON target.perm_code = source.perm_code
WHEN NOT MATCHED THEN
    INSERT (module_group, perm_code, perm_name, description)
    VALUES (source.module_group, source.perm_code, source.perm_name, source.description);
GO

-- 3. MAPPING ROLE_PERMISSIONS
-- Helper: Assign permissions to roles
DECLARE @RoleAdmin INT = (SELECT id FROM roles WHERE role_code = 'ROLE_ADMIN');
DECLARE @RoleMaker INT = (SELECT id FROM roles WHERE role_code = 'ROLE_MAKER');
DECLARE @RoleChecker INT = (SELECT id FROM roles WHERE role_code = 'ROLE_CHECKER');
DECLARE @RoleCS INT = (SELECT id FROM roles WHERE role_code = 'ROLE_CS');

-- Admin gets all permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT @RoleAdmin, p.id FROM permissions p
WHERE NOT EXISTS (SELECT 1 FROM role_permissions rp WHERE rp.role_id = @RoleAdmin AND rp.permission_id = p.id);

-- Maker: LOGIN_APP, CUST_VIEW, CUST_MANAGE, POL_VIEW, POL_CREATE_DRAFT, POL_EDIT_DRAFT, POL_SUBMIT_UW, POL_PRINT_CERT
INSERT INTO role_permissions (role_id, permission_id)
SELECT @RoleMaker, p.id FROM permissions p
WHERE p.perm_code IN ('LOGIN_APP', 'CUST_VIEW', 'CUST_MANAGE', 'POL_VIEW', 'POL_CREATE_DRAFT', 'POL_EDIT_DRAFT', 'POL_SUBMIT_UW', 'POL_PRINT_CERT')
  AND NOT EXISTS (SELECT 1 FROM role_permissions rp WHERE rp.role_id = @RoleMaker AND rp.permission_id = p.id);

-- Checker: LOGIN_APP, SEC_VIEW_AUDIT, CUST_VIEW, POL_VIEW, UW_ACCESS_QUEUE, UW_APPROVE, UW_REJECT, UW_SET_LOADING, POL_LAPSE_VOID, POL_PRINT_CERT
INSERT INTO role_permissions (role_id, permission_id)
SELECT @RoleChecker, p.id FROM permissions p
WHERE p.perm_code IN ('LOGIN_APP', 'SEC_VIEW_AUDIT', 'CUST_VIEW', 'POL_VIEW', 'UW_ACCESS_QUEUE', 'UW_APPROVE', 'UW_REJECT', 'UW_SET_LOADING', 'POL_LAPSE_VOID', 'POL_PRINT_CERT')
  AND NOT EXISTS (SELECT 1 FROM role_permissions rp WHERE rp.role_id = @RoleChecker AND rp.permission_id = p.id);

-- CS: LOGIN_APP, CUST_VIEW, POL_VIEW, POL_PRINT_CERT
INSERT INTO role_permissions (role_id, permission_id)
SELECT @RoleCS, p.id FROM permissions p
WHERE p.perm_code IN ('LOGIN_APP', 'CUST_VIEW', 'POL_VIEW', 'POL_PRINT_CERT')
  AND NOT EXISTS (SELECT 1 FROM role_permissions rp WHERE rp.role_id = @RoleCS AND rp.permission_id = p.id);
GO

-- 4. SEED USERS (Password hashes using MD5)
-- maker / maker123: 83622fd274819de9c13a1ddaf591cd0a
-- checker / checker123: cbd2008f88fdd6595156c2f1846df76f
-- cs / cs123: 8551e0027ff3a8de9662eb3b8a16c23e
-- admin / admin123: 0192023a7bbd73250516f069df18b500

IF NOT EXISTS (SELECT 1 FROM users WHERE username = 'admin')
    INSERT INTO users (username, password_hash, full_name, nip, email)
    VALUES ('admin', '0192023a7bbd73250516f069df18b500', 'Budi Santoso (IT Security)', 'SEC-001', 'admin.sec@codinabank.co.id');

IF NOT EXISTS (SELECT 1 FROM users WHERE username = 'maker')
    INSERT INTO users (username, password_hash, full_name, nip, email)
    VALUES ('maker', '83622fd274819de9c13a1ddaf591cd0a', 'Dewi Lestari (Bancassurance)', 'BANC-101', 'dewi.lestari@codinabank.co.id');

IF NOT EXISTS (SELECT 1 FROM users WHERE username = 'checker')
    INSERT INTO users (username, password_hash, full_name, nip, email)
    VALUES ('checker', 'cbd2008f88fdd6595156c2f1846df76f', 'Hendro Prasetyo (Underwriter)', 'UW-202', 'hendro.uw@codinabank.co.id');

IF NOT EXISTS (SELECT 1 FROM users WHERE username = 'cs')
    INSERT INTO users (username, password_hash, full_name, nip, email)
    VALUES ('cs', '8551e0027ff3a8de9662eb3b8a16c23e', 'Rina Anggraini (Customer Service)', 'CS-303', 'rina.cs@codinabank.co.id');
GO

-- Map User Roles
DECLARE @UAdmin INT = (SELECT id FROM users WHERE username = 'admin');
DECLARE @UMaker INT = (SELECT id FROM users WHERE username = 'maker');
DECLARE @UChecker INT = (SELECT id FROM users WHERE username = 'checker');
DECLARE @UCS INT = (SELECT id FROM users WHERE username = 'cs');

DECLARE @RAdmin INT = (SELECT id FROM roles WHERE role_code = 'ROLE_ADMIN');
DECLARE @RMaker INT = (SELECT id FROM roles WHERE role_code = 'ROLE_MAKER');
DECLARE @RChecker INT = (SELECT id FROM roles WHERE role_code = 'ROLE_CHECKER');
DECLARE @RCS INT = (SELECT id FROM roles WHERE role_code = 'ROLE_CS');

IF NOT EXISTS (SELECT 1 FROM user_roles WHERE user_id = @UAdmin AND role_id = @RAdmin)
    INSERT INTO user_roles (user_id, role_id) VALUES (@UAdmin, @RAdmin);

IF NOT EXISTS (SELECT 1 FROM user_roles WHERE user_id = @UMaker AND role_id = @RMaker)
    INSERT INTO user_roles (user_id, role_id) VALUES (@UMaker, @RMaker);

IF NOT EXISTS (SELECT 1 FROM user_roles WHERE user_id = @UChecker AND role_id = @RChecker)
    INSERT INTO user_roles (user_id, role_id) VALUES (@UChecker, @RChecker);

IF NOT EXISTS (SELECT 1 FROM user_roles WHERE user_id = @UCS AND role_id = @RCS)
    INSERT INTO user_roles (user_id, role_id) VALUES (@UCS, @RCS);
GO

-- 5. SEED MASTER NASABAH (CIF)
IF NOT EXISTS (SELECT 1 FROM nasabah WHERE no_cif = 'CIF-00109281')
    INSERT INTO nasabah (no_cif, nama_lengkap, no_identitas, tgl_lahir, jenis_kelamin, pekerjaan, kelas_pekerjaan, no_telepon, alamat)
    VALUES ('CIF-00109281', 'Ir. Bambang Wijaya', '3171012304780001', '1978-04-23', 'L', 'Senior IT Director', 1, '081288991122', 'Jl. Senayan Raya No. 45, Jakarta Selatan');

IF NOT EXISTS (SELECT 1 FROM nasabah WHERE no_cif = 'CIF-00109282')
    INSERT INTO nasabah (no_cif, nama_lengkap, no_identitas, tgl_lahir, jenis_kelamin, pekerjaan, kelas_pekerjaan, no_telepon, alamat)
    VALUES ('CIF-00109282', 'Siti Rahmawati, S.E.', '3171021508850003', '1985-08-15', 'P', 'Corporate Finance Manager', 1, '081399882233', 'Komp. Codina Villa Indah Blok B-12, Tangerang');

IF NOT EXISTS (SELECT 1 FROM nasabah WHERE no_cif = 'CIF-00109283')
    INSERT INTO nasabah (no_cif, nama_lengkap, no_identitas, tgl_lahir, jenis_kelamin, pekerjaan, kelas_pekerjaan, no_telepon, alamat)
    VALUES ('CIF-00109283', 'dr. Andreas Sutanto, Sp.A', '3275031102820005', '1982-02-11', 'L', 'Dokter Spesialis Anak', 2, '081177665544', 'Jl. Surya Kencana No. 108, Bogor');
GO

-- 6. SEED KATALOG PRODUK ASURANSI
IF NOT EXISTS (SELECT 1 FROM produk_asuransi WHERE kode_produk = 'PRD-JIWA-01')
    INSERT INTO produk_asuransi (kode_produk, nama_produk, kategori, rate_premi_dasar, min_uang_pertanggungan, max_uang_pertanggungan)
    VALUES ('PRD-JIWA-01', 'Codina Jiwa Sejahtera Proteksi', 'JIWA', 0.0125, 100000000.00, 2000000000.00);

IF NOT EXISTS (SELECT 1 FROM produk_asuransi WHERE kode_produk = 'PRD-KSHT-02')
    INSERT INTO produk_asuransi (kode_produk, nama_produk, kategori, rate_premi_dasar, min_uang_pertanggungan, max_uang_pertanggungan)
    VALUES ('PRD-KSHT-02', 'Codina Prima Sehat Universal', 'KESEHATAN', 0.0180, 50000000.00, 1000000000.00);

IF NOT EXISTS (SELECT 1 FROM produk_asuransi WHERE kode_produk = 'PRD-KCLK-03')
    INSERT INTO produk_asuransi (kode_produk, nama_produk, kategori, rate_premi_dasar, min_uang_pertanggungan, max_uang_pertanggungan)
    VALUES ('PRD-KCLK-03', 'Codina Garda Kecelakaan Diri', 'KECELAKAAN', 0.0085, 50000000.00, 500000000.00);
GO

-- 7. SEED RIDER / ASURANSI TAMBAHAN
IF NOT EXISTS (SELECT 1 FROM rider WHERE kode_rider = 'RDR-HCP-01')
    INSERT INTO rider (kode_rider, nama_rider, kategori_manfaat, rate_premi_rider)
    VALUES ('RDR-HCP-01', 'Hospital Cash Plan (Santunan Harian Rawat Inap)', 'RAWAT_INAP', 0.0045);

IF NOT EXISTS (SELECT 1 FROM rider WHERE kode_rider = 'RDR-CI-02')
    INSERT INTO rider (kode_rider, nama_rider, kategori_manfaat, rate_premi_rider)
    VALUES ('RDR-CI-02', 'Critical Illness 45 Conditions Shield', 'PENYAKIT_KRITIS', 0.0065);

IF NOT EXISTS (SELECT 1 FROM rider WHERE kode_rider = 'RDR-TPD-03')
    INSERT INTO rider (kode_rider, nama_rider, kategori_manfaat, rate_premi_rider)
    VALUES ('RDR-TPD-03', 'Total & Permanent Disability Protection', 'CACAT_TETAP', 0.0030);
GO

-- 8. SEED POLIS PERCONTOHAN (Maker-Checker Lifecycle Demo)
DECLARE @Nasabah1 INT = (SELECT id FROM nasabah WHERE no_cif = 'CIF-00109281');
DECLARE @Nasabah2 INT = (SELECT id FROM nasabah WHERE no_cif = 'CIF-00109282');
DECLARE @Nasabah3 INT = (SELECT id FROM nasabah WHERE no_cif = 'CIF-00109283');

DECLARE @ProdJiwa INT = (SELECT id FROM produk_asuransi WHERE kode_produk = 'PRD-JIWA-01');
DECLARE @ProdKsht INT = (SELECT id FROM produk_asuransi WHERE kode_produk = 'PRD-KSHT-02');

DECLARE @UserMaker INT = (SELECT id FROM users WHERE username = 'maker');
DECLARE @UserChecker INT = (SELECT id FROM users WHERE username = 'checker');

-- Polis 1: Status SUBMITTED (Sedang menunggu approval Checker di Antrean Underwriting)
IF NOT EXISTS (SELECT 1 FROM polis_header WHERE no_spaj = 'SPAJ-2012-000101')
BEGIN
    INSERT INTO polis_header (
        no_polis, no_spaj, tgl_pengajuan, tgl_mulai_berlaku, tgl_berakhir,
        pemegang_polis_id, tertanggung_id, produk_id, cara_bayar,
        uang_pertanggungan, premi_dasar, total_premi_rider, extra_loading_premi, total_premi_berkala,
        status_polis, maker_user_id, submitted_at
    ) VALUES (
        'POL-201204-00101', 'SPAJ-2012-000101', '2012-04-01', '2012-04-15', '2022-04-15',
        @Nasabah1, @Nasabah1, @ProdJiwa, 'TAHUNAN',
        500000000.00, 6250000.00, 3250000.00, 0.00, 9500000.00,
        'SUBMITTED', @UserMaker, '2012-04-01 10:30:00'
    );

    DECLARE @PolisID1 INT = SCOPE_IDENTITY();
    DECLARE @RdrHCP INT = (SELECT id FROM rider WHERE kode_rider = 'RDR-HCP-01');
    DECLARE @RdrCI INT = (SELECT id FROM rider WHERE kode_rider = 'RDR-CI-02');

    INSERT INTO polis_rider_detail (polis_header_id, rider_id, uang_pertanggungan_rider, rate_premi, premi_rider)
    VALUES (@PolisID1, @RdrHCP, 200000000.00, 0.0045, 900000.00);

    INSERT INTO polis_rider_detail (polis_header_id, rider_id, uang_pertanggungan_rider, rate_premi, premi_rider)
    VALUES (@PolisID1, @RdrCI, 300000000.00, 0.0065, 1950000.00);
END

-- Polis 2: Status INFORCE (Sudah disetujui Checker sebelumnya)
IF NOT EXISTS (SELECT 1 FROM polis_header WHERE no_spaj = 'SPAJ-2012-000095')
BEGIN
    INSERT INTO polis_header (
        no_polis, no_spaj, tgl_pengajuan, tgl_mulai_berlaku, tgl_berakhir,
        pemegang_polis_id, tertanggung_id, produk_id, cara_bayar,
        uang_pertanggungan, premi_dasar, total_premi_rider, extra_loading_premi, total_premi_berkala,
        status_polis, maker_user_id, submitted_at, checker_user_id, underwriting_decision, underwriting_notes, approved_at
    ) VALUES (
        'POL-201203-00095', 'SPAJ-2012-000095', '2012-03-12', '2012-03-15', '2022-03-15',
        @Nasabah2, @Nasabah2, @ProdKsht, 'BULANAN',
        200000000.00, 3600000.00, 0.00, 0.00, 3600000.00,
        'INFORCE', @UserMaker, '2012-03-12 14:10:00', @UserChecker, 'APPROVED', 'Standard Risk Acceptance. Profil medis dan finansial bersih.', '2012-03-15 09:20:00'
    );
END
GO

-- 9. INITIAL AUDIT TRAIL LOG
IF NOT EXISTS (SELECT 1 FROM audit_logs WHERE action_name = 'SYSTEM_INIT')
    INSERT INTO audit_logs (user_id, action_name, table_name, record_id, log_detail)
    VALUES (NULL, 'SYSTEM_INIT', 'SYSTEM', 'DB_INIT', 'Inisialisasi database perbankan DelphiInsuranceDB dan master data RBAC berhasil.');
GO
