$cert=New-SelfSignedCertificate -Subject "CN=CR-DEMO-AUTHORING" -CertStoreLocation "Cert:\CurrentUser\My"  -KeyExportPolicy Exportable -KeySpec Signature