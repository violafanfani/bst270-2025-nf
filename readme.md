# bst270-2025-nf

![](https://github.com/violafanfani/bst270-2025-nf/workflows/build/badge.svg)

Example of nextflow with midus project.
This workflow is built using the reproducibility group project
of the BST270 students, during Winter Session 2025. 

## Configuration

  
  `biomarker_data`: biomarker MIDUS rda file

  `optimism_data`: optimism MIDUS rda file

  `resultsDir`: main output figure, inside it you'll find the figure and table folders

  `tertiles = [[10,20],[23,26],[0,0]]` tertiles for table 1

## Running the workflow

### Install or update the workflow

```bash
nextflow pull violafanfani/bst270-2025-nf
```

### Run the analysis

```bash
nextflow run violafanfani/bst270-2025-nf
```

## Docker

We provide a docker container that allows to run the whole workflow in one go. 
To download it, run `docker pull`. 

```
docker pull violafanfani/bst270-2025-nf:v0.0.0
```

To run the workflow using the container you can change the configuration (base.conf)
or use the 
```-with-docker violafanfani/bst270-2025-nf:v0.0.0``` flag.

## Results

You can specify the output folder inside the configuration file

Here is the structure of the results table

```bash
results/midus_reproducibility_20250121
├── figures
│   └── figure1.png
└── tables
    ├── preprocessMidus.log
    ├── preprocessed_data.csv
    ├── table1.csv
    ├── table1_t1_0_t2_0.csv
    ├── table1_t1_10_t2_20.csv
    ├── table1_t1_23_t2_26.csv
    └── table2.csv

```

## Authors

- Viola Fanfani & BST270 class
