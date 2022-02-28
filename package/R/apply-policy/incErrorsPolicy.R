incErrorsPolicy <- function(policy) {
  # voir les erreurs du niveau supérieur
  l <- nrow(policies)
  policies$hitted[policy] <- policies$hitted[policy] + 1
}
