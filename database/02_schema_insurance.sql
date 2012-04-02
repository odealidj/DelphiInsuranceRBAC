-- ============================================================================
-- SCRIPT 02: SCHEMA CORE INSURANCE & BANCASSURANCE (T-SQL / SQL Server)
-- Database: DelphiInsuranceDB
-- ============================================================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'nasabah')
BEGIN
    CREATE TABLE nasabah (
        id INT IDENTITY(1,1) PRIMARY KEY,
        no_cif VARCHAR(30) NOT NULL UNIQUE,         -- Customer Information File
        nama_lengkap VARCHAR(100) NOT NULL,
        no_identitas VARCHAR(30) NOT NULL UNIQUE,   -- No KTP / Paspor
        tgl_lahir DATE NOT NULL,
        jenis_kelamin CHAR(1) NOT NULL CHECK(jenis_kelamin IN ('L', 'P')),
        pekerjaan VARCHAR(100) NOT NULL,
        kelas_pekerjaan INT NOT NULL DEFAULT 1,     -- Kelas Risiko 1 s/d 4
        no_telepon VARCHAR(30) NULL,
        alamat VARCHAR(255) NULL,
        created_at DATETIME NOT NULL DEFAULT GETDATE()
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'produk_asuransi')
BEGIN
    CREATE TABLE produk_asuransi (
        id INT IDENTITY(1,1) PRIMARY KEY,
        kode_produk VARCHAR(30) NOT NULL UNIQUE,
        nama_produk VARCHAR(100) NOT NULL,
        kategori VARCHAR(30) NOT NULL,              -- 'JIWA', 'KESEHATAN', 'KECELAKAAN'
        rate_premi_dasar DECIMAL(18,4) NOT NULL,    -- Tarif per 1.000 Uang Pertanggungan
        min_uang_pertanggungan DECIMAL(18,2) NOT NULL,
        max_uang_pertanggungan DECIMAL(18,2) NOT NULL,
        is_active BIT NOT NULL DEFAULT 1
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'rider')
BEGIN
    CREATE TABLE rider (
        id INT IDENTITY(1,1) PRIMARY KEY,
        kode_rider VARCHAR(30) NOT NULL UNIQUE,
        nama_rider VARCHAR(100) NOT NULL,
        kategori_manfaat VARCHAR(30) NOT NULL,      -- 'RAWAT_INAP', 'PENYAKIT_KRITIS', 'CACAT_TETAP'
        rate_premi_rider DECIMAL(18,4) NOT NULL,
        is_active BIT NOT NULL DEFAULT 1
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'polis_header')
BEGIN
    CREATE TABLE polis_header (
        id INT IDENTITY(1,1) PRIMARY KEY,
        no_polis VARCHAR(50) NOT NULL UNIQUE,       -- Format: POL-YYYYMM-XXXXX
        no_spaj VARCHAR(50) NOT NULL UNIQUE,        -- Surat Permintaan Asuransi Jiwa
        tgl_pengajuan DATE NOT NULL,
        tgl_mulai_berlaku DATE NULL,
        tgl_berakhir DATE NULL,
        
        -- Relasi Nasabah
        pemegang_polis_id INT NOT NULL,
        tertanggung_id INT NOT NULL,
        produk_id INT NOT NULL,
        
        -- Struktur Keuangan Polis (Standar Perbankan: DECIMAL 18,2)
        cara_bayar VARCHAR(20) NOT NULL DEFAULT 'TAHUNAN', -- 'BULANAN', 'KUARTALAN', 'SEMESTERAN', 'TAHUNAN'
        uang_pertanggungan DECIMAL(18,2) NOT NULL,
        premi_dasar DECIMAL(18,2) NOT NULL,
        total_premi_rider DECIMAL(18,2) NOT NULL DEFAULT 0,
        extra_loading_premi DECIMAL(18,2) NOT NULL DEFAULT 0, -- Premi tambahan dari Underwriting
        total_premi_berkala DECIMAL(18,2) NOT NULL,           -- Grand Total yang wajib dibayar
        
        -- Status Workflow Maker-Checker
        -- 'DRAFT' -> 'SUBMITTED' -> 'INFORCE' (Disetujui) / 'REJECTED' (Ditolak) / 'LAPSED' (Batal)
        status_polis VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
        
        -- Informasi Maker (Input)
        maker_user_id INT NOT NULL,
        submitted_at DATETIME NULL,
        
        -- Informasi Checker (Underwriting)
        checker_user_id INT NULL,
        underwriting_decision VARCHAR(50) NULL,
        underwriting_notes NVARCHAR(MAX) NULL,
        approved_at DATETIME NULL,
        
        created_at DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_polis_pemegang FOREIGN KEY (pemegang_polis_id) REFERENCES nasabah(id),
        CONSTRAINT FK_polis_tertanggung FOREIGN KEY (tertanggung_id) REFERENCES nasabah(id),
        CONSTRAINT FK_polis_produk FOREIGN KEY (produk_id) REFERENCES produk_asuransi(id),
        CONSTRAINT FK_polis_maker FOREIGN KEY (maker_user_id) REFERENCES users(id),
        CONSTRAINT FK_polis_checker FOREIGN KEY (checker_user_id) REFERENCES users(id)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'polis_rider_detail')
BEGIN
    CREATE TABLE polis_rider_detail (
        id INT IDENTITY(1,1) PRIMARY KEY,
        polis_header_id INT NOT NULL,
        rider_id INT NOT NULL,
        uang_pertanggungan_rider DECIMAL(18,2) NOT NULL,
        rate_premi DECIMAL(18,4) NOT NULL,
        premi_rider DECIMAL(18,2) NOT NULL,
        CONSTRAINT FK_rider_detail_header FOREIGN KEY (polis_header_id) REFERENCES polis_header(id) ON DELETE CASCADE,
        CONSTRAINT FK_rider_detail_rider FOREIGN KEY (rider_id) REFERENCES rider(id)
    );
END
GO
