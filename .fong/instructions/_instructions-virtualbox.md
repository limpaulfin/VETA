@DEPRECIATED

# VirtualBox VM Instructions

## VM Configuration Files

### Windows 11
- **File**: `/home/fong/Projects/ubuntu-lenovo-t14/windows-11/windows-11.json`
- **VM Name**: Windows-11
- **OS**: Windows 11 IoT Enterprise 24H2 x64
- **Quick Start**: `./start-win11.sh`
- **SSH Access**: `./ssh-to-win11.sh`
- **WinRM Access**: `./scripts/winrm-exec.py`

### Kali Linux
- **File**: `/home/fong/Projects/ubuntu-lenovo-t14/kali-linux/vm-Kali-Linux-2025-virtualbox-ssh.json`
- **VM Name**: Kali-Linux-2025.3
- **OS**: Kali GNU/Linux 2025.3
- **Quick Start**: `VBoxManage startvm 'Kali-Linux-2025.3'`
- **SSH Access**: `ssh -p 2222 xxx@localhost`
