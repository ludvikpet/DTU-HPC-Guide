The cluster is accessed using *ssh*. *ssh* is an abbreviation for *secure shell*, a network protocol which allows two computers to communicate through a network tunnel. In order to be able to access the cluster using *ssh*, your computer needs to authenticate itself to the HPC, such that the HPC machine knows that you are, indeed, you. 

This authentication is either achieved by being logged onto a DTU WIFI network, the [DTU VPN](https://www.hpc.dtu.dk/?page_id=5685) or by using a private and public ssh key pair. 

## Prerequisites 
You may only connect to DTU systems via machines that you trust, i.e. you have no malware infections. This **also** means that your OS and other software still has to receive regular updates and are updated to newest versions, as they else may not be secure. 

## Using the DTU VPN
If you only need to use the cluster for a couple of days, using the [DTU VPN](https://www.hpc.dtu.dk/?page_id=5685) is fine, and it simplifies setup significantly. 

In this case, start and connect to the VPN service, and subsequently open a terminal and write: 

```
ssh s123456@login1.gbar.dtu.dk
```

press enter `↵`, and enter the DTU password you always use to login into DTU services. Now move to the other sections of the tutorial. 


??? tip "Windows users"
    You will need to use a terminal which supports ssh. We recommend Windows PowerShell but you can also use Windows Terminal.
    In this guide, all commands are provided as Linux commands, and most work the same in PowerShell. 

**Note:** you will need to keep the VPN connection open to stay connected. 


## Using a ssh keypair
If you're doing a longer project, setting up the ssh key pair is the best approach. To do so, open a terminal and make a directory called `.ssh` in your home root by entering the following in the terminal: 
```
mkdir -p ~/.ssh
```

Here, `-p` is a flag to the command which allows parent folder creation, and does not give an error if the folder already exists. Now change the working directory to the newly created directory issuing: 

```
cd .ssh 
```

and pressing enter `↵`. `cd` stands for "**c**hange **d**irectory". Now it's time to generate the public and private ssh key pair. Enter the following command in your terminal: 
```
ssh-keygen -t ed25519 -f gbar
```

and press enter `↵`. 
Now, you must enter a passphrase. This passphrase needs to be secure and secret, and ***cannot*** be the same passphrase which you use for your DTU login. Note that you cannot directly see in the terminal how many characters you have written, so take care. 

This will create two files in your .ssh-directory: `gbar` and `gbar.pub`. Check this by entering 
```
ls -la
```
in your terminal. This lists all files and folders in the current working directory; `ls` is short for **list**. Check that the two files are present in the output. 

**Important**: The `gbar` file is your private file and may in **no way be shared** to any online service, as this would could allow adversaries to connect to the HPC services using your identity. 

The next step is to copy the content of the public key `gbar.pub` to the HPC server. 
Then, the HPC will accept an incoming connection from your PC. 

To do so, connect to the [DTU VPN](https://www.hpc.dtu.dk/?page_id=5685) or connect to an on-premise DTU Wi-Fi network. Then ssh into the HPC service using a terminal and entering:

```
ssh s123456@login1.gbar.dtu.dk
```

and authorizing with your normal DTU password. It will ask you whether you want to accept the connection for a specific fingerprint. Check that the fingerprint matches the one [provided here](https://www.hpc.dtu.dk/fp.txt) and **else decline** as someone may be trying to attack your connection, and the network connection is not trustworthy! If they match, continue.  


Once on the server, make a .ssh folder using the following command:
```
mkdir -m 700 -p ~/.ssh
```

here, `-m` is a flag which sets the mode of the folder as being only accessible by the owner (you) and the root (HPC admin). External adversaries will therefore not be able to access the folder contents. 

cd into the directory, then write:
```
cat >> authorized_keys
``` 
and paste the complete contents of your *gbar.pub* file into the terminal and press enter `↵`. This appends a new line to the file *authorized_keys*. Then close the file by pressing enter `↵` followed by `ctrl` + `d`.

This file tells the system to accept incoming connections from your user on your machine. Finally, the permissions of the file need to be set to "600", which can be modified using the following command: 
```
chmod 600 authorized_keys
```

which is an abbreviation for **ch**ange **mod**e. You will also need to use this command for making scripts executable, etc.

Now, you should be able to connect without the VPN active and from any network. 
Please remember still to be cautious and only login from networks which you know you can trust.  

If you want to simplify the login procedure further, you can create a file in your local `.ssh` directory called `config`  and insert the following information in it: 
```
Host gbar
User s123456
IdentityFile ~/.ssh/gbar
Hostname login1.gbar.dtu.dk
```
Note, that you need to change the User line to fit with your own student number or DTU username. Using this, you can simply run `ssh gbar` in your terminal to connect.

## New commands in this section
In this section the following commands have been used:

| Command | Function |
| :------ | :------ |
| `mkdir <new_folder_name>` | create a new directory |
| `cd <sub-directory>` | Change working directory.<br> Go back one level with `cd ..` |
| `ls -la` | List contents of a directory.<br> `-la` shows all files, including hidden ones |
| `chmod <permission-code> <your_file>` | Change file permissions |
| `cat >> <some_file>` | Append a line to `some_file`.<br> Creates the file if it does not exist |
| `cat <some_file>` | Print file contents |
| `ssh <user-id>@<host-server>` | Establish a secure shell connection<br> from local machine to host server |

