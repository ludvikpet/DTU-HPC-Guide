1. Always use strong passwords, trusted data, trusted GitHub repositories, trusted networks and trusted machines when communicating with the HPC system. Never share any private ssh keys or ip adresses. If the HPC suddenly is down due to malware/attacks, it not only hurts your project, but also everyone elses. Remember that security is your responsibility. 
2. Only use Jupyter Notebooks when it really makes your process faster. They are a common source of bugs. 
3. Make your scripts with many print-statements of e.g. tensor shapes. This sometimes allows you to know the source of errors without having to re-do the run. Even better, use a logger (we recommend `loguru`). The output will be in your output-file when running on compute nodes. You can always print the last n lines using the command: `tail -n <n> myfile.out`
4. Make naming conventions for files and functions - and stick to them
5. Modularize functions and code such that it may be re-used as much as possible.
6. Always run code from the project-root - that is, consistently invoke python scripts using ```python3 src/your_python_file.py``` and similar. This ensures that all path handling is constant across all scripts. Many (expensive) bugs occur due to path handling - e.g. saving results to a path which doesn't exist after finishing expensive operations; then you would have to re-run the whole pipeline.
7. For deep learning and machine learning algorithms using iterative optimization: save model checkpoints and optimizer state many times throughout training. If a bug occurs, you can continue from the last checkpoint and save valuable time
8. ***Always*** seed your algorithms. This ensures reproducibility and aids in interpretation of parameter-influence.
9. Use professional experimental monitoring, such as Weights & Biases. This can save a lot of time and headache. 
10. Tune your batch-scripts such that you only request the amount of resources you actually need. In busy periods, this may allow you to gain a slot quickly on the compute queue.
11. Debug your batch-scripts on an interactive node before submitting them to a queue such that you in advance know it will not fail due to shell-script bugs. 



