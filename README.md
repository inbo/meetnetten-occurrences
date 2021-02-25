# Meetnetten.be - Monitoring of priority species in Flanders, Belgium

## Rationale

This repository contains the functionality to standardize datasets of [Meetnetten.be](https://meetnetten.be) to [Darwin Core Occurrence](https://www.gbif.org/dataset-classes) datasets that can be harvested by [GBIF](http://www.gbif.org).

## Datasets

Title (and GitHub directory) | IPT | GBIF
--- | --- | ---
[Meetnetten.be - Chorus counts for Amphibia in Flanders, Belgium](datasets/5%2B33%20meetnetten-amfibieen-roepkoren-occurrences) | [meetnetten-amphibia-roepkoren-occurrences](https://ipt.inbo.be/resource?r=meetnetten-amphibia-roepkoren-occurrences) | <https://doi.org/10.15468/d4bu8j>
[Meetnetten.be - Egg counts for butterflies in Flanders, Belgium](datasets/15%20meetnetten-dagvlinders-eitelling-occurrences) | [meetnetten-butterflies-egg-occurrences](https://ipt.inbo.be/resource?r=meetnetten-butterflies-egg-occurrences) | <https://doi.org/10.15468/hsfq2u>
[Meetnetten.be - Exuviae counts for dragonflies in Flanders, Belgium](datasets/9%2B37%20meetnetten-libellen-larvenhuidjes-occurrences) | [meetnetten-libellen-larvenhuidjes-occurrences](https://ipt.inbo.be/resource?r=meetnetten-libellen-larvenhuidjes-occurrences) | <https://doi.org/10.15468/ue87ux>
[Meetnetten.be - Fyke counts for Amphibia in Flanders, Belgium](datasets/2%20meetnetten-amfibieen-fuiken-occurrences) | [meetnetten-amfibieen-fuiken-occurrences](https://ipt.inbo.be/resource?r=meetnetten-amfibieen-fuiken-occurrences) | <https://doi.org/10.15468/zeaq2t>
[Meetnetten.be - Larvae and metamorph counts for Amphibia in Flanders, Belgium](datasets/25%2B32%20meetnetten-amfibieen-larven-metamorfen-occurrences) | [meetnetten-amfibieen-larven-metamorfen-occurrences](https://ipt.inbo.be/resource?r=meetnetten-amfibieen-larven-metamorfen-occurrences) | <https://doi.org/10.15468/swgure>
[Meetnetten.be - Population counts for dragonflies in Flanders, Belgium](datasets/3%20meetnetten-libellen-populatietelling-occurrences) | [meetnetten-libellen-populatietelling-occurrences](https://ipt.inbo.be/resource?r=meetnetten-libellen-populatietelling-occurrences) | <https://doi.org/10.15468/crbudg>
[Meetnetten.be - Sightings for Natterjack toad in Flanders, Belgium](datasets/34%20meetnetten-rugstreeppad-zichtwaarneming-occurrences) | [meetnetten-rugstreeppad-zichtwaarneming-occurrences](https://ipt.inbo.be/resource?r=meetnetten-rugstreeppad-zichtwaarneming-occurrences) | <https://doi.org/10.15468/2xfw8y>
[Meetnetten.be - Site counts for butterflies in Flanders, Belgium](datasets/28%2B39%20meetnetten-dagvlinders-gebiedstelling-occurrences) | [meetnetten-butterflies-area-occurrences](https://ipt.inbo.be/resource?r=meetnetten-butterflies-area-occurrences) | <https://doi.org/10.15468/hvgkh4>
[Meetnetten.be - Transects for butterflies in Flanders, Belgium](datasets/1%20meetnetten-dagvlinders-transect-occurrences/sql) | [meetnetten-butterflies-occurrences](https://ipt.inbo.be/resource?r=meetnetten-butterflies-occurrences) | <https://doi.org/10.15468/kfhvy4>
[Meetnetten.be - Transects for dragonflies in Flanders, Belgium](datasets/8%20meetnetten-libellen-transect-occurrences) | [meetnetten-libellen-transect-occurrences](https://ipt.inbo.be/resource?r=meetnetten-libellen-transect-occurrences) | <https://doi.org/10.15468/y8u6e9>
[Meetnetten.be - Transects for fire salamanders in Flanders, Belgium](datasets/4%20meetnetten-vuursalamander-transect-occurrences) | [meetnetten-vuursalamander-transect-occurrences](https://ipt.inbo.be/resource?r=meetnetten-vuursalamander-transect-occurrences) | <https://doi.org/10.15468/nbsk9h>
[Transects for non-target butterfly species in Flanders, Belgium](datasets/datasets/29%20meetnetten-dagvlinders-algemene-occurrences) | [meetnetten-butterflies-algemene-occurrences](https://ipt.inbo.be/resource?r=meetnetten-butterflies-algemene-occurrences) | <>

## Repo structure

The structure for each dataset in [datasets](datasets) is based on [Cookiecutter Data Science](http://drivendata.github.io/cookiecutter-data-science/) and the [Checklist recipe](https://github.com/trias-project/checklist-recipe). Files and directories indicated with `GENERATED` should not be edited manually.

```
├── sql                      : Darwin Core SQL queries
│
└── specs                    : Whip specifications for validation
```

## Contributors

[List of contributors](https://github.com/inbo/meetnetten-occurrences/graphs/contributors)

## License

[MIT License](LICENSE) for the code and documentation in this repository. The included data is released under another license.
