library(ruta)
library(purrr)

encoded <- iris[, 1:4] %>% as.matrix() %>% autoencode(2, "robust")

colors <- colorspace::rainbow_hcl(3)
plot(encoded, col = colors[iris[, 5]], xlab = "V1", ylab = "V2", pch = 20)
legend(1, 2.6, legend = levels(iris[,5]), col = colors, pch = 20)
