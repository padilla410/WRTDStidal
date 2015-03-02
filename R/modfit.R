######
#' Fit weighted regression and get predicted/normalized chlorophyll
#'
#' Fit weighted regression and get predicted/normalized chlorophyll from a data frame.  This is a wrapper for multiple function used to create a weighted regression model and should be used rather than the individual functions.
#'
#' @param dat_in input \code{\link[base]{data.frame}} for fitting the model, see details
#' @param ... arguments passed to or from other methods
#' 
#' @export
#' 
#' @return A tidal object with predicted and normalized chlorophyll prediction in log-space.
#' 
#' @details This function is used as a convenience to combine several functions that accomplish specific tasks, primarily the creation of a tidal object, fitting of the weighted regression models with \code{\link{wrtds}}, extraction of fitted values from the interpolation grids using \code{\link{chlpred}}, and normalization of the fitted values from the interpolation grid using \code{\link{chlnorm}}.  The format of the input data can be a \code{\link[base]{data.frame}} or \code{\link{tidal}} object, where the latter inherits methods from the former.  The data format should be chlorophyll observations as rows and the first four columns as date, chlorophyll, salinity (as fraction of freshwater), and detection limits.  The order of the columns may vary provided the order of each of the four critical variables is specified by the \code{ind} argument that is passed to the \code{\link{tidal}} function.  The chlorophyll data are also assumed to be in log-space, otherwise use \code{chllog = FALSE} which is also passed to the \code{\link{tidal}} function.  The default conditional quantile that is predicted is the median (\code{tau = 0.5}, passed to the \code{\link{wrtds}} function).  Numerous other arguments affect the output and the default parameters may not be appropriate for most scenarios.  Arguments used by other functions can be specified explicitly with the initial call.  The documentation for the functions under `see also' should be consulted for available arguments, as well as the examples that illustrate common changes to the default values.
#'
#' @seealso See the help files for \code{\link{tidal}}, \code{\link{wrtds}}, \code{\link{getwts}}, \code{\link{chlpred}}, and \code{\link{chlnorm}} for arguments that can be passed to this function.
#'
#' @examples
#' ## load data
#' data(chldat)
#' 
#' ## fit the model and get predicted/normalized chlorophyll data
#' # default median fit
#' # grids predicted across salinity range with ten values
#' res <- modfit(chldat)
#' 
#' ## fit different quantiles and smaller interpolation grid
#' res <- modfit(chldat, tau = c(0.2, 0.8), sal_div = 5)
#' 
#' ## fit with different window widths
#' # half-window widths of one day, five years, and 0.3 salff
#' res <- modfit(chldat, wins = list(1, 5, 0.3))
#' 
#' ## suppress console output
#' res <- modfit(chldat, trace = FALSE)
modfit <- function(dat_in, ...) UseMethod('modfit')

#' @rdname modfit
#'
#' @export
#'
#' @method modfit data.frame
modfit.data.frame <- function(dat_in, ...){

  # append data to arguments, create tidal object
  args <- c(list(dat_in = dat_in), list(...))
  dat <- do.call(tidal, args)
  
  # update args, get interpolation grids
  args <- c(list(tidal_in = dat, all = F), args)
  dat <- do.call(wrtds, args)
  
  # update args, get predictions
  args[['tidal_in']] <- dat
  dat <- do.call(chlpred, args)
  
  # get normalized predictions
  args[['tidal_in']] <- dat
  dat <- do.call(chlnorm, args)
  
  # return output
  return(dat)
  
}
