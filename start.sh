#!/bin/bash

# Set up SSMTP Config Files
/usr/local/bin/confd -onetime -backend env

# Export all env vars containing "_" to a file for use with cron jobs
printenv | grep \_ | sed 's/^\(.*\)$/export \1/g' | sed 's/=/=\"/g' | sed 's/$/"/g' > /root/project_env.sh
chmod +x /root/project_env.sh

# Add gitlab to hosts file
grep -q -F "$GIT_HOSTS" /etc/hosts  || echo $GIT_HOSTS >> /etc/hosts

# Clone repo to container
git clone --depth=1 -b $GIT_BRANCH $GIT_REPO /var/www/site/

# Copy in post-merge script to run npm install
cat /root/post-merge >> /var/www/site/.git/hooks/post-merge
chmod +x /var/www/site/.git/hooks/post-merge

# run node prep commands
cd /var/www/site/ && eval ${NODE_PREP}

# Add in .htpasswd if ENV VAR set
if [ $HTPASSWD ]; then echo $HTPASSWD > /var/www/site/.htpasswd ; fi
