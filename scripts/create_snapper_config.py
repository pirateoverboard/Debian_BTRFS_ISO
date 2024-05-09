#!/usr/bin/env python3

import subprocess
import snapper_dict


for key, val in snapper_dict.subvol_dict.items():
    subprocess.run(["snapper", "-c", key, "create-config", val])
    print(f"snapper -c {key} create-config {val}")
