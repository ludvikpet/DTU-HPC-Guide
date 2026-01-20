Having gained access to the cluster and setup GitHub, we would now like to create a project folder. This can be done as you'd usually do on Visual Studio Code using the editor's file explorer, or by using the `mkdir` command in the terminal.

## Project structure 
The structure of the given folder is not pivotal, however, we highly recommend using the structure provided in [our GitHub repository](https://github.com/ludvikpet/DTU-HPC-Tutorial). This will save you a lot of trouble later on when e.g. debugging. We also include some relevant files, which will come in handy later on. You can simply clone this repository or copy the contents into your project folder. The outline of our repository is found below:
```
└── data
    ├── data_file1.npy
    ├── ...
└── logs
    ├── log-1.txt
    ├── ...
└── outputs
    ├── out.txt
    ├── ...
└── scripts
    ├── add_debug_machine.sh
    ├── run_file.sh
    ├── setup_env.sh
    ├── ...
└── src
    ├── main.py
    ├── ...
├── README.md
```
Here, the ***src*** directory is intended for your `python` files, ***scripts*** holds all shell script files, ***logs*** holds all your logs for your batch jobs, ***outputs*** holds all logs when running in an interactive node session and ***data*** holds all your data files.

When invoking any of the scripts, always call them from the project root folder, i.e. run main.py by writing ```python3 src/main.py``` - this consistency will save you a lot of time in the long run, as wrong path structure is a huge source of bugs. 

## Opening the project in VSCode 
Having created our project directory, we'd now like to step into it with our VS Code editor. This will make life a lot easier in the future. To do so, we first step into the folder using the terminal. Open a terminal and `cd` into your project directory. Once at the project root, we run the command:
```
pwd
```
`pwd`, or **p**rint **w**orking **d**irectory, does as the name suggests. Having run the command, now copy the console output.

Now in your editor, navigate to *File &rarr; Open Folder*, which will display a file explorer at the top of your screen. Paste the path to your project directory here and click *OK*; your editor is now located at your project root!

For future reference, this navigation is made much easier each time you connect to the server - just append the extra path elements onto the path string that you're prompted with initially.
