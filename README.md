* [About](#about)
* [Quick-Start: Remote Desktop](#quick-start-remote-desktop)
* [Quick-Start: SSH Tunnel](#quick-start-ssh-tunnel)
* [Additional Information](#additional-information)
    * [Warning: ~/.Rdata and unintended persistence](#warning-rdata-and-unintended-persistence)
    * [FAQ: Address already in use](#faq-address-already-in-use)
    * [FAQ: No such file ... secure-cookie-key](#faq-no-such-file-secure-cookie-key)

## About

This single-cell environment is built on the Bioconductor 3.11 base image, with libraries such as Seurat 3, Monocle3, Signac, Tidyverse available.

This environment is provided as a Docker image, and this GitHub repository is connected to DockerHub, where [the Docker image is hosted](https://hub.docker.com/r/umichbfxcore/single_cell). A containerized environment provides each user with the same software and setup, ensuring reproducibility across users and over time.

Large memory allocations are often necessary during single-cell analysis. For this, it may be necessary to run a single-cell analysis on a remote machine. The next sections will outline how to get started using either a remote desktop session or an SSH tunnel.

## Quick-Start: Remote Desktop

If your remote machine is set up to run a remote desktop, this may be a fast and easy way to get started.

1. Connect to the remote desktop.

    If using Microsoft Remote Desktop on bfx-comp5 or bfx-comp6, you can [follow the instructions here](https://3.basecamp.com/3850040/buckets/6149755/google_documents/2638030126). There are many software solutions for remote desktop solutions. The important part is the ability to use a graphical desktop (to run RStudio).

2. On the remote desktop, open a terminal window and launch Rstudio from the singularity container:
    ```
    cd /path/to/project_dir
    module load singularity
    singularity exec docker://umichbfxcore/single_cell:0.3.1 rstudio
    ```
    Note that singularity binds your current working directory by default, so by changing to your project directory above before calling singularity, the project directory will be mounted.

    You may see a message `XDG_RUNTIME_DIR points to non-existing path '/run/user/your-user-id`. I believe this is harmless, but it's possible to prevent it by binding that directory to the singularity container:
    ```
    singularity exec -B /run/user/your-user-id docker://umichbfxcore/single_cell:0.3.1 rstudio
    ```

3. Once RStudio has started, proceed with analysis as planned. The Seurat, monocle, etc. libraries installed in the container are available for use.

4. When finished, exiting RStudio will stop the container. See [warning about persistence](#warning-rdata-and-unintended-persistence) to avoid pitfalls.

## Quick-Start: SSH Tunnel

Another option is to run the analysis remotely (e.g. on a large-memory allocation), but interact with the Rstudio session in your local web browser, via an SSH tunnel.

This can be achieved by executing rstudio-server from within the singularity container on the remote machine, and then using SSH port-forwarding to access the Rstudio session on your workstation.

This example will walk-through running the container on the remote machine `bfx-comp5.med.umich.edu`, creating the SSH tunnel, and viewing the RStudio session locally.

1. Connect to the remote machine via ssh, start a screen session for persistence, and execute rserver from the singularity container:
    ```
    ssh bfx-comp5.med.umich.edu
    # On the remote machine
    screen -S single_cell
    module load singularity
    singularity exec docker://umichbfxcore/single_cell:0.3.1 rserver
    ```

    Now rstudio is running on comp5 localhost, port 8787 (defaults)

2. Create a port-forwarding ssh tunnel. Do this from your laptop:
    ```
    ssh -N -L 8787:localhost:8787 bfx-comp5.med.umich.edu
    ```

    This creates a secure connection to 'bind' the port running rserver on the remote machine to a port on your laptop. The -L argument here has the syntax: `local-port:host:host-port`

    Note: this connection will run in the foreground, and so will occupy the terminal. This allows simpler detection of dropped connections, since errors would show up here. It's also possible to run this in the background if desired, by adding the `-f` flag to the `ssh` command.

3. From your laptop, you can access the RStudio session running on the remote machine. In your web browser, type:  

    localhost:8787

    Rstudio should appear in your web browser. Then, you will have access to all of the libraries in the single-cell environment (e.g. Seurat 3 etc.), while utilizing the compute resources of the remote machine.

## Additional Information

### Warning: ~/.Rdata and unintended persistence

One feature of RStudio which causes friction in this setup is the behavior of saving your environment to `~/.RData` while exiting.

Two things must be noted here:
1. Singularity binds the local home directory to the container by default when launching
2. Stopping the remote `singularity exec ...` command with `Ctrl-C` will end the Rstudio-server process, but first it will save the R environment to `~/.RData`.

This will result in the R environment being automatically saved into your home dir on the remote machine, and will subsequently be loaded in when a new session is started in a new container. This gives the illusion of persistence between sessions, which is an unwanted and unintended effect.

To avoid this, you should end the RStudio session via its own interface. Choosing `File -> Quit session... ` in the menu is one way to do this (works for both remote desktop or SSH tunnel configuration). Another option is to exit with the exit button (remote desktop) or power button (SSH tunnel) on the top right of the application. Any of these options will prompt you on whether to save your environment to `~/.RData` or not. I recommend saving your data deliberately in another fasion, and choosing not to save the environment.

In the case of the SSH tunnel configuration, after exiting as above you'll see in your local web browser that the R session has ended. **Then**, you can stop the `singularity exec ... rserver` command running on the remote machine with `Ctrl-C`.

### FAQ: Address already in use

If while running the `singularity exec ... rserver` command, you encounter an error which looks like the following:

    14 Apr 2020 20:48:52 [rserver] ERROR system error 98
    (Address already in use); OCCURRED AT: rstudio::core::Error
    ...

This means that the port that rserver wants to use (default 8787), is already occupied on that machine. To choose a different port, supply the `--www-port` argument to `rserver`, e.g.:

    singularity exec docker://umichbfxcore/single_cell:0.1.2 rserver --www-port 8777

You'll then set up the ssh tunnel to bind to that port e.g.

    ssh -N -L 8777:localhost:8777 bfx-comp5

### FAQ: No such file ... secure-cookie-key

If while running the `singularity exec ... rserver` command, you encounter an error which looks like the following:

    18 Aug 2020 18:14:37 [rserver] ERROR system error 2
    (No such file or directory) [path=/tmp/rstudio-server/secure-cookie-key];
    OCCURRED AT: rstudio::core::Error
    ...

This usually indicates that another user has a secure-cookie-key file in that `/tmp/rstudio-server` location on the remote machine. To choose a different location to create a `secret-cookie-key` file, supply the `--secure-cookie-key-file` argument to `rserver`, e.g.:

    singularity exec docker://umichbfxcore/single_cell:0.1.2 rserver --secure-cookie-key-file ~/secure-cookey-key-123
