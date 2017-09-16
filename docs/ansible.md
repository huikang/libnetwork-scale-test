# Ansible command


## Setup emulation hosts with dnet

Edit the ansible inventory file ``./ansible/inventory/libnetwork-hosts``; add
IP address to each group.

**Check emulation environment**

```bash
ansible-playbook  -i ./inventory/libnetwork-hosts site.yml -e action=check
```


**Deploy the emulation dnet agents on the emulation hosts**

```bash
ansible-playbook  -i ./inventory/libnetwork-hosts site.yml -e action=deploy
```

**Clean up environment**

```bash
ansible-playbook  -i ./inventory/libnetwork-hosts site.yml -e action=clean
```

### Test

Run [test command][test-command]

[test-command]: motivations.md#test-command

## Setup emulation hosts with swarmkit

**Deploy the emulation swarmket nodes on the emulation hosts**

```bash
ansible-playbook  -i ./inventory/libnetwork-hosts site.yml -e libnetwork_install_type=swarmkit -e action=deploy
```

**Clean up environment**

```bash
ansible-playbook  -i ./inventory/libnetwork-hosts site.yml -e libnetwork_install_type=swarmkit -e action=clean
```

## Ansible Variables

| Variable name | Used for | Default value | Choices |
|------------------------:|----------------------------------|---------------|----------------|
| libnetwork_install_type | how libnetwork runs in emulation | dnet | dnet, swarmkit |
| number_emulated_agents | emulation size | 2 | Integer |

In order to override, one should use the `-e ` runtime flags (most simple way) with the ansible-play command.
