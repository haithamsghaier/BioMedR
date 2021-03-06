% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/408-extractDrugAutocorrelationCharge.R
\name{Autocorrelation}
\alias{Autocorrelation}
\alias{extrDrugAutocorrelationcharge}
\alias{extrDrugAutocorrelationMass}
\alias{extrDrugAutocorrelationPolarizability}
\title{Calculates the Moreau-Broto Autocorrelation Descriptors using Partial Charges}
\usage{
extrDrugAutocorrelationcharge(molecules, silent = TRUE)

extrDrugAutocorrelationMass(molecules, silent = TRUE)

extrDrugAutocorrelationPolarizability(molecules, silent = TRUE)
}
\arguments{
\item{molecules}{Parsed molucule object.}

\item{silent}{Logical. Whether the calculating process 
should be shown or not, default is \code{TRUE}.}
}
\value{
A data frame, each row represents one of the molecules, 
each column represents one feature. 
This function returns 5 columns named 
\code{ATSc1}, \code{ATSc2}, \code{ATSc3}, \code{ATSc4}, \code{ATSc5}.

extrDrugAutocorrelationMass: This function returns 5 columns named 
\code{ATSm1}, \code{ATSm2}, \code{ATSm3}, \code{ATSm4}, \code{ATSm5}.

extrDrugAutocorrelationPolarizability: This function returns 5 columns named 
\code{ATSp1}, \code{ATSp2}, \code{ATSp3}, \code{ATSp4}, \code{ATSp5}.
}
\description{
Calculates the Moreau-Broto Autocorrelation Descriptors using Partial Charges

Calculates the Moreau-Broto Autocorrelation Descriptors using Atomic Weight

Calculates the Moreau-Broto Autocorrelation Descriptors using Polarizability
}
\details{
Calculates the ATS autocorrelation descriptor, 
where the weight equal to the charges.

Calculates the ATS autocorrelation descriptor, 
where the weight equal to the scaled atomic mass.

Calculates the ATS autocorrelation descriptor using polarizability.
}
\examples{
# Calculates the Moreau-Broto Autocorrelation Descriptors using Partial Charges
smi = system.file('vignettedata/test.smi', package = 'BioMedR')
mol = readMolFromSmi(smi, type = 'mol')
dat = extrDrugAutocorrelationcharge(mol)
head(dat)

# Calculates the Moreau-Broto Autocorrelation Descriptors using Atomic Weight
dat = extrDrugAutocorrelationMass(mol)
head(dat)

# Calculates the Moreau-Broto Autocorrelation Descriptors using Polarizability
dat = extrDrugAutocorrelationPolarizability(mol)
head(dat)

}
\references{
Moreau, Gilles, and Pierre Broto. 
The autocorrelation of a topological structure: a new molecular descriptor.
Nouv. J. Chim 4 (1980): 359-360.
}
\author{
Min-feng Zhu <\email{wind2zhu@163.com}>, 
        Nan Xiao <\url{http://r2s.name}>
}
\keyword{Autocorrelation}
\keyword{Charge}
\keyword{Mass}
\keyword{Polarizability}
\keyword{extrDrugAutocorrelationMass}
\keyword{extrDrugAutocorrelationPolarizability}
\keyword{extrDrugAutocorrelationcharge}
