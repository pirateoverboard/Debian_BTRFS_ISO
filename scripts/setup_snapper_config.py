#!/usr/bin/env python3

import subprocess
import snapper_dict


options_list = ["TIMELINE_CREATE=no",
                "ALLOW_GROUPS=sudo",
                "SYNC_ACL=yes",
                "NUMBER_LIMIT=10",
                "NUMBER_LIMIT_IMPORTANT=10"]


for key, val in snapper_dict.subvol_dict.items():
    for i in options_list:
        subprocess.run(['snapper', '-c', key, 'set-config', i])
        print(f"snapper -c {key} set-config {i}")
