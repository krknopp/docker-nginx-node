#!/bin/bash

# Add gitlab to hosts file
grep -q -F "$GIT_HOSTS" /etc/hosts  || echo $GIT_HOSTS >> /etc/hosts

# Clone repo to container
git clone -b $GIT_BRANCH $GIT_REPO /var/www/site/

# Copy in post-merge script to run npm install
cat /root/post-merge >> /var/www/site/.git/hooks/post-merge
chmod +x /var/www/site/.git/hooks/post-merge

# run node prep commands
cd /var/www/site/ && eval ${NODE_PREP}

#start cron in the background
/usr/sbin/cron -f &

# Start Apache server
nginx -g "daemon off;"

