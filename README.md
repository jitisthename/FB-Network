# FB-Network
The repository for data and code for the manuscript titled:
"Big data from a popular app reveals that fishing creates superhighways for aquatic invaders"

Our study uses big data from a smartphone app (Fishbrain) to reveal a dense network of recreational fishing trips that spans a continent and drives the spread of aquatic invasive species.

This dataset uses spatial reference provided by the US Geological Society's National Hydrography Dataset with slight modifications for our purposes. That dataset can be found through The National Map at https://apps.nationalmap.gov/downloader/#/. We used the waterbody layer and subset the dataset to include only those waterbodies that were designated as a lake or pond feature within the 18 major river basins of the contiguous United States, and greater than 0.06ha in size (HUC-2 #1-18).

angler_pairs_edge_list_0614.csv. This file includes all of the connections made by anglers traveling to sites in the United States and parts of southern Canada. These connections were derived from raw data provided by Fishbrain and include catches recorded by users between the dates of January 1, 2011, and June 14, 2021. Raw data requests should be directed to Fishbrain. For more details on how the data were derived, please refer to the Materials & Methods section of the publication [IN REVIEW].

anger_network_analysis.R This code runs the network analysis on the angler edge list using the igraph package in R. This code is provided as-is.

STATUS:
This manuscript is in review for publication

License
The data in this repository are open access and hosted on Zenodo under DOI 10.5281/zenodo.6388121
