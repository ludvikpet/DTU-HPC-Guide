In order to collaborate with peers, you're probably interested in setting up a working GitHub environment on the cluster. This allows you to push code to and from the cluster into an online repository such that you can 

1. communicate efficiently between the cluster and your local computer
2. collaborate efficiently with peers.

This process is equivalent to what you would do on your local machine. If you're unfamiliar with the process, this section acts a a GitHub setup walkthrough to get you up and running.

## Creating and using a ssh keypair for GitHub authentication
We will again use an ssh-keypair to allow the connection between your Github account and your user on the HPC system, following [this](docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) guide. 

1. Create and login to an account on github.com. 
2. `ssh` into the HPC system from a terminal or using VSCode.
3. enter `ssh-keygen -t ed25519 -C "your_email@example.com"` in the terminal. Here, the email must the same as used in GitHub.
4. Enter a passphrase which you can remember (which again should be different than the one used for your GitHub account)
5. Enter `ssh-add ~/.ssh/id_ed25519` into the terminal to add it to the ssh-agent
6. Copy the contents of the file ~/.ssh/id_ed25519.pub, e.g. using `cat ~/.ssh/id_ed25519.pub` and copying the contents to your clipboard 
7. Open GitHub in a browser.
8. Click on your profile picture
9. Click on ***Settings***
10. Click on ***SSH and GPG keys***
11. Press ***New SSH key***
12. Give the key the name "HPC", and paste the public key content from your clipboard into key field.
13. Press ***Add SSH key***

Remember, to **never share your private ssh keys** to GitHub or anywhere else. 
The process is the exact same on your own machine. If you plan on editing code locally and pushing to the HPC, it may be beneficial to setup a ssh key pair for your local machine as well.

## Creating a new repository
Creating a repository is simple, and may be done using following these steps: 

1. Create a repository in your browser on GitHub.com.
2. After creating it, click on the green ***< > Code*** button and click on ***SSH***. Copy the URL to your clipboard.̈́
!!! tip "Windows/Mac/some Linux users"
    You will need to install git on your system before executing the next steps.
1. ```ssh``` into the HPC. Using the HPC terminal, write ```git clone <your_pasted_url>``` and press enter.
2. Authenticate with your GitHub ssh passphrase.
3. Now your GitHub repository is downloaded into a project folder. ```cd``` into it.
4. Repeat steps 1-5 in a terminal on your own machine
5. Steps 7-11 should be carried out on the HPC terminal. Make a new textfile by writing ```echo "test" >> helloworld.txt```. 
6. Type ```git add helloworld.txt```
7.  Type ```git commit -m "First comission to my new repository!"```
8.   Type ```git push origin main```
9.   Authenticate with your ssh passphrase
10.  Open the repository on GitHub.com. You should be able to see that the repository contains the new file
11. On your local machine, in a terminal in the project folder, type "git pull origin main" and authenticate. This will pull new pushes to the GitHub repository down onto your local machine

While this process is nice for communicating with the HPC in an efficient manner, the real strength lies in the fact that you can invite other users to your GitHub repository on the GitHub webpage. Everyone is then able to edit, push and pull code. 

## Using the template project and pushing to your own repository
This can easily be done by following these steps: 

1. Make a completely empty GitHub repository and copy the URL as in step 2 when creating a new repository
2. `git clone <template_project_URL>`
3. Rename the folder by writing `mv HPCProjectTemplate <your_project_name>`
4. `cd` into `<your_project_name>`
5. write `git remote set-url origin <your_git_repo_URL>`. This tells git that the project should be linked to this repository instead
6. write `git push -u origin main`. This pushes all the local changes into your repository, and you may from now on use it as such. 

## Git command cheat-sheet
At its core, managing git is quite simple, only needing a small set of crucial commands that you should remember. These are:

| Command | Function |
| :------ | :------ |
| ```git add <yourfile1> <yourfile2> ... ```| Tell git that you have done changes to these files and want to push them to the repository. If instead of filenames you just write ".", it will take all files which you have changed.|
| ```git commit -m "<your_message_here>"```| Bundle your changes with a commit message. Your commit message should describe why you are pushing, what you fixed, etc.|
| ```git push origin <branch_name>``` | push your submission to the specified branch of your repository. The default branch is called main.|
| ```git pull``` | pull updates from the main branch of the repository |

Here, it is important to understand that `git add` takes a snapshot of the files as they are now. If you change the file after running `git add`, you will have to re-add it. In principle, usually you would change some files. Then you would add them in smaller comissions at a time such that each commit contains logically codependent content which may be well described with a message, and make a push for each bundle.

Many more Git commands exist, which you may find a use for. If you'd like an overview of these, we refer you to the official [GitHub command Cheat-sheet](https://git-scm.com/cheat-sheet).

## Merge conflicts 
Imagine that user A and B both pull from a repository, and both change the same line of the same file *shared_file.txt*. Now both users try to push their changes, but user A pushed before user B. The repository will then in most cases not accept the push by user B, as the push conflicts with the current contents of *shared_file.txt*. User B will then have to pull the changes first, and then will have to merge their local changes into *shared_file.txt* in a specific way such that git knows which of the changes you then want to keep. This process is called *merging*. 

Getting good at git is hard work, and is covered in other DTU courses, and many excellent online resources exist, e.g. [git - the simple guide](https://rogerdudler.github.io/git-guide/). If you are doing a larger code-heavy project with one or multiple collaborators, it is strongly advised that you learn git as it will allow you to work more efficiently in parallel. 

