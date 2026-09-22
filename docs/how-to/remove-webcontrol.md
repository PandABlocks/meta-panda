# Removing the panda-webcontrol package

Removing packages follows the same two methods as installing
packages - Through the web interface or through the shell on the panda: [](packages.md).

If you are trying to remove the panda-webcontrol package, it might be best to use SSH to remove it, but both methods are provided for convenience:

## Removing the panda-webcontrol package through the webcontrol

:::{warning}
Ensure your ssh keys are already on the panda before proceeding, as you will
lose access to the web interface for control. Follow [*How do I authorise a public SSH key?*](/reference/troubleshooting.md)
:::

1. Insert a USB stick into the PandA.
2. Open the web admin interface at `http://<panda-hostname>/admin/`.
3. Navigate to **Packages → List Installed Packages**.
4. Select the **panda-webcontrol** package.
5. Click on **delete selected packages** .

## Removing the panda-webcontrol package through ssh 
1. ssh into the PandA using
    ```bash
    ssh root@<panda-hostname>
    ```
2. Remove the webcontrol package using the opkg tool
    ```bash
    opkg remove panda-webcontrol
    ```

Following either method will remove the webcontrol package from your PandA.