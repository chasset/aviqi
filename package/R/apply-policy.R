incErrorsPolicy <- function(policy) {
  policies$hitted[policy] <- policies$hitted[policy] + 1
}

#' @export
stopOrGo <- function(df, policy) {
  if (policies$hitted[policy] > 0) stop(policies$policy[policy], "has been hitted ", policies$hitted[policy], " times")
  df
}
