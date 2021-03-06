% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gene_annotations.R
\name{load_hpo}
\alias{load_hpo}
\title{Reads Human Phenotype Ontology (HPO) annotations.}
\usage{

  load_hpo(hpo_annotations_url = "http://compbio.charite.de/jenkins/job/hpo.annotations.monthly/lastStableBuild/artifact/annotation/ALL_SOURCES_TYPICAL_FEATURES_phenotype_to_genes.txt")
}
\arguments{
\item{hpo_annotations_url}{The URL to HPO annotations to genes.
[default: "http://compbio.charite.de/jenkins/job/hpo.annotations.monthly/lastStableBuild/artifact/annotation/ALL_SOURCES_TYPICAL_FEATURES_phenotype_to_genes.txt"]}
}
\description{
Reads Human Phenotype Ontology (HPO) annotations.
}
\examples{
hpo = load_hpo()
}
\keyword{TCGAome}

