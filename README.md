# Single-cell environment

This single-cell environment is built on the Bioconductor 3.10 base image, with the addition of Seurat 3 and other libraries useful in single-cell analyses. 

This environment is provided as a Docker image, and this GitHub repository is connected to DockerHub, where [the Docker image is hosted](https://hub.docker.com/r/umichbfxcore/single_cell). 

## Using this environment
This environment ensures reproducibility across single-cell analyses, and it also allows a particularly valuable use-case: the ability to run the analysis remotely (e.g. on a large-memory allocation), and interact with the Rstudio session locally in your web browser. 

This can be achieved by executing rstudio-server from within the singularity container on the remote machine, and then using SSH port-forwarding to access the Rstudio session on your workstation.

This example will walk-through running the container on bfx-comp5 (also works on bfx-comp6), creating the SSH tunnel, and viewing the Rstudio session locally.

On comp5, start a screen session for persistence, and execute rserver from the singularity container:

    screen -S single_cell
    module load singularity/3.5.2
    singularity exec docker://umichbfxcore/single_cell:0.1.2 rserver

Now rstudio is running on comp5 localhost, port 8787 (defaults)

The next step is to create a port-forwarding ssh tunnel. I'll do this from my MacBook (note I have an alias set up, `bfx-comp5` maps to `bfx-comp5.med.umich.edu`). 

    ssh -N -L 8787:localhost:8787 bfx-comp5

This creates a secure connection to 'bind' the port running rserver on comp5/6 to a port on your MacBook. The -L argument here has the syntax: `local-port:host:host-port`

<details><summary>Note: runs in foreground - expand to read more</summary>

This connection will run in the foreground, and so will occupy the terminal. This allows simpler detection of dropped connections, since errors would show up here. It's also possible to run this in the background if desired, by adding the `-f` flag to the `ssh` command.
</details>

Now from your macbook, you can access the rstudio session running on comp5. In your web browser, type:  

    localhost:8787  
  
Rstudio should appear in your web browser. Then, you will have access to all of the libraries in the single-cell environment (e.g. Seurat 3 etc.), while utilizing the compute resources of bfx-comp5.

### Important note about ~/.RData, and terminating sessions

One feature of RStudio which causes friction in this setup is the behavior of saving your environment to `~/.RData` while exiting. 

Two things must be noted here: 
1. Singularity binds the local home directory to the container by default when launching
2. Stopping the `singularity exec ... rserver` command with `Ctrl-C` will end the Rstudio-server process, but first it will save the R environment to `~/.RData`.

This will result in the R environment being automatically saved into your home dir on comp5/comp6, and will subsequently be loaded in when a new session is started in a new container. This gives the illusion of persistence between sessions, which is an unwanted and unintended effect. 

To avoid this, you should end the RStudio session from the web browser, either with the power button on top right, or by choosing `File -> Quit session... ` in the menu. Either of these options will prompt you on whether to save your environment to ~/.RData or not. Choose not to save the environment, and you'll see in your browser that the R session has ended. **Then**, you can stop the `singularity exec ... rserver` command with `Ctrl-C`.

### Note about 'Address already in use' error

If while running the `singularity exec ... rserver` command, you encounter an error which looks like: 

    14 Apr 2020 20:48:52 [rserver] ERROR system error 98
    (Address already in use); OCCURRED AT:
    rstudio::core::Error
    ...

That means that the port that rserver wants to use (default 8787), is already occupied on that machine. To choose a different port, supply the `--www-port` argument to `rserver`, e.g.

    singularity exec docker://umichbfxcore/single_cell:0.1.2 rserver --www-port 8777

You'll then set up the ssh tunnel to bind to that port e.g. 

    ssh -N -L 8777:localhost:8777 bfx-comp5
