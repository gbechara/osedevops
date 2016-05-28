#!/bin/bash

set -e

docker exec -i gitlab /bin/bash <<'EOF'
  gitlab-rails console production
  user = User.where(id: 1).first
  user.password = 'weareawesome'
  user.password_confirmation = 'weareawesome'
  user.save!
  exit
EOF