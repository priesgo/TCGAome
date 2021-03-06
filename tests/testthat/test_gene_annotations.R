context("Tests gene_annotations.R")
source("helper_functions.R")

## Test all term-level methods
test_annotations_methods <- function(gene_annotations) {

    ## Gets term frequency
    for (x in 1:10) {
        random_term <- get_random_term(gene_annotations)
        freq <- TCGAome::get_term_freq(
            gene_annotations,
            random_term)
        testthat::expect_is(freq, "numeric")
        testthat::expect_gte(freq, 0)
        testthat::expect_lte(freq, 1)
        random_term2 <- get_term_by_freq(gene_annotations, freq)
        freq2 <- TCGAome::get_term_freq(
            gene_annotations,
            random_term2)
        testthat::expect_is(freq2, "numeric")
        testthat::expect_equal(freq, freq2)

        ## Non existing term
        testthat::expect_error(TCGAome::get_term_freq(
            gene_annotations,
            "nonexistingterm"))
    }

    for (x in 1:10) {
        ## Gets 2 random terms
        random_term1 <- get_random_term(gene_annotations)
        random_term2 <- get_random_term(gene_annotations)

        ## Tests all supported distance over the random terms
        for (distance_measure in gene_annotations@func_similarity_methods) {

            similarity = TCGAome::get_functional_similarity(
                gene_annotations,
                term1 = random_term1,
                term2 = random_term2,
                distance_measure = distance_measure)
            testthat::expect_is(similarity, "numeric")
            testthat::expect_gte(similarity, 0)
            testthat::expect_lte(similarity, 1)
        }

        ## Non supported distance measure
        testthat::expect_error(TCGAome::get_functional_similarity(
            gene_annotations,
            term1 = random_term1,
            term2 = random_term2,
            distance_measure = "non-supported"))

        ## Non existing terms
        testthat::expect_error(TCGAome::get_functional_similarity(
            gene_annotations,
            term1 = "nonexistingterm",
            term2 = random_term2,
            distance_measure = "UI"))
        testthat::expect_error(TCGAome::get_functional_similarity(
            gene_annotations,
            term1 = random_term1,
            term2 = "nonexistingterm",
            distance_measure = "UI"))
    }

    for (distance_measure in gene_annotations@func_similarity_methods) {
        ## Gets distance matrix over all terms
        term_distance_matrix <- TCGAome::get_term_distance_matrix(
            gene_annotations,
            distance_measure = distance_measure)

    }
}

test_annotations_slots <- function(gene_annotations) {
    testthat::expect_is(gene_annotations, "GeneAnnotations")
    testthat::expect_is(gene_annotations@raw_annotations, "data.frame")
    testthat::expect_equal(
        colnames(gene_annotations@raw_annotations), c("Gene", "Term"))
    testthat::expect_is(gene_annotations@raw_annotations$Gene, "character")
    testthat::expect_is(gene_annotations@raw_annotations$Term, "character")
    testthat::expect_is(gene_annotations@gene2term, "data.frame")
    testthat::expect_is(gene_annotations@gene2term$Gene, "character")
    testthat::expect_is(gene_annotations@gene2term$Term, "list")
    testthat::expect_equal(
        length(unique(gene_annotations@raw_annotations$Gene)),
        length(gene_annotations@gene2term$Gene))
    testthat::expect_is(gene_annotations@term2gene, "data.frame")
    testthat::expect_is(gene_annotations@term2gene$Term, "character")
    testthat::expect_is(gene_annotations@term2gene$Gene, "list")
    testthat::expect_equal(
        length(unique(gene_annotations@raw_annotations$Term)),
        length(gene_annotations@term2gene$Term))
    testthat::expect_is(gene_annotations@max_term_annotations, "integer")
    testthat::expect_gt(gene_annotations@max_term_annotations, 0)
}

################################################################################
## Predefined constructor tests
################################################################################

test_that("load_goa()", {
    testthat::skip("test takes too long")
    ## Loads human GOA for a first time
    human_goa <- TCGAome::load_goa()
    ## Test slots
    test_annotations_slots(human_goa)
    ## Loads the cached version
    human_goa <- TCGAome::load_goa()
    ## Test slots
    test_annotations_slots(human_goa)
    ## Test methods
    test_annotations_methods(human_goa)
})

test_that("load_goa(uniprot)", {
    testthat::skip("test takes too long")
    ## Loads human GOA for a first time
    uniprot_goa <- TCGAome::load_goa(search_universe = "uniprot")
    ## Test slots
    test_annotations_slots(uniprot_goa)
    ## Loads the cached version
    uniprot_goa <- TCGAome::load_goa(search_universe = "uniprot")
    ## Test slots
    test_annotations_slots(uniprot_goa)
    ## Test methods
    test_annotations_methods(uniprot_goa)
})

test_that("load_goa(searc_universe = other)", {
    ## Loads a GOA for a non supported universe
    testthat::expect_error(TCGAome::load_goa(search_universe = "other"))
})

