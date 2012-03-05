unit uAppConst;

interface

const
  // Application Info
  APP_TITLE = 'DelphiInsuranceRBAC: Core Bancassurance System';
  APP_VERSION = '1.0.0 (Delphi 7 Enterprise Win32)';

  // Status Workflow Polis (Maker-Checker Lifecycle)
  POL_STATUS_DRAFT     = 'DRAFT';      // Dibuat oleh Maker
  POL_STATUS_SUBMITTED = 'SUBMITTED';  // Diajukan Maker ke antrean Underwriting
  POL_STATUS_INFORCE   = 'INFORCE';    // Disetujui Checker (Polis Aktif Berjalan)
  POL_STATUS_REJECTED  = 'REJECTED';   // Ditolak Checker (Risiko tidak dapat diterima)
  POL_STATUS_LAPSED    = 'LAPSED';     // Batal karena premi tidak dibayar / void

  // Cara Bayar Premi Polis
  FREQ_BULANAN   = 'BULANAN';
  FREQ_KUARTALAN = 'KUARTALAN';
  FREQ_SEMESTERAN= 'SEMESTERAN';
  FREQ_TAHUNAN   = 'TAHUNAN';

  // Keputusan Underwriter
  UW_DECISION_APPROVED = 'APPROVED';
  UW_DECISION_REJECTED = 'REJECTED';
  UW_DECISION_POSTPONE = 'POSTPONE';

  // Role Codes
  ROLE_CODE_ADMIN   = 'ROLE_ADMIN';
  ROLE_CODE_MAKER   = 'ROLE_MAKER';
  ROLE_CODE_CHECKER = 'ROLE_CHECKER';
  ROLE_CODE_CS      = 'ROLE_CS';

  // Permissions Codes (RBAC Matrix)
  PERM_LOGIN_APP        = 'LOGIN_APP';
  PERM_SEC_MANAGE_USERS = 'SEC_MANAGE_USERS';
  PERM_SEC_MANAGE_ROLES = 'SEC_MANAGE_ROLES';
  PERM_SEC_VIEW_AUDIT   = 'SEC_VIEW_AUDIT';
  PERM_CUST_VIEW        = 'CUST_VIEW';
  PERM_CUST_MANAGE      = 'CUST_MANAGE';
  PERM_POL_VIEW         = 'POL_VIEW';
  PERM_POL_CREATE_DRAFT = 'POL_CREATE_DRAFT';
  PERM_POL_EDIT_DRAFT   = 'POL_EDIT_DRAFT';
  PERM_POL_SUBMIT_UW    = 'POL_SUBMIT_UW';
  PERM_UW_ACCESS_QUEUE  = 'UW_ACCESS_QUEUE';
  PERM_UW_APPROVE       = 'UW_APPROVE';
  PERM_UW_REJECT        = 'UW_REJECT';
  PERM_UW_SET_LOADING   = 'UW_SET_LOADING';
  PERM_POL_LAPSE_VOID   = 'POL_LAPSE_VOID';
  PERM_POL_PRINT_CERT   = 'POL_PRINT_CERT';

implementation

end.
