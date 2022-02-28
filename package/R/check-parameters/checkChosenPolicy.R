checkChosenPolicy <- function(policy) {
  if (policy > 0 && policy <= nrow(policies)) {
    message("Chosen policy: ", policies$policy[policy])
  } else {
    stop("Wrong policy index. Choose between 1 and ", nrow(policies))
  }
}
