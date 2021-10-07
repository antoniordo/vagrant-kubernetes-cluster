# kubernetes-cluster-lab

## Configure cluster
Edit `cluster-config.yml`
Set

```yaml
master:
  cpus: 2 # Number of cpu's of master node
  memory: 2048 # Master node total memory (2024 is the minimum)
  token: w7q3gm.phjqo1jqh9n6hsxx
nodes:
  cpus: 4 # Number of cpu's of regular nodes
  memory: 2048 # Nodes total memory (2024 is the minimum)
  count: 2 # Total number of created nodes
```

## How to run
```bash
vagrant up
```

Check created nodes
```bash
vagrant ssh master


```

## How to use cluster
```bash
vagrant ssh master

# Check cluster members
kubect get nodes

# Use kubectl commands:
kubectl get pod

```
