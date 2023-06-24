
# Library containing many taxa 
library(rgbif)
# Library for processing filepaths
library(here)
# Library for handling dataframes in dplyr
library(tidyverse)


# Input list of species name labels
# Note - BirdNET-Analyzer labels are in the format <Genus species_Common Name>
#   For example, the Yellow-rumped Warbler is the following string:
#      Setophaga coronata_Yellow-rumped Warbler
#   Some non-animal sounds are also included, which have identical common and "binomial" names, for example:
#      Gun_Gun
labels_raw <- readLines(here::here("birdnet_labels.txt"))


# Get metadata for a species from GBIF
getSpeciesMetadata <- function(str)
{
  print(str)
  # Split string at _ character into binomial vs. common name
  names <- str_split(str,"_")[[1]]
  
  # Get Common Name
  if(length(names) > 1)
    common_name <- names[[2]]
  else common_name <- ""
  
  # Get scientific binomial, genus, and species
  binomial <- names[[1]]
  binomial_split <- str_split(binomial, " ")[[1]]
  genus <- binomial_split[[1]]
  if(length(binomial_split) > 1)
    species <- binomial_split[[2]]
  else species <- ""
  
  # Default empty data frame for output
  default_dataframe <- data.frame(kingdom = "",
                                  phylum = "",
                                  class = "",
                                  order = "",
                                  family = "",
                                  genus = "",
                                  species = "",
                                  common_name = common_name,
                                  binomial = binomial,
                                  bird = FALSE)
  
  # Look up all GBIF animal records matching that binomial 
  # NOTE - animals and non-animal taxa have separate naming conventions so binomials are unique among animals,
  #   but not necessarily across all organisms - for example, a plant and an animal can have the same binomial
  class_list <- name_lookup(binomial)$data %>%
    filter(species == binomial)
  if(!("kingdom" %in% names(class_list)) * (nrow(class_list) > 0))
    return(default_dataframe)
  class_list <- class_list %>% 
    filter(kingdom %in% c("ANIMALIA", "Animalia", "animalia",
                          "Animals", "ANIMALS", "animals",
                          "Metazoa", "METAZOA", "metazoa"))
  if(nrow(class_list) == 0)
    return(default_dataframe)
  # Extract most common value for each taxonomic level 
  # This handles issues where individual records have different case, misspellings, etc. 
  kingdom <- (class_list %>% 
                group_by(kingdom) %>%
                tally() %>% 
                drop_na() %>%
                arrange(-n))[1,]$kingdom
  phylum <- (class_list %>% 
                group_by(phylum) %>%
                tally() %>% 
                drop_na() %>%                
                arrange(-n))[1,]$phylum
  class <- (class_list %>% 
                group_by(class) %>%
                tally() %>% 
                drop_na() %>%
                arrange(-n))[1,]$class
  order <- (class_list %>% 
                group_by(order) %>%
                tally() %>% 
                drop_na() %>%
                arrange(-n))[1,]$order
  family <- (class_list %>% 
              group_by(family) %>%
              tally() %>% 
              drop_na() %>%
              arrange(-n))[1,]$family
  
  # Amalgamate these into a dataframe for return 
  return(data.frame(kingdom = kingdom,
                    phylum = phylum,
                    class = class,
                    order = order,
                    family = family,
                    genus = genus,
                    species = species,
                    common_name = common_name,
                    binomial = binomial,
                    bird = ("Aves" %in% class_list$class)))
}

# Extract metadata for all species labels
all_species_list <- lapply(labels_raw, getSpeciesMetadata)
# Form into a dataframe, and regenerate 
all_species <- bind_rows(all_species_list) %>%
  mutate(full_code = labels_raw)
non_birds <- all_species %>% 
  filter(!bird)

write_csv(all_species, here::here("all_species_metadata.csv"))
write_csv(non_birds, here::here("non_birds_metadata.csv"))
writeLines(non_birds$full_code, here::here("non_birds_species_list.txt"))


