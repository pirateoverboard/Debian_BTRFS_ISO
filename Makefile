SHELL_SCRIPTS := build_debian build_udeb scripts/build_btrfs_subvols scripts/create_snapper_config.sh scripts/dpkg-pre-post-snapper.sh scripts/fix_home.sh scripts/install_btrfs_udeb scripts/install_snapper_grub-btrfs scripts/run_late_setup scripts/setup_snapper_config.sh

.PHONY: lint shellcheck shfmt-check

lint: shellcheck shfmt-check

shellcheck:
	shellcheck $(SHELL_SCRIPTS)

shfmt-check:
	shfmt -i 4 -ci $(SHELL_SCRIPTS) >/dev/null
