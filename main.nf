// enabling nextflow DSL v2
nextflow.enable.dsl=2

// import from modules
// include { plotGGPlot } from './modules/rsteps.nf'

process preprocessMidus {

    publishDir "${params.resultsDir}/tables/", pattern: "*preprocess*", mode: 'copy'

    input:
        file(data_optimism)
        file(data_biomarker)

    output:
        tuple file(data_optimism), file(data_biomarker), file('preprocessed_data.csv'), file('preprocessMidus.log')

    script:
    """
        Rscript ${baseDir}/bin/cli_preprocessing.r ${data_optimism} ${data_biomarker} preprocessed_data.csv > preprocessMidus.log
    """

}

process plotFigure1 {

    publishDir "${params.resultsDir}/figures/", pattern: "figure1.png", mode: 'copy'

    input:
        tuple file(data_optimism), file(data_biomarker), file(midus), file(midus_log)

    output:
        tuple file(data_optimism), file(data_biomarker), file(midus), file(midus_log), file('figure1.png')

    script:
    """
        Rscript ${baseDir}/bin/cli_figure1.r ${midus} figure1.png 
    """

}


process createTable1 {

    publishDir "${params.resultsDir}/tables/", pattern: "table*.csv", mode: 'copy'

    input:
        tuple file(data_optimism), file(data_biomarker), file(midus), file(midus_log), val(tertile1), val(tertile2)

    output:
        tuple file(data_optimism), file(data_biomarker), file(midus), file(midus_log), val(tertile1), val(tertile2), file("table1_t1_${tertile1}_t2_${tertile2}.csv")

    script:
    """
        Rscript ${baseDir}/bin/cli_table1.R ${midus} table1_t1_${tertile1}_t2_${tertile2}.csv --tertile1 ${tertile1} --tertile2 ${tertile2} 
    """
}


process createTable2 {

    publishDir "${params.resultsDir}/tables/", pattern: "table2.csv", mode: 'copy'

    input:
        tuple file(data_optimism), file(data_biomarker), file(midus), file(midus_log)

    output:
        tuple file(data_optimism), file(data_biomarker), file(midus), file(midus_log), file("table2.csv")

    script:
    """
        Rscript ${baseDir}/bin/cli_table2.R ${midus} table2.csv
    """
}



workflow {
    

    opData = Channel.fromPath(params.optimism_data).view()
    bmData = Channel.fromPath(params.biomarker_data).view()

    // Read midus data
    cleanData = preprocessMidus(opData, bmData)

    // Plot figure 1
    plotFigure1(cleanData)

    // Plot figure X
    tertileCh = Channel.from(params.tertiles)
    createTable1(cleanData.combine(tertileCh))


    // Create table 2
    table2 = createTable2(cleanData)

    
}