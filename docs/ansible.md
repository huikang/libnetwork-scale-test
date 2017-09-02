# Ansible command


### Setup emulation hosts

Edit the ansible inventory file ``./ansible/inventory/libnetwork-hosts``; add
IP address to each group.

### Check emulation environment

```bash
ansible-playbook  -i ansible/inventory/libnetwork-hosts ansible/site.yml -e action=check
```


### Deploy the emulation dnet agents on the emulation hosts

```bash
ansible-playbook  -i ansible/inventory/libnetwork-hosts ansible/site.yml -e action=deploy
```

### Clean up environment

```bash
ansible-playbook  -i ansible/inventory/libnetwork-hosts ansible/site.yml -e action=clean
```

### Test

Run [test command][test-command]

[test-command]: motivations.md#test-command
