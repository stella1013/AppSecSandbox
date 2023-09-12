#Bootstrap Jenkins installation and start  
 #!/bin/bash #specifies the interpreter
sudo yum update -y  # updates the package list and upgrades installed packages on the system
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo  #downloads the Jenkins repository configuration file and saves it to /etc/yum.repos.d/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key  #imports the GPG key for the Jenkins repository. This key is used to verify the authenticity of the Jenkins packages
sudo yum upgrade -y #  upgrades packages again, which might be necessary to ensure that any new dependencies required by Jenkins are installed
sudo dnf install java-11-amazon-corretto -y  # installs Amazon Corretto 11, which is a required dependency for Jenkins.
sudo yum install git -y
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven
sudo yum install jenkins -y  #installs Jenkins itself
sudo sed -i -e 's/Environment="JENKINS_PORT=[0-9]\+"/Environment="JENKINS_PORT=8081"/' /usr/lib/systemd/system/jenkins.service
sudo systemctl daemon-reload
sudo systemctl start jenkins
sudo systemctl status jenkins
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" 
sudo yum install unzip
sudo unzip awscliv2.zip  
sudo ./aws/install
#ZAP is isntalled at /home/ec2-user/ZAP_2.11.1/zap.sh
sudo wget https://github.com/zaproxy/zaproxy/releases/download/v2.11.1/ZAP_2_11_1_unix.sh
sudo chmod +x ZAP_2_11_1_unix.sh 
sudo ./ZAP_2_11_1_unix.sh -q
sudo tar -xvf ZAP_2.11.1_Linux.tar.gz
curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.7/2022-06-29/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
sudo cp kubectl /usr/local/bin/
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
sudo yum install docker -y
sudo usermod -aG docker $USER
sudo newgrp docker
sudo usermod -aG docker jenkins
sudo newgrp docker
sudo service jenkins restart
sudo systemctl daemon-reload
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker
sudo yum install jq -y