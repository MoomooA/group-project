 Monitoring and Recovering System for the Optimisation Process in Engineering
========


```
Description: Distributed System for Monitoring a Workflow Process
Authors: Mathieu Dutour, Jakub Baron, Leo Raimondjean, Miguel Martínez
Version: v0.1 Feb 2015
```


This project contains:

1. Drag Solver - Solves drag equation
2. Lift Solver - Solves lift equation
3. Optimizer - Optimization process
3. Authentication - Package that handles user authentication
4. Monitor - Handles monitoring of solvers
5. Wing Drawing - Draws wing HTML5 + JS

### DEPENDENCIES:

+ SSH2 for Authentication package


### TECHNOLOGY:

+ Node JS + Meteor

### Installation

1. Install Meteor

```
curl https://install.meteor.com/ | sh
```

2. Symlink the packages

```
cd group-project/

ln -s /absolute/path/to/group-project:authentication monito/packages/group-project:authentication
ln -s /absolute/path/to/group-project:drag-solver monito/packages/group-project:drag-solver
ln -s /absolute/path/to/group-project:lift-solver monito/packages/group-project:lift-solver
ln -s /absolute/path/to/group-project:optimizer monito/packages/group-project:optimizer
```

3. Run Meteor

```
cd monitor/

meteor
```

