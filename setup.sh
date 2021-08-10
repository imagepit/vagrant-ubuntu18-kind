# ubuntu desktop & RDP
sudo apt update -y
sudo apt upgrade -y
sudo useradd -m fullness
echo fullness:fullness1997 | sudo /usr/sbin/chpasswd
sudo gpasswd -a fullness sudo
sudo apt install -y ubuntu-desktop
sudo apt install -y xrdp
xrdp -v
sudo sed -e 's/^new_cursors=true/new_cursors=false/g' -i /etc/xrdp/xrdp.ini
sudo systemctl restart xrdp
sudo systemctl enable xrdp.service 
sudo systemctl enable xrdp-sesman.service 
systemctl list-unit-files -t service | grep xrdp
su fullness
cd ~
DESKTOP=/usr/share/ubuntu:/usr/local/share:/usr/share:/var/lib/snapd/desktop
cat <<EOF > ~/.xsessionrc
export GNOME_SHELL_SESSION_MODE=ubuntu
export XDG_CURRENT_DESKTOP=ubuntu:GNOME
export XDG_DATA_DIRS=${DESKTOP}
export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg
EOF
cat <<EOF | sudo tee /etc/polkit-1/localauthority/50-local.d/xrdp-color-manager.pkla
[Netowrkmanager]
Identity=unix-user:*
Action=org.freedesktop.color-manager.create-device
ResultAny=no
ResultInactive=no
ResultActive=yes
EOF
sudo systemctl restart polkit

# docker
echo net.bridge.bridge-nf-call-iptables = 1 >> /etc/sysctl.conf
sysctl -p
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl https://releases.rancher.com/install-docker/20.10.sh | sh
sudo usermod -g docker vagrant
sudo usermod -g docker fullness
sudo /bin/systemctl restart docker.service

# docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chown vagrant:vagrant /usr/local/bin/docker-compose
sudo chmod 775 /usr/local/bin/docker-compose

# kubectl
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# stern
curl -Lo ./stern https://github.com/wercker/stern/releases/download/1.11.0/stern_linux_amd64
chmod +x ./stern
sudo mv ./stern /usr/local/bin/stern

# kube-prompt
sudo apt install unzip
wget https://github.com/c-bata/kube-prompt/releases/download/v1.0.11/kube-prompt_v1.0.11_linux_amd64.zip
unzip kube-prompt_v1.0.11_linux_amd64.zip
chmod +x kube-prompt
sudo mv ./kube-prompt /usr/local/bin/kube-prompt
rm -f kube-prompt_v1.0.11_linux_amd64.zip

# nfs-server
sudo apt install -y nfs-kernel-server
sudo mkdir -p /var/nfs/exports
sudo chown nobody.nogroup /var/nfs/exports
echo "/var/nfs/exports *(rw,sync,fsid=0,crossmnt,no_subtree_check,insecure,all_squash)" >> /etc/exports
sudo exportfs -ra