#' Parallelized Drug Molecule Similarity Search by 
#' Molecular Fingerprints Similarity or Maximum Common Substructure Search
#' 
#' Parallelized Drug Molecule Similarity Search by 
#' Molecular Fingerprints Similarity or Maximum Common Substructure Search
#' 
#' This function does compound similarity search derived by 
#' various molecular fingerprints with various similarity measures or 
#' derived by maximum common substructure search.
#' This function runs for a query compound against a set of molecules.
#' 
#' @param mol The query molecule. The location of a \code{sdf} file 
#' containing one molecule.
#' @param moldb The molecule database. The location of a \code{sdf} file 
#' containing all the molecules to be searched with.
#' @param method \code{'fp'} or \code{'mcs'}. Search by molecular fingerprints
#'               or by maximum common substructure searching.
#' @param fptype The fingerprint type, only available when \code{method = 'fp'}.
#'               BioMedR supports 13 types of fingerprints, including 
#'               \code{'standard'}, \code{'extended'}, \code{'graph'},
#'               \code{'hybrid'}, \code{'maccs'}, \code{'estate'}, 
#'               \code{'pubchem'}, \code{'kr'}, \code{'shortestpath'}.
#' @param fpsim Similarity measure type for fingerprint, 
#'              only available when \code{method = 'fp'}.
#'              Including \code{'tanimoto'}, \code{'euclidean'}, 
#'              \code{'cosine'}, \code{'dice'} and \code{'hamming'}. 
#'              See \code{calcDrugFPSim} for details.
#' @param mcssim Similarity measure type for maximum common substructure search, 
#'               only available when \code{method = 'mcs'}. 
#'               Including \code{'tanimoto'} and \code{'overlap'}.
#' @param ... Other possible parameter for maximum common substructure search.
#' 
#' @return Named numerical vector.
#' With the decreasing similarity value of the molecules in the database.
#' 
#' @keywords searchDrug Drug Molecule Similarity Search MCS
#' 
#' @aliases searchDrug
#' 
#' @author Min-feng Zhu <\email{wind2zhu@@163.com}>, 
#'         Nan Xiao <\url{http://r2s.name}>
#' 
#' @export searchDrug
#' 
#' @examples
#' \donttest{
#' mol = system.file('compseq/example.sdf', package = 'BioMedR')
#' # DrugBank ID DB00530: Erlotinib
#' moldb = system.file('compseq/bcl.sdf', package = 'BioMedR')
#' # Database composed by searching 'tyrphostin' in PubChem and filtered by Lipinski's Rule of Five
#' searchDrug(mol, moldb, method = 'fp', fptype = 'maccs', fpsim = 'hamming')}
#' 

searchDrug = function (mol, moldb,
                       method = c('fp', 'mcs'), 
                       fptype = c('standard', 'extended', 'graph',
                                  'hybrid', 'maccs', 'estate',
                                  'pubchem', 'kr', 'shortestpath'), 
                       fpsim = c('tanimoto', 'euclidean', 'cosine', 
                                 'dice', 'hamming'), 
                       mcssim = c('tanimoto', 'overlap'), ...) {

    # doParallel::registerDoParallel(cores)

    if (method == 'fp') {

        if ( fptype %in% c('standard', 'extended', 'graph', 
                           'hybrid',   'maccs',    'estate',
                           'pubchem',  'kr',       'shortestpath') ) {

            mol   = rcdk::load.molecules(mol)
            moldb = rcdk::load.molecules(moldb)

        }

        if ( fptype %in% c('obmaccs') ) {

            mol   = readChar(mol, nchars = file.info(mol)['size'])
            moldb = readChar(moldb, nchars = file.info(moldb)['size'])

        }

        if (fptype == 'standard') {

            molfp   = extrDrugStandardComplete(mol[[1]])
            moldbfp = extrDrugStandardComplete(moldb)

        }

        if (fptype == 'extended') {

            molfp   = extrDrugExtendedComplete(mol[[1]])
            moldbfp = extrDrugExtendedComplete(moldb)

        }

        if (fptype == 'graph') {

            molfp   = extrDrugGraphComplete(mol[[1]])
            moldbfp = extrDrugGraphComplete(moldb)

        }

        if (fptype == 'hybrid') {

            molfp   = extrDrugHybridizationComplete(mol[[1]])
            moldbfp = extrDrugHybridizationComplete(moldb)

        }

        if (fptype == 'maccs') {

            molfp   = extrDrugMACCSComplete(mol[[1]])
            moldbfp = extrDrugMACCSComplete(moldb)

        }

        if (fptype == 'estate') {

            molfp   = extrDrugEstateComplete(mol[[1]])
            moldbfp = extrDrugEstateComplete(moldb)

        }

        if (fptype == 'pubchem') {

            molfp   = extrDrugPubChemComplete(mol[[1]])
            moldbfp = extrDrugPubChemComplete(moldb)

        }

        if (fptype == 'kr') {

            molfp   = extrDrugKRComplete(mol[[1]])
            moldbfp = extrDrugKRComplete(moldb)

        }

        if (fptype == 'shortestpath') {

            molfp   = extrDrugShortestPathComplete(mol[[1]])
            moldbfp = extrDrugShortestPathComplete(moldb)

        }
      
        i = NULL

        rankvec = rep(NA, nrow(moldbfp))

        # rankvec <- foreach (i = 1:nrow(moldbfp), .combine = 'c', .errorhandling = 'pass') %dopar% {
        #     tmp <- calcDrugFPSim(as.vector(molfp), as.vector(moldbfp[i, ]), fptype = 'complete', metric = fpsim)
        # }
        for (i in 1:nrow(moldbfp)) {
          rankvec[i] = calcDrugFPSim(as.vector(molfp), as.vector(moldbfp[i, ]), fptype = 'complete', metric = fpsim)
        }
        
        rankvec.ord = order(rankvec, decreasing = TRUE)
        rankvec = rankvec[rankvec.ord]
        names(rankvec) = as.character(rankvec.ord)

    }

    if (method == 'mcs') {

        mol = ChemmineR::read.SDFset(mol)
        moldb = ChemmineR::read.SDFset(moldb)

        fmcsresult = fmcsR::fmcsBatch(mol, moldb, ...)

        if (mcssim == 'tanimoto') {
            rankvec = fmcsresult[order(fmcsresult[, 'Tanimoto_Coefficient'], 
                                       decreasing = TRUE), 'Tanimoto_Coefficient']
        }

        if (mcssim == 'overlap') {
            rankvec = fmcsresult[order(fmcsresult[, 'Overlap_Coefficient'], 
                                       decreasing = TRUE), 'Overlap_Coefficient']
        }

        names(rankvec) = gsub('CMP', '', names(rankvec))

    }

    return(rankvec)

}
