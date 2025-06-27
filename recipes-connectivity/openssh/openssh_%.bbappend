do_install:append() {
    echo AuthenticationMethods publickey >> ${D}${sysconfdir}/ssh/sshd_config
    echo HostKey /persistent/ssh_host_rsa_key >> ${D}${sysconfdir}/ssh/sshd_config
    echo HostKey /persistent/ssh_host_ecdsa_key >> ${D}${sysconfdir}/ssh/sshd_config
    echo HostKey /persistent/ssh_host_ed25519_key >> ${D}${sysconfdir}/ssh/sshd_config
    sed -i 's|^\(AuthorizedKeysFile\).*|\1 /boot/authorized_keys|' ${D}${sysconfdir}/ssh/sshd_config
}
