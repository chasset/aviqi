test_that("Usual cases", {
  expect_equal(getColumnNames(FALSE, "catalog"), c("price", "name", "ean"))
  expect_equal(getColumnNames(TRUE, "catalog"), c("id" ,"price", "name", "ean"))
  expect_equal(getColumnNames(FALSE, "orders"), c("orderId", "date"))
  expect_equal(getColumnNames(TRUE, "orders"), c("id" ,"orderId", "date"))
  expect_equal(getColumnNames(FALSE, "details"), c("orderId", "quantity", "ean"))
  expect_equal(getColumnNames(TRUE, "details"), c("id" ,"orderId", "quantity", "ean"))
})

test_that("Wrong table parameter", {
  # NULL values
  expect_null(getColumnNames(FALSE, NULL))
  expect_null(getColumnNames(TRUE, NULL))
  # Wrong table name
  expect_null(getColumnNames(FALSE, "fake"))
  expect_null(getColumnNames(FALSE, ""))
  expect_null(getColumnNames(TRUE, "fake"))
  expect_null(getColumnNames(TRUE, ""))
})

test_that("Wrong hasIds parameter", {
  expect_null(getColumnNames(NULL, "catalog"))
  expect_null(getColumnNames("TRUE", "catalog"))
  expect_null(getColumnNames(0, "catalog"))
  expect_null(getColumnNames(1, "catalog"))
})

test_that("Wrong hasIds and table parameter", {
  expect_null(getColumnNames(NA, NA))
  expect_null(getColumnNames(NULL, NULL))
  expect_null(getColumnNames(NULL, ""))
})
