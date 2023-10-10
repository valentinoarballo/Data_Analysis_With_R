# Importo la libreria ggplot2
library(ggplot2)

# Asignacion de los datos en una variable, TRUE por que la primer linea son los titulos y "," porque se separan por ,
DB <- read.csv("/home/dyz/itec/matematica/PCU332510332510.csv", TRUE, ",")

# Ejemplo de como se ve la informacion en el csv
head(DB)

# Recupero las fechas y los indices de precios de produccion
DateDB <- as.Date(DB$Date)
Price <- (DB$ProducerPriceIndex)

# Creo un data frame con los datos anteriormente recuperados
data <- data.frame(Price,DateDB)

# Hago el grafico de regresion lineal
ggplot(data=data, aes(x=DateDB, y=Price)) +
  geom_point(size = 0.1) + 
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Puntos de precio de produccion de hardware en estados unidos frente a el paso del tiempo",
       x = "Fecha",
       y = "Indice de precios de produccion")

# Para usar cor.tests
DateDB_numeric <- as.numeric(DateDB)
# Veo si hay corelaccion entre las variables
print(cor.test(Price, DateDB_numeric))

# Ajusto un modelo de regresion lineal en base a los datos
model <- lm(Price ~ DateDB, data = DB)
summary(model)


# modelo de prediccion 
datosNuevos <- data.frame(DateDB = as.Date("2029-01-01"))
datosNuevos
predict(model, datosNuevos)


rm(list=ls())


# Crea un nuevo marco de datos con las fechas futuras para las que quieres hacer predicciones
future_DateDBs <- seq(from = as.Date("2024-01-01"), by = "month", length.out = 24)
future_DateDBs

# Usa tu modelo para hacer predicciones para estas fechas futuras
predict(model,future_DateDBs)

predictions
# Añade estas predicciones a tu marco de datos original
data_future <- rbind(data, future_data)
data_future$Predicted_Price <- c(rep(NA, nrow(data)), predictions)

# Haz un gráfico de regresión lineal con los datos originales y las predicciones
ggplot(data=data_future, aes(x=DateDB)) +
  geom_point(aes(y=Price), size = 0.1) + 
  geom_line(aes(y=Predicted_Price), color = "red") +
  labs(title = "Puntos de precio de produccion de hardware en estados unidos frente a el paso del tiempo",
       x = "Fecha",
       y = "Indice de precios de produccion")




