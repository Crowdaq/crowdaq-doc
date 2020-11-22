# Crowdaq

Data are key to success for AI systems. However, large-scale data annotation efforts are often confronted with a set of common challenges: 
- designing a user-friendly annotation interface
- training enough annotators efficiently
- reproducibility

In practice, it often requires a data requester to have proficiency in frontend design (e.g., JavaScript), database management, crowd sourcing platforms (e.g., Amazon Mechanical Turk), to handle these challenges effectively.

[Crowdaq](https://www.crowdaq.com/), short for crowdsourcing with automated qualification, is a web-based platform aimed to address these problems. It standardizes the data collection pipeline with customizable user-interface components, automated annotator qualification, and saved pipelines in a re-usable format. If you know JSON and the basics of crowd sourcing, you can collect your data via Crowdaq effortlessly.

# Overview

This repository hosts the documentation for Crowdaq. It has the following sections:
- Documentation for requesters (those who want to collect data) [link](docs/requester)
- Documentation for developers (those who want to contribute to, modify, and/or deploy Crowdaq) [link](docs/developer)

# Citation

This work is accepted to EMNLP'2020 (demo track). If you find this work useful in your work, please kindly cite the following [paper](https://arxiv.org/abs/2010.06694):
```
@inproceedings{NWDDGLMN20,
    title = "Easy, Reproducible and Quality-Controlled Data Collection with {CROWDAQ}",
    author = "Ning, Qiang  and
      Wu, Hao  and
      Dasigi, Pradeep  and
      Dua, Dheeru  and
      Gardner, Matt  and
      Logan IV, Robert L.  and
      Marasovi{\'c}, Ana  and
      Nie, Zhen",
    booktitle = "EMNLP (demo track)",
    year = "2020",
    pages = "127--134",
}
```