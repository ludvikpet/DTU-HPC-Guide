We strongly recommend using [VSCode](https://code.visualstudio.com/download) to program/interact with the HPC for beginners. While it is not strictly necessary, it can speed up the process of coding significantly, and feel almost just like coding locally on your own computer. 

## Setting up the Remote - SSH extension
After you've installed and opened VSCode, navigate to the extensions pane and install the Remote - SSH extension by Microsoft:
![Remote SSH Extension](figures/remote_ssh.png "Install the Remote - SSH extension by Microsoft.")

After it is installed, press the two arrows in the bottom left corner of the editor. Choose "Connect to host" and choose gbar from the drop-down or manually add the host _login1.gbar.dtu.dk_. After entering your passphrase, a new editor will open which is a VSCode session on the cluster login node. The attached terminal works just like the terminal you would have after ssh'ing into the HPC system locally (e.g. using Windows PowerShell).

Notice how the left pane of the editor is a file explorer. Try clicking "Open folder" and pressing enter. This will make your current path the home folder of your HPC user. You may create, delete, move and copy files and folders using the file editor. You can also drag and drop local files from your computer to the file editor pane to copy files to the cluster. **Note**: you may only do this for smaller code files and folders, nothing large, as this will clog up the login node.

Now, navigate to the extensions panel and install the `Python` and `Python Debugger` extensions by Microsoft. Although you might have them installed locally, you will also need to have them installed in the HPC VSCode editor. 

If you are coding your project by yourself and you don't want to bother using git, then you may simply create a project folder, make an environment, and begin coding. If you are collaborating with someone, we advise you to set up GitHub. 

