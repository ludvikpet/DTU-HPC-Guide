While, in general, it is ill advised to use Jupyter notebooks in most ML/DL tasks, they may find specific valid use cases such as for plotting or rapid prototyping. You can run jupyter notebooks directly on the HPC from interactive nodes through VSCode. To do so, use the remote ssh extension to login to a login node, open the terminal and start an interactive session. Now install the Jupyter extension in VSCode:

![The Jupyter VSCode extension](figures/VSCode_jupyter_extension.png "The Jupyter VSCode extension")

In addition, load your virtual environment and install the following packages: 
```
python -m pip install notebook ipykernel ipython
```

Now you can open/create a jupyter notebook (.ipynb) and run it on the HPC by choosing "Select kernel" in the upper right, and choosing your virtual environment. Executing cells, etc., is the same as on your local machine. 

