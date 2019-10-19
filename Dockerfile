ARG DistroVersion=7.5

#Base image
FROM registry.access.redhat.com/rhel:${DistroVersion}
# The author
MAINTAINER LoZ Open Source Ecosystem (https://www.ibm.com/developerworks/community/groups/community/lozopensource)
RUN subscription-manager register --username=ibm_rhn --password='k1ng_pengu1ns' &&\
    subscription-manager attach --auto
# Install Dependencies
RUN buildDeps="git" && \
        runDeps="openssh-server \
                        ca-certificates && \
                        sudo && \
                        java-1.8.0-openjdk.s390x"&& \
                        yum install -y  $buildDeps $runDeps && \
# Create sshd directory
 mkdir /var/run/sshd && \
# Set Credentials
echo 'root:password' | chpasswd && \
sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
# SSH login fix. Otherwise user is kicked off after login
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
export NOTVISIBLE="in users profile" && \
echo "export VISIBLE=now" >> /etc/profile && \
        rm -rf /etc/ssh/ssh_host_rsa_key && \
    rm -rf /etc/ssh/ssh_host_dsa_key && \
    rm -rf /etc/ssh/ssh_host_ecdsa_key && \
# Generate Keys
        ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -A
# Expose Port
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
