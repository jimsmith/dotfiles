#!/bin/sh
set +x

# Wrapper for activating awscli/ansible/devops tooling
# source this file

# Git branch in prompt.

export PS1='$(git branch &>/dev/null; if [ $? -eq 0 ]; then \
echo "\[\e[0;32m\][\u@\h \W\[\033[32m\];\n \[\e[0;35m\][$(git config --get remote.origin.url | rev | cut -d'/' -f 1 | rev)\[\e[0;33m\]:$(git branch | grep ^*|sed s/\*\ //)] \
$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; if [ "$?" -eq "0" ]; then \
echo "\[\e[0;32m\]clean"; else \
echo "\[\e[0;31m\]dirty"; fi)\[\e[0;32m\]] \$ "; else \
echo "\[\e[0;31m\][\w]\[\e[m\] \$ "; fi) \[\e[0m\]'


# conda create --yes --quiet --name awscli python=2.7 pip
# source activate awscli
# pip install --upgrade pip
# pip install ansible==2.6.3
# pip install awscli
# pip install boto
# pip install boto3
# pip install botocore
# pip install aws-adfs
# pip install pyopenssl
# pip install c7n==0.8.30.0
# pip install cfn_flip
# pip install pipenv --user

ANSIBLE_DIR=~/ansible

mkdir -p $ANSIBLE_DIR
mkdir -p ~/git_repos/

#wget --no-check-certificate https://raw.github.com/ansible/ansible/devel/contrib/inventory/ec2.py -P $ANSIBLE_DIR
#wget --no-check-certificate https://raw.github.com/ansible/ansible/devel/contrib/inventory/ec2.ini -P $ANSIBLE_DIR
#chmod 755 $ANSIBLE_DIR/ec2.py $ANSIBLE_DIR/ec2.ini
#ls -la $ANSIBLE_DIR
#cd $ANSIBLE_DIR
#sed -i=''  's/all_instances = False/all_instances = True/g' ec2.ini
#sed -i='' 's/destination_variable = public_dns_name/destination_variable = private_dns_name/g' ec2.ini
#sed -i='' 's/vpc_destination_variable = ip_address/vpc_destination_variable = private_ip_address/g' ec2.ini
#sed -i='' 's/route53 = False/route53 = True/g' ec2.ini
#sed -i='' 's/all_rds_instances = False/all_rds_instances = True/g' ec2.ini
#sed -i='' 's/include_rds_clusters = False/include_rds_clusters = True/g' ec2.ini
#sed -i='' 's/all_elasticache_replication_groups = False/all_elasticache_replication_groups = True/g' ec2.ini
#sed -i='' 's/all_elasticache_clusters = False/all_elasticache_clusters = True/g' ec2.ini
#sed -i='' 's/all_elasticache_nodes = False/all_elasticache_nodes = True/g' ec2.ini

export PATH=~/miniconda3/bin:~/miniconda3/envs/awscli/bin:~/.local/bin:$PATH


source deactivate awscli
source activate awscli

rm -f ~/.aws/credentials
unset AWS_PROFILE                                                                                                                                                                                            
unset AWS_ACCESS_KEY_ID                                                                                                                                                                                      
unset AWS_SECRET_ACCESS_KEY                                                                                                                                                                                  
unset AWS_SESSION_TOKEN 

rm -f ~/.aws/adfs_cookies
aws-adfs reset --profile=aws-adfs
aws-adfs login --adfs-host=SERVERNAME.HERE --profile=aws-adfs
export AWS_PROFILE=AWS_PROFILE_NAME_HERE
complete -C '~/.conda/envs/awscli/bin/aws_completer' aws

# Set a workaround for the High Sierra issue
# objc[34976]: +[__NSPlaceholderDate initialize] may have been in progress in another thread when fork() was called.
# objc[34976]: +[__NSPlaceholderDate initialize] may have been in progress in another thread when fork() was called. We cannot safely call it or ignore it in the fork() child process. Crashing instead. Set a breakpoint on objc_initializeAfterForkError to debug.
# by running
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

alias rm='rm -i'
alias cp='cp -i'
alias gitrepos='cd ~/git_repos/'



export ANSIBLE_INVENTORY=~/ansible/ec2.py
export EC2_INI_PATH=~/ansible/ec2.ini
export AWS_ACCESS_KEY_ID=$(aws --profile $AWS_PROFILE configure get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws --profile $AWS_PROFILE configure get aws_secret_access_key)
export AWS_SESSION_TOKEN=$(aws --profile $AWS_PROFILE configure get aws_session_token)


# sanity check
# if get error of no module boto - solution 'source deactivate awscli' then 'source activate awscli'
alias ansiblerefresh='~/ansible/ec2.py --refresh-cache'
#ansiblerefresh
#ansible -m ping "tag_Name_servername"
#ansible -m ping "tag_Name_*"
aws s3 ls
aws sts get-caller-identity
