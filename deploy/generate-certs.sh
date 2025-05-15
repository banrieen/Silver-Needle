
#!/bin/bash
#=========================================================================================================================
# Info: 初始化证书
# Creator: banrieen
# Update: 2021-07-31 
# Tool version: 0.1.0
# 1. 生成自签名证书 
# 2. 导出为PERM文件
# Support Platform Version: MachineDevil v0.6.0
#=========================================================================================================================

# ----------------------------------------------------------------------------------------------------------------
# 生成一个自签名证书
## 使用随机字符串
cat /dev/random > randomfile
## Generate a Private Key by following the steps below from a terminal window:
openssl genrsa -des3 -out server.key 2048
openssl genrsa -des3 -out server.key -rand randomfile
passwd: yijie
# Type the pass phrase to protect the key and press [Enter]
# Re-enter the pass phrase.
## Generate a Certificate Signing Request by following the steps below:
openssl req -new -key server.key -out server.csr
## Enter the pass phrase of the private key created in Step 1.
## Fill in the Country Name, State or Province Name, Locality Name, Organization Name, Organizational Unit Name, Common Name, Email Address.
## Note: The Common Name should be the DNS name of the server (i.e. server.mydomain.com).
## When asked for a Challenge password and optional company name, leave it blank.
##     To sign the certificate, please select from the following options:
##         (Trusted 3rd-party Certificate Authority) Send the Certificate-Signing Request (CSR) to the third party for their signing. The following files should be received:
##             Server certificate (public key)
##             Intermediate CA and/or bundles that chain to the Trusted Root CA
##         (Self-signed) Sign the certificate with openssl:
openssl x509 -req -days 730 -in server.csr -signkey server.key -out server.crt
##             Note: Increase or decrease 730 as needed. This is the number of days the certificate is valid for.
##             Enter the pass phrase of the Private Key. This is the same pass phrase that was entered in Step 1.
##     (optional) If needed, create a concatenated PEM file:
##     TID 7013103 - How to create a .pem File for SSL Certificate Installations

# ----------------------------------------------------------------------------------------------------------------
# How to create a self-signed PEM file
openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout key.pem -out cert.pem
## How to create a PEM file from existing certificate files that form a chain

##(optional) Remove the password from the Private Key by following the steps listed below:
openssl rsa -in server.key -out nopassword.key
##Note: Enter the pass phrase of the Private Key.
##Combine the private key, public certificate and any 3rd party intermediate certificate files:
cat nopassword.key > server.pem
cat server.crt >> server.pem
##Note: Repeat this step as needed for third-party certificate chain files, bundles, etc:
cat intermediate.crt >> server.pem