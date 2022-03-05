library(ruta)
library(purrr)

mnist = keras::dataset_mnist()

x_train <- keras::array_reshape(
  mnist$train$x, c(dim(mnist$train$x)[1], 784)
) / 255.0
x_test <- keras::array_reshape(
  mnist$test$x, c(dim(mnist$test$x)[1], 784)
) / 255.0

network <-
  input() +
  dense(256, "elu") +
  variational_block(10, seed = 42) +
  dense(256, "elu") +
  output("sigmoid")
learner <- autoencoder_variational(network, loss = "binary_crossentropy")
model <- train(learner, x_train, epochs = 10)

samples <- model %>% generate(dimensions = c(8, 5), side = 6, fixed_values = 0.99)
plot_matrix(samples)


plot_digit <- function(digit, ...) {
  image(keras::array_reshape(digit, c(28, 28), "F")[, 28:1], xaxt = "n", yaxt = "n", col=gray((255:0)/255), ...)
}

plot_matrix <- function(digits) {
  n <- dim(digits)[1]
  layout(
    matrix(1:n, byrow = F, nrow = sqrt(n))
  )
  
  for (i in 1:n) {
    par(mar = c(0,0,0,0) + .2)
    plot_digit(digits[i, ])
  }
}

plot_row <- function(digits) {
  n <- dim(digits)[1]
  layout(
    matrix(1:n, byrow = F, nrow = 1)
  )
  
  for (i in 1:n) {
    par(mar = c(0,0,0,0) + .2)
    plot_digit(digits[i, ])
  }
}

twodigit_enc <- model %>% encode(x_test[c(24,22),])
interpolation <- t(sapply(seq(0,1,0.2), function(t) t * twodigit_enc[1,] + (1 - t) * twodigit_enc[2,]))
dec <- model %>% decode(interpolation)
plot_row(dec)
