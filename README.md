# kindによるk8sクラスタ用のVagrantfile

## 構築する環境

- ubuntu18
- docker
- kind

## 構築に必要なもの

- vagrant 2.2.18以上
- Virtualbox 6.1.26以上

## 使い方

### Docker/Kubernetes環境の構築

```
git clone https://github.com/imagepit/vagrant-ubuntu18-kind.git
cd vagrant-ubuntu18-kind
vagrant up
```

### Docker/Kubernetesの動作確認

```
vagrant ssh
docker version
kubectl get nodes
```