
## HOW TO RUN:

clone this repo in a local folder, navigate to that folder, then run the following command:
```
$ Rscript run_analysis.R 
```

## HOW IT WORKS

Here is a high-level description of how the analysis work:

PREPARATION PHASE:

First, the program downlads the provided dataset, then extracts the files in a `./data` folder, and then removes the temporary downloaded .zip file.

After that, it reads and stores the `feature` names to be used in the future. 

Then it prepares the data using the function `prepare_data_sets`. It reads the `training` dataset, combine its data with the `features`, and then combine it with the `activities` data

After, the same function is called to  the `test` data with the features and activities.


ANALYSIS PHASE:

(1) It takes the two datasets and merges then into one `single_dataset`.

(2) Then it selects the variables `mean` and and `std`.

(3) After, it creates a new column with the names of each activity.

(4) The appropriate descriptive names are used since the beginning, so no computations are needed here.

(5) it summarizes the data using pipes
