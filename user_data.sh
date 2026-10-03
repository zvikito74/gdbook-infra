#!/bin/bash
# First-boot script: installs Nginx and puts a placeholder page in place.
# The real site is deployed afterwards (see README).
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y nginx

cat > /var/www/html/index.html <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head><meta charset="utf-8"><title>GDBook</title></head>
<body><h1>GDBook server is up</h1><p>Provisioned with Terraform.</p></body>
</html>
EOF

systemctl enable --now nginx
