# Generate Metadata for BirdNET-Analyzer Species and Select Non-bird Labels

[BirdNET-Analyzer](https://github.com/kahst/BirdNET-Analyzer) is a library for automatically classifying wildlife sounds from audio files. 

Recently, BirdNET-Analyzer was updated to include non-bird sounds including insects, frogs, and non-wildlife (e.g. 'Human', 'Engine', 'Dog', and 'Gun'). A complete list of all sound classes included in BirdNET-Analyzer is available [here](https://github.com/kahst/BirdNET-Analyzer/blob/main/checkpoints/V2.4/BirdNET_GLOBAL_6K_V2.4_Labels.txt) for version 2.4 (update the URL with other version numbers for other versions). 

This repository contains a small R script which takes the species list text file above as an input and generates taxonomic metadata for the sound classes based on [GBIF](https://www.gbif.org/) entries. This allows separation of bird from non-bird vocalizations and also helps interpret some of the species in their taxonomic context. Each class is labelled with its common name, latin binomial, and taxonomic labels (kingdom, phylum, class, order, and family). Classes which are not wildlife have their taxonomic fields left blank. 

To use it, get a copy of the total species list from the link above and save it in the project folder as 'birdnet_labels.txt'. Then run metadata_processing.R, which will output:

- all_species_metadata.csv - metadata for all labels (birds, non-bird wildlife, and non-wildlife)

- non_birds_metadata.csv - metadata for non-bird sounds (other wildlife and non-wildlife) 

- non_birds_species_list.txt - a new species label file 'non_birds_species_list.txt' which includes only the non-bird sound labels, using the format required by BirdNET-Analyzer for specifying species lists. 
