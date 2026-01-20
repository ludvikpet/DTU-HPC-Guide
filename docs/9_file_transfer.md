You'll likely want to transfer files between your local computer and the cluster at some point. This should never be done using login, interactive or compute nodes. The HPC has transfer server, which is designed for doing this at high speed.

**Important**: Please ensure that you only copy data from trusted sources to the DTU server, i.e. datasets provided by your project supervisor or original download links which are associated with peer-reviewed papers from trusted journals, as you may else infect the DTU HPC. 

## **local &rarr; remote**
This can be done using the following command on a local terminal:
```
scp -r path/to/local/data <study-number>@transfer.gbar.dtu.dk:/path/to/your/project
```
Here, *scp* (secure copy) copies the file contents from your machine onto the remote location you've specified. The tag *-r* allows a *recursive* copy, meaning a directory may be copied in its entirety onto the cluster. Importantly, you need to specify the absolute path to the project on the server.


## **remote &rarr; local**
This can either be done in a similar way by using a local terminal the opposite way round:
```
scp -r <study-number>@transfer.gbar.dtu.dk:/path/to/your/project/data path/to/local/destination
```
For small files, you may also employ a simpler method. In VS Code, right click the file you want to retrieve from the remote. Here, you'll see a *download* option - this will download the file onto your local machine. This, however, should **never** be done for larger files, as this slows down login nodes for all users.

## **kaggle &rarr; remote**
If you want to download a dataset from ***kaggle***, e.g. with the URL https://www.kaggle.com/datasets/welovehpc/satellite-images, you may `cd` into your project root, `cd` into a data folder, and then use the command 
```
curl -L -o data.zip
  https://www.kaggle.com/api/v1/datasets/download/welovehpc/satellite-images
```

This will allow you to download directly on the HPC server. Please only do this on interactive nodes.
## **Some filesharing service &rarr; remote**
The `curl` approach is also useful if you have a download link for an arbitrary filesharing service, and you do not have space to download the dataset onto your own machine; here you would simply curl the download link. This usually works for filesharing services where you are able to get the URL of the file, usually by right-clicking the download button and copying the URL. This, of course, only works for archived files, e.g. *zip*, and similar:

```
curl wetransfer.com/some_dataset.zip
```

This works on *google drive* and some other arbitrary file sharing services.



## Storage 
Each student has a default storage limit of 30GB on the HPC. For bachelor's or master's projects where higher capacity is necessary, write a request for more storage to the HPC staff in due time.



## A complete step-by-step example 
Assume you have a `zip`-file located in the path ***/home/max/Documents/DTU/my_cool_dataset.zip***, which will unzip into the structure: 
```
my_cool_dataset.zip
└── data
    ├── file_1_image.npy
    ├── file_1_label.npy
    ├── file_2_image.npy
    ├── file_2_label.npy
    ├── ...
└── splits
    ├── train_idx.txt
    ├── val_idx.txt
    ├── test_idx.txt    
```


You want to copy this file to the HPC into your project root directory which is called ***mycoolproject***, and your student number is `s123456`. 

Your goal is to achieve the following file-structure for your project: 

```
mycoolproject
└── data
    └── raw_images
        ├── 1.npy
        ├── ...
    └── raw_labels
        ├── 1.npy
        ├── ... 
    └── processed_images
        ├── 1.npy
        ├── ...
    └── processed_labels
        ├── 1.txt
        ├── ... 
    └── splits
        ├── train.txt
        ├── val.txt
        ├── test.txt    
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
    ├── preprocess.py
    ├── ...
├── README.md
```

so you start out by logging into the HPC from a terminal: 
```
ssh s123456@login1.gbar.dtu.dk
```

then change your working directory to your project root: 

```
cd mycoolproject
```

check whether you already have a data folder: 

```
ls
```

if no data-folder is present, you make one: 

```
mkdir data
```

and `cd` into it: 

```
cd data
```


and copy the terminal heading which should say something along the lines of: 
```
~/mycoolproject/data
```

Copy this. We need it for the `scp` transfer target. 
??? tip "Blackhole folders"
    This is only relevant if you have requested more storage from HPC staff. In this case, it will often be located in a blackhole folder, which is not directly accessible using the tilde-operator, as it lies on a different file-system. In this case, you will have to cd into the blackhole path, make the directories you need, and finally copy the complete path. You can print the complete path using the `pwd`-command. 

Now, on your local machine, open up a terminal. Now, we will copy the `.zip`-file by writing: 

```
scp -i ~/.ssh/gbar /home/max/Documents/DTU/my_cool_dataset.zip s123456@transfer.gbar.dtu.dk:~/mycoolproject/data/
```

and verify using our credentials. Now `ls` on the ssh-connection. You should see the folder now contains `my_cool_dataset.zip`-file being present in your directory. 

Now, we will unzip it using: 
```
unzip my_cool_dataset.zip
```



which will create a folder called ***my_cool_dataset***. First, let's handle the `splits` folder. We move it up one to the current path depth using `mv`: 
```
mv my_cool_dataset/splits .
```

which means "move the complete folder ***my_cool_dataset/splits*** to where I currently am". We will need to rename all the files to fit our directory structure goal. thiss can be done using `mv`:

```
mv splits/train_idx.txt splits/train.txt
mv splits/val_idx.txt splits/val.txt
mv splits/test_idx.txt splits/test.txt
```

Next, make the raw-directories for the labels and the images in your ***data***-directory using `mkdir`. 

We can also use the `mv` command using wild-card expressions. Let's do so to seperate images from labels: 
```
mv my_cool_dataset/data/*_image.npy raw_images/*_image.npy
```
and the labels: 
```
mv my_cool_dataset/data/*_label.npy raw_labels/*_label.npy
``` 

??? tip "Renaming many files using `rename` and a shell wildcard"
    You can rename many files in a directory using the `rename` command.
    On the HPC, the syntax is:

    ```
    rename 'string_to_match' 'replacement_string' target_files
    ```

    For example, to strip filename clutter from image files:

    ```
    rename 'file_' '' *.npy
    rename '_image' '' *.npy
    ```

    This performs a literal string replacement on each filename.

    Adding the `-v` flag makes `rename` verbose and prints each rename operation.


Now we've extracted all contents of the dataset, and can remove it safely using: 
```
rm -r my_cool_dataset
```

and 
```
rm my_cool_dataset.zip
```

??? tip "Tip"
    Unless your dataset is very large, we recommend keeping the .zip of the dataset saved somewhere on the HPC, such that you do not have to re-transfer the dataset if you accidentally delete it. 





