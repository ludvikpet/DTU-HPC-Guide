In order to use the HPC properly, you need to know what nodes are, and how to use them. 

## Node types and their uses 
The DTU cluster has four main types of nodes: *login*, *application*, *interactive* and *compute* nodes. A node is a single computer in the cluster which provides CPU, memory and potentially GPU for running tasks. Each node has a specific use-case, outlined below: 

| Type of node | Function |
| :------ | :------ |
| Login node | Handles your connection into the cluster. You always ssh into a login-node, and this is where your VSCode editor session lives |
| Application node | Designed to run software and applications available at databars |
| Interactive node | Allows you to run code directly in a terminal or jupyter notebook |
| Compute node | Only allows running code using batch-jobs. Can either be CPU only or also have a GPU |

> **Login-nodes**: In all cases, ***please never run any programs on login nodes***. They are to be used only for logging in, and running code will slow the nodes for all other HPC users. 

> **Interactive nodes** are shared between all users. This means that when running code interactively, resources allocated to your program depends on how many other users use the specific interactive node. As a result, your code may run out of memory suddenly, or have slower/faster execution based on the general workload of the interactive node. For this reason, interactive nodes are best used for debugging, running jupyter notebooks and running light code, e.g. visualizations, but not well-suited for heavy tasks such as model training, inference, 3D shape analysis, etc.
> Given this specification, you're heavily encouraged to only debug **actively**, as you may be blocking other users from using GPU resources.
> There exist interactive nodes which only have a CPU, but some nodes in addition have a GPU.

