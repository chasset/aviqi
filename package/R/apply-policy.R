#' Increment policy errors found
incErrorsPolicy <- function(policy) {
  policies <- getOption("aviqi.policies")
  policies$hitted[policy] <- policies$hitted[policy] + 1
  options(aviqi.policies = policies)
  return(NULL)
}

#' Stop or Go
#'
#' Depending on the choosen policy and the number of errors found,
#' it decides if it stops or continues the pipeline process.
#'
#' @param df Dataframe received in the pipeline
#' @export
stopOrGo <- function(df) {
  policy <- getOption("aviqi.chosenPolicy")
  policies <- getOption("aviqi.policies")
  if (policies$hitted[policy] > 0) {
    stop(policies$policy[policy], "has been hitted ", policies$hitted[policy], " times")
  }
  return(df)
}
