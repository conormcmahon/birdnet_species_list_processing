# Generate Metadata for BirdNET-Analyzer Species and Select Non-bird Labels

[BirdNET-Analyzer](https://github.com/kahst/BirdNET-Analyzer) is a library for automatically classifying wildlife sounds from audio files. 

Recently, BirdNET-Analyzer was updated to include non-bird sounds including insects, frogs, and non-wildlife (e.g. 'Human', 'Engine', 'Dog', and 'Gun'). A complete list of all sound classes included in BirdNET-Analyzer is available [here](https://github.com/kahst/BirdNET-Analyzer/blob/main/checkpoints/V2.4/BirdNET_GLOBAL_6K_V2.4_Labels.txt) for version 2.4 (update the URL with other version numbers for other versions). 

This library contains a lightweight R script which takes the text file above as an imput and generates metadata for the classes based on [GBIF](https://www.gbif.org/) entries. This allows separation of bird from non-bird vocalizations. 

To use it, download a copy of the total species list from the link above and save it in the project folder as 'birdnet_labels.txt'. Then run the file, which will output metadata CSVs for all records, for the non-bird records, and also a new species label file 'non_birds_species_list.txt' which includes only the non-bird sound labels. 
