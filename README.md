# docker-nginx
Custom Nginx Container

**Environment Variables**  
GIT_REPO - Git HTTPS URL  
GIT_BRANCH - Git branch  
GIT_HOSTS - HOSTS file entry, if needed  
NODE_PREP - Required command to tell node to build html  
HTPASSWD - populated if site should be protected by htpasswd file

**Amazon SES Information (used by ssmtp)**  
SESmailhub - SMTP Server  
SESAuthUser - AWS SES IAM User  
SESAuthPass - AWS SES IAM Password  

.htpasswd file must be in root of git repo  
website files must be in /docroot/ in git repo  
