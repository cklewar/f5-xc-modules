locals {
  ssh_trusted_user_ca = join(
    "\n",
    [var.ssh_trusted_user_ca_map[var.ves_env]],
    [var.ssh_trusted_user_lockout_ca],
  )
}