# Data analysis guide

The purpose of this guide is to help you in choosing the right tools and environment for your data analysis.  In addition, CSC organises a wide variety of training courses, many of which are related to data analytics and machine learning in CSC's computing environments.  Finally, CSC's specialists are happy to help with all aspects of your data driven research, and can be contacted via the CSC Service Desk.

## Getting started

To get started, you need to:

- have a CSC account
- be member of a CSC project, either by creating a new project or joining an existing project, e.g. by asking the project manager to add you

Finally, the project needs to have access to the services you will use.  More on our services below, and when you might use them.

## CSC's services

Below is a short glossary of CSC's services that are most relevant for data analysis.

**Puhti** is CSC's supercomputer where most computing should be done.  Puhti has a large set of pre-installed applications, and scales up to very computing heavy tasks, including GPU-based processing.

**Allas** is CSC's data storage service.  If you have big datasets or need to share data with people outside of your project, you should consider using Allas.

**Pouta** is CSC's cloud service where you can create your own virtual server.  This gives you more control over the computing environment, but may not be suitable for very heavy computing tasks.  Pouta is also more suitable for processing sensitive data, especially the ePouta variant.

**Rahti** is CSC's container cloud.  Here you can easily create virtual applications based on container images.

**Notebooks** is a great service if you just want to run a quick analysis directly in your web browser. Notebooks supports Jupyter with Python tools for data analysis and machine learning, and also RStudio.

## Example use cases

### Getting into data-driven research

*You have been dabbling in Excel or SPSS but now you are looking for more powerful ways to handle your data.*

A great way to start with data analytics is to attend a course. You can check out upcoming courses on the CSC training website. Also, CSC has some training materials that are suitable for self-learning, such as these introductory courses:

- R for Beginners
- Data Analysis with R
- Practical Machine Learning (using Python)

If you are in the field of bioinformatics, you might also want to check out the Chipster platform.

There is also plenty of data science information available online, some popular resources include Udemy,
Coursera and edX.

If you don't want to set up a development environment on your own laptop, you can easily use Rahti to set up an RStudio environment using a ready-made RStudio template from the template catalog.
More info about the RStudio template can be found in the RStudio-openshift GitHub repository.  
We also have instructions on how to use the Allas object storage from RStudio.

### Scaling up from your laptop (beginner)

*You have been running analyses in R or Python for some time already, but you have reached the limits of your own laptop or desktop computer. Perhaps you need more memory or faster processing?*

In most cases, the next step would be to move to CSC's supercomputer Puhti, which is a high performance computing (HPC) cluster. That means it's not one computer, but a collection of many computers. Users access the front-end server (login node) of Puhti, where they can submit computing jobs to a queuing system which takes care of distributing them to the cluster's different computers (compute nodes).  Please read the instructions on how to access Puhti, and how to submit computing jobs to Puhti's queuing system.

Puhti has a large selection of scientific computing applications pre-installed, including R and RStudio Server, and Python libraries for data analysis.  If you find something missing, don't hesitate to contact our Service Desk.

As Puhti is a shared computing environment, users are restricted in what they can do, for example when it comes to installing customized software or processing sensitive data.  In some cases, it might make sense to instead use **Pouta** to create your own virtual server.  This gives you more control over the computing environment, but may not be suitable for very heavy computing tasks.  Another option is **Rahti**, where you can create virtual applications based on container images. See some examples of how to deploy machine learning models on Rahti.

### Heavy computing needs (advanced)

*You are already an expert, but you have outgrown the resources of your local institution.*

If you need to heavily parallelize your computing, or for example use GPU-accelerated processing, Puhti is the right answer (see instructions in the above section).

For GPU-accelerated machine learning, we support TensorFlow, PyTorch, MXNET and RAPIDS. 

For more information:

- CSC's guide on GPU-accelerated machine learning

If you are using R for data analysis, we also support parallel batch jobs in R. Depending on your needs, many types of parallel computing are possible using R. Further to jobs employing multiple processors (cores) and threads, it is possible to run array jobs where an analysis is split into many subtasks. For analyses requiring multiple nodes, R also supports several types of Message Passing Interface (MPI)-based jobs.


<!-- ### Big data processing (advanced)

You can use Rahti for example running big data analytics and machine learning jobs on scalable Apache Spark cluster. -->

### Course environments (for teachers)

*You are teaching a course that needs complex computing environments for its exercises but you do not want to spend valuable course time on debugging installation errors.* 

Consider using CSC's Notebooks service that contains easy-to-use environments for working with data and programming. The course environments support Jupyter, Python (including many machine learning libraries), R / RStudio Server and Spark.

If you are planning to use Notebooks for your course, please remember to submit a notification about your course requirements using this online form.

CSC's collection of GitHub repositories for training purposes can also be a valuable resource for course planning and sharing teaching materials with course participants.
