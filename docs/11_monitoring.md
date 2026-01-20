When training Deep Learning models, it is necessary to keep track of their behaviour. Which model parameters did I choose? Did the model converge correctly? Does the output of the model seem to generalize well to the underlying data? 

For a single model, this is not so difficult to monitor. Generally, however, you'd like to tweak your model in order to optimize performance. Tracking the nuances of each run can become very difficult in practice, which makes it difficult to manage e.g. the reproducibility of a previously successful experiment.

For this, your friend and ally is _Weights & Biases_, also known as wandb. This framework is intended to streamline monitoring by broadcasting all your experiments onto your personal page on _wandb.ai_ . To use the framework, you'll need to register to wandb - navigate to the [wandb](https://wandb.ai/site) home page and sign up.

Broadly, wandb allows you to create sub-folders for your experiments (neat if only a subset is coupled), upload plots and histograms, create sub-sections for your train-val-test splits, upload images, files and much more. Many of these features can also be made temporal, i.e. for a given model, its output at epochs 10 and 100 can easily and intuitively be compared to each other. More advanced tools are also available such as model _sweeps_, which automate hyperparameter search whilst producing rich visualizations, simplifying parameter tuning significantly in some instances.

As Weights & Biases themselves have a perfectly fine guide, we direct you to the following site for further guidance: [Wandb guide](https://docs.wandb.ai/models/quickstart#command-line).