> **Compute nodes** All heavy tasks should always be run on compute nodes. 
In addition, if you're profiling code or report run-times of code in your work, the only proper way to measure it is to use compute nodes. The batch job you submit will allocate a specific amount of system resources for your program, and thus runtimes will not be influenced by general system use.
In general, when you can use a compute node then you should, as this is the use which HPC is optimized for. Again, these nodes exist in CPU-only and GPU versions.  
Available GPU nodes (compute and interactive) are listed [here](https://www.hpc.dtu.dk/?page_id=2759). The next two subsections show how to use interactive and compute nodes.  

> **Application nodes** Are designed to run software and applications interactively, and are not relevant for this guide. 

## Running a python script on an interactive GPU node
Assume you have a file ***file.py*** on the HPC cluster. Then you can run the file interactively by following these steps: 

1. ssh into the cluster
2. change from a login session to an interactive session by entering a queue name into the terminal and pressing enter
3. load your python virtual environment
4. executing the code from the terminal by writing ```python3 path/to/your/file.py```

Currently available interactive GPU queues are `sxm2sh`, `voltash` and `a100sh`. To start an interactive session, simply enter the node ID, e.g. ```voltash```, in the terminal and press enter. You can log out from a node by running the ```exit``` command.

In order to check the current workload of an interactive node, you can start a session on the node and enter ```nvidia-smi```. This will provide terminal output similar to the below: 


```
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI (some version)  Driver Version: (some version)  CUDA Version: (some version) |
+-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  Titan X-PCIE-16GB              On  |  <PCI Bus ID 0>        |                    0 |
| N/A   46C    P0             47W /  250W |    6468MiB /  16384MiB |      0%      Default |
|                                         |                        |                  N/A |
+-----------------------------------------+------------------------+----------------------+
|   1  Titan X-PCIE-16GB              On  |  <PCI Bus ID 1>        |                    0 |
| N/A   29C    P0             25W /  250W |       4MiB /  16384MiB |      0%      Default |
|                                         |                        |                  N/A |
+-----------------------------------------+------------------------+----------------------+

+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
|        ID   ID                                                               Usage      |
|=========================================================================================|
|    0   N/A  N/A    <process ID>      C   ...some/path                           6152MiB |
|    0   N/A  N/A    <process ID>      C   ...some/path                            310MiB |
+-----------------------------------------------------------------------------------------+

```
Here, some information from the output has been redacted for security. 
??? tip "output interpretation"
    The key outputs of interest to you are mainly the GPU statistics. In this case above, we see the node has two GPUs, each of the type Titan X. Each is connected using PCIE, and has 16GB of memory. 
    The GPU with ID 0 is currently running at 47 watts with a temperature of 46 degrees celsius, and is currently using 6468MiB/16384MiB of memory, and thus potentially has resources for your job. Similarly, GPU 1 is unused. 
    In this case, if you were to run a script, you should run it on GPU 1, because else you may crash or slow down the large process running on GPU 0. If you already know memory requirements of your script, ensure that there actually is space for it on the GPU, as your job else will crash and you may crash others scripts as well. 
    **Please always favor to run on unoccupied GPUs in order to not disturb other users**.  
    
    In order to bind to a specific GPU in an interactive job, you will need to specify the CUDA device in pytorch, e.g.: 
    
    ```
    a = torch.Tensor([1,2,3]).to(torch.device('cuda:1'))
    ```
    
    Our provided script _run-file.sh_ sets CUDA_VISIBLE_DEVICES such that cuda:0 corresponds to the GPU with the most available free memory, and thus when using this you just need to do:
    
    ``` 
    a = torch.Tensor([1,2,3]).to("cuda")
    ```

    In specific cases, the CUDA version may be important for you to download the correct version of pytorch.  



## Running a script on a compute node
In order to run a script on a compute node, a *batch-script* is needed to tell the HPC system how many resources your program will take up. Basically, a batch-script can be understood as you placing an order on the HPC node. When placing the order, you create a *batch-job* which will be put in a queue. The scheduling system on the HPC then starts your script as soon as it is your turn in the queue, and the required resources are available. 


#### The batch script 
A batch script consists of a combination of batch-job code and bash code, and it should be saved with the file-extension `your_batch_filename.sh`. An example of a batch-script is provided below: 
```
#!/bin/sh
### The following section is the batch-job specific content which places your "order" 
### –- specify queue where you want to run your job --
#BSUB -q gpuv100
### -- set the job name: this is used for monitoring your job later --
#BSUB -J testjob
### -- ask for number of CPU cores (in most cases just leave it as 4) --
#BSUB -n 4
### -- Select 1 gpu in exclusive process mode (in most cases leave it as is) --
#BSUB -gpu "num=1:mode=exclusive_process"
### -- set walltime limit: hh:mm --  maximum 24 hours for GPU-queues. Your job is killed if it exceeds.
#BSUB -W 1:00
### request 5GB of GPU-memory
#BSUB -R "rusage[mem=5GB]"
### set the job to run on a single host machine (don't change this)
#BSUB -R "span[hosts=1]"
### -- set an email address - a mail will be sent with some important statistics about your job and whether it succeeded/failed --
#BSUB -u your_email_address
### -- send e-mail notification when job starts -- 
#BSUB -B
### -- send e-mail notification when job ends with statistics/status --
#BSUB -N
### -- Specify the file to which all your terminal output (e.g. print statements) are saved to
### -- %J will here give it the JobID number which the scheduler assigns when submitting. 
#BSUB -o logs/gpu_%J.out
### -- Specify the file to which all errors are saved to. Important for debugging if it crashes!
#BSUB -e gpu_%J.err

### -- end of batch job options - from here it is just shell code --
module load python3/3.10.12
source path/to/your/environment
echo "Training model..."
start=$(date +%s) #example timer start
python3 src/train_model.py  #train your model
stop=$(date '+%s') #stop the timer to time how long it took
elapsed=$(awk "BEGIN {print $stop - $start}")
echo "training finished in $elapsed seconds" #print how long it took
echo "Running inference"
python3 src/model_inference.py
echo "Plotting results..."
python3 src/some_result_plots.py
echo "Finished all scripts. "
```

The shell code is then executed as soon as it is your turn in the queue. 

Here, you may consider the shell code as simply being the same as interacting with the terminal line by line. As a result, you can stack a series of commands as done above which trains a model, followingly runs inference and plots some results while also timing how long model training takes and printing something to the output. 

Note that both `echo` (which is linux for print) and python script terminal outputs will be redirected to the `logs/gpu_%J.out` file instead of a terminal which you can see as it runs.


#### Submitting and handling a batch job
In order to submit the job, enter the following in a terminal: 
```bsub < your_batch_filename.sh```

Your job will then receive a job ID. You can see whether your job is running using ```bstat```. 
You may always kill a job using ```bkill <jobID number>```.

??? tip "Debugging a batch-script by running as a shell-script"
    You may check that your batch script works by changing the permissions of the file to be executable by you:

    ```
    chmod 700 mybatchscript.sh
    ```

    And execute it in an interactive session using:

    ```
    ./mybatchscript.sh
    ```
    
    which will run the shell-script contents but not submit to the queue when invoked in this way. When you're sure it works, press Ctrl and C to cancel execution, and then submit it to the queue using 

    ```
    bsub < mybatchscript.sh 
    ```

#### Checking node business 
You can check how busy different compute nodes are using the ```bqueues``` command. Here, the ```PEND``` column shows how many jobs are currently in queue. If you want to check a specific queue, in this case `gpua100`, you may write: 
```bqueues | grep gpua100```
to only get the corresponding line.
Available compute nodes with GPUs are listed [here](https://www.hpc.dtu.dk/?page_id=2759). 

## New commands in this section
Reviewed commands:

| Command | Function |
| :------ | :------ |
| ``` nvidia-smi ``` | Lists interactive node information over the current active node. |
| ``` bstat ``` | Lists information of your current batch jobs. |
| ``` bqueues ``` | Lists activity of all compute nodes on cluster. |


