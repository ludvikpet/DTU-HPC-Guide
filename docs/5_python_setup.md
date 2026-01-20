The next step is to setup the *Python* environment. Effectively, when working on the cluster, this requires us to create a personal virtual environment.

## Activating and managing a Python Virtual Environment
The cluster has a huge set of *modules*, which are software packages that are available to all users. One such type of module is `python`, which itself has a large array of different software packages available through the cluster modules. To see which modules that are currently loaded, run the following command:
```
module list
```
To list all available modules, run:
```
module avail
```
To only show `python` modules, run:
```
module avail | grep ^python
```
Here, `grep` is a search command, that allows you to filter text to only show relevant output lines. Here, `python` is the search word. The `^` character in the above query ensures that a line must start with the search word.

When running the command, you're prompted with several python versions which are available to you. Looking at the output list, you see there is a default choice, denoted by a string that ends with `(default)`. We can choose to load this module by simply running:
```
module load python3
```
If you'd like to run a specific python version, you have to specify the whole package in the above command, e.g. `module load python3/3.10.12`. 

Having loaded our desired python version, we're now ready to create a virtual environment. Run:
```
python3 -m venv <path/to/venv>
```
`path/to/venv` indicates the relative- or absolute path to where you'd like to put your virtual environment, where `venv` is the name of the environment. We recommend putting it into your project directory root and adding it into your `.gitignore`-file.

To finish up, we still need to activate the environment by running:
```
. /path/to/venv/bin/activate
```
You've now got python up and running!

When you're finished using the environment, run the command:
```
deactivate
```
to deactivate the environment.
&nbsp;
**Note:** You'll need to load all modules and activate your environment each time you're in a new terminal session.

#### Installing packages 
You may install a package in an activated virtual environment as follows: 
```python -m pip install numpy```

the packages will then be installed in your virtual environment directory. 

#### A complete example 
Examplewise, to create a python 3.10.12 environment called `dtu_hpc_intro` in your project-root called `hpc_folder`, activate it, install a pip package called `somepippackage` and followingly run a script, you would start out by issuing the following three commands in your terminal: 

```
module load python3/3.10.12
cd ~/hpc_folder 
python3 -m venv dtu_hpc_intro  
```
here, `~` indicates the user root of your directory and thus can be used no matter the current working directory. 

You can now activate the environment by writing one of the two following commands: 
```
source ~/hpc_folder/dtu_hpc_intro/bin/activate
. ~/hpc_folder/dtu_hpc_intro/bin/activate
```

in order to install your package, you now write: 
```
python -m pip install somepippackage
```

and you can now run your script: 
```
python3 src/my_python_file.py
```


## Streamlining environment activation
Whenever you want to use your virtual environment, you need to specifically **load the modules** that you used to create the environment each time. This adds a bit of unneccessary overhead, needing to e.g. remember the specific modules you run each time.

For this reason, we've added the simple script `setup_env.sh` into the GitHub repository, which streamlines the process for future uses. You can either copy this file or simply copy the contents, create a file with a similar name and paste it there. Importantly, you need to modify the file such that it fits your own needs. At a minimum, personalize the lines:
```
# Change these lines
module load python3
# ...
. /path/to/venv/bin/activate
```
You may also append other modules that you want to activate each time you enter the cluster. Lastly, you will need to update the permissions of the file, as it is currently not executable. Running the command:
```
chmod 700 path/to/setup_env.sh
```
will make the file executable for the file owner (you). To run the file, run:
```
source ./path/to/setup_env.sh
```
This one line will now do everything for you. The `source` prefix ensures, that your terminal remembers your actions post execution.

## A note on collaboration 
If you collaborate with other students, it is best practice to agree on a specific version of python to use. Even better is it if you use the completely same package versions. This may effectively be handled using a ***requirements.txt*** file for ***pip***. You can read more about this on the [official pip documentation](https://pip.pypa.io/en/stable/reference/requirements-file-format/).

## New commands encountered in this section

| Command | Function |
| :------ | :------ |
| ` module list ` | Lists all currently activated modules. |
| ` module avail ` | Lists all modules available on the cluster. |
| ` module load <m> ` | Loads module `m` on the cluster. |
| `<command1> \| <command2>` | The _pipe_ operator creates a pipeline between the standard output (stdout) of `command1` into the standard output of `command2`. |
| `grep <pattern> `| Searches input for lines that match a desired pattern and prints these lines. Often used with _pipe_ operators. |