test_that("load_goa(ontology = whatever)", {
    ## Loads a GOA for a non supported universe
    testthat::expect_error(TCGAome::load_goa(ontology = "whatever"))
})

test_that("load_hpo()", {
    testthat::skip("test takes too long")
    ## Loads HPO for a first time
    hpo <- TCGAome::load_hpo()
    ## Test slots
    test_annotations_slots(hpo)
    ## Loads the cached version
    hpo <- TCGAome::load_hpo()
    ## Test slots
    test_annotations_slots(hpo)
    ## Test methods
    test_annotations_methods(hpo)
})

test_that("load_kegg()", {
    testthat::skip("test takes too long")
    ## Loads KEGG for a first time
    kegg <- TCGAome::load_kegg()
    ## Test slots
    test_annotations_slots(kegg)
    ## Loads the cached version
    kegg <- TCGAome::load_kegg()
    ## Test slots
    test_annotations_slots(kegg)
    ## Test methods
    test_annotations_methods(kegg)
})

test_that("load_omim()", {
    testthat::skip("test takes too long")
    ## Loads omim for a first time
    omim <- TCGAome::load_omim()
    ## Test slots
    test_annotations_slots(omim)
    ## Loads the cached version
    omim <- TCGAome::load_omim()
    ## Test slots
    test_annotations_slots(omim)
    ## Test methods
    test_annotations_methods(omim)
})

################################################################################
## Constructor tests
################################################################################

test_that("empty annotations", {
    empty_annotations <- data.frame(Gene = c(), Term = c())
    testthat::expect_error(TCGAome::GeneAnnotations(empty_annotations, "empty"))
})

test_that("wrong columns", {
    wrong_annotations <- data.frame(EntrezID = c("1234", "1234", "9876"),
                                    GO = c("GO:0001", "GO:0002", "GO:0001"))
    testthat::expect_error(TCGAome::GeneAnnotations(wrong_annotations, "wrong"))
})

test_that("random annotations", {
    random_annotations <- get_random_annotations(1000)
    random <- TCGAome::GeneAnnotations(random_annotations, "random")
    ## Test slots
    test_annotations_slots(random)
    ## Test methods
    test_annotations_methods(random)
})

################################################################################
## get_term_distance_matrix tests
################################################################################

test_that("get_term_distance_matrix", {
    random_annotations <- get_random_annotations(100)
    random <- TCGAome::GeneAnnotations(random_annotations, "random")
    expected_terms <- random@term2gene$Term
    for (distance_measure in random@func_similarity_methods) {
        random_dist <- TCGAome::get_term_distance_matrix(
            random, distance_measure = distance_measure)
        observed_terms <- attr(random_dist, "Labels")
        testthat::expect_is(random_dist, "dist")
        testthat::expect_true(
            length(expected_terms) == length(intersect(expected_terms,
                                                       observed_terms)))
    }
    testthat::expect_error(TCGAome::get_term_distance_matrix(
        random, distance_measure = "non_supported"))
})

test_that("get_term_distance_matrix subset", {
    random_annotations <- get_random_annotations(100)
    random <- TCGAome::GeneAnnotations(random_annotations, "random")
    expected_terms <- sample(random@term2gene$Term, 5)
    for (distance_measure in random@func_similarity_methods) {
        random_dist <- TCGAome::get_term_distance_matrix(
            random,
            distance_measure = distance_measure,
            terms_subset = expected_terms)
        observed_terms <- attr(random_dist, "Labels")
        testthat::expect_is(random_dist, "dist")
        testthat::expect_true(
            length(union(expected_terms, observed_terms)) ==
                length(intersect(expected_terms, observed_terms)))
    }
    testthat::expect_error(TCGAome::get_term_distance_matrix(
        random, distance_measure = "non_supported"))
})

test_that("get_term_distance_matrix only one term", {
    one_row_annotations <- data.frame(Gene = "GENE1", Term = "GO:0001")
    testthat::expect_error(
        TCGAome::GeneAnnotations(one_row_annotations, "one_row"))
})


################################################################################
## get_enrichment tests
################################################################################
test_that("get_enrichment", {
    random_annotations <- get_random_annotations(1000)
    random <- TCGAome::GeneAnnotations(random_annotations, "random")
    expected_terms <- random@term2gene$Term
    expected_genes <- random@gene2term$Gene
    subset_genes <- sample(expected_genes, size = 20, replace = FALSE)
    enrichment <- TCGAome::get_enrichment(random, gene_list = subset_genes)
    testthat::expect_is(enrichment, "GeneListEnrichment")
    testthat::expect_error(TCGAome::get_enrichment(random, gene_list = c()))
    subset_genes <- sample(expected_genes, size = 2, replace = FALSE)
    enrichment <- TCGAome::get_enrichment(random, gene_list = subset_genes)
    testthat::expect_is(enrichment, "GeneListEnrichment")
})
