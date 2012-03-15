-- ============================================================================
-- SCRIPT 01: SCHEMA RBAC & AUDIT LOGS (T-SQL / Microsoft SQL Server)
-- Database: DelphiInsuranceDB
-- ============================================================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'users')
BEGIN
    CREATE TABLE users (
        id INT IDENTITY(1,1) PRIMARY KEY,
        username VARCHAR(50) NOT NULL UNIQUE,
        password_hash VARCHAR(64) NOT NULL,
        full_name VARCHAR(100) NOT NULL,
        nip VARCHAR(30) NULL,
        email VARCHAR(100) NULL,
        is_active BIT NOT NULL DEFAULT 1,
        created_at DATETIME NOT NULL DEFAULT GETDATE()
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'roles')
BEGIN
    CREATE TABLE roles (
        id INT IDENTITY(1,1) PRIMARY KEY,
        role_code VARCHAR(30) NOT NULL UNIQUE,
        role_name VARCHAR(50) NOT NULL,
        description VARCHAR(255) NULL,
        is_active BIT NOT NULL DEFAULT 1
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'permissions')
BEGIN
    CREATE TABLE permissions (
        id INT IDENTITY(1,1) PRIMARY KEY,
        module_group VARCHAR(30) NOT NULL,
        perm_code VARCHAR(50) NOT NULL UNIQUE,
        perm_name VARCHAR(100) NOT NULL,
        description VARCHAR(255) NULL
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'user_roles')
BEGIN
    CREATE TABLE user_roles (
        user_id INT NOT NULL,
        role_id INT NOT NULL,
        assigned_at DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT PK_user_roles PRIMARY KEY (user_id, role_id),
        CONSTRAINT FK_user_roles_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        CONSTRAINT FK_user_roles_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'role_permissions')
BEGIN
    CREATE TABLE role_permissions (
        role_id INT NOT NULL,
        permission_id INT NOT NULL,
        CONSTRAINT PK_role_permissions PRIMARY KEY (role_id, permission_id),
        CONSTRAINT FK_role_perm_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
        CONSTRAINT FK_role_perm_perm FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'audit_logs')
BEGIN
    CREATE TABLE audit_logs (
        id INT IDENTITY(1,1) PRIMARY KEY,
        user_id INT NULL,
        action_name VARCHAR(50) NOT NULL,
        table_name VARCHAR(50) NULL,
        record_id VARCHAR(50) NULL,
        log_detail NVARCHAR(MAX) NULL,
        created_at DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_audit_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
    );
END
GO
