# Importo la libreria ggplot2
library(ggplot2)

file.choose()

# Asignacion de los datos en una variable, TRUE por que la primer linea son los titulos y "," porque se separan por ,
#DB <- read.csv("/home/valen/itec/matematica/Data_Analysis_With_R/PCU332510332510.csv", TRUE, ",")
DB <- read.csv("/home/valen/itec/matematica/Data_Analysis_With_R/copia2010.csv", TRUE, ",")

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
#  scale_x_continuous(limits = c(1980, 2030), breaks = seq(1980, 2030, by = 5)) +
#  scale_y_continuous(limits = c(0, 200), breaks = seq(0, 200, by = 25)) +
  labs(title = "Puntos de precio de produccion de hardware en estados unidos frente a el paso del tiempo",
     x = "Fecha",
     y = "Indice de precios de produccion") +
  theme_light()
  

# Para usar cor.tests
DateDB_numeric <- as.numeric(DateDB)
# Veo si hay corelaccion entre las variables
print(cor.test(Price, DateDB_numeric))

# Ajusto un modelo de regresion lineal en base a los datos
model <- lm(Price ~ DateDB, data = DB)
summary(model)


# Modelo de prediccion 
datosPredecidos1 <- data.frame(DateDB = as.Date("2012-03-01"))
datosPredecidos2 <- data.frame(DateDB = as.Date("2012-06-01"))
datosPredecidos3 <- data.frame(DateDB = as.Date("2013-01-01"))

pricePredict1 <- predict(model, datosPredecidos1)
pricePredict2 <- predict(model, datosPredecidos2)
pricePredict3 <- predict(model, datosPredecidos3)

prueba1 <- data.frame(Price = pricePredict1, DateDB = as.Date("2012-03-01"))
prueba2 <- data.frame(Price = pricePredict2, DateDB = as.Date("2012-06-01"))
prueba3 <- data.frame(Price = pricePredict3, DateDB = as.Date("2013-01-01"))

dataP <- rbind(data, prueba1, prueba2, prueba3)
dataP

predice:
1100 167.6459 2012-03-01
1101 168.3508 2012-06-01
1102 169.9906 2013-01-01

es:
2012-03-01,177.2
2012-06-01,178.3
2013-01-01,177.8



ggplot(data=dataP, aes(x=DateDB, y=Price)) +
  geom_point(size = 0.1) + 
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  #  scale_x_continuous(limits = c(1980, 2030), breaks = seq(1980, 2030, by = 5)) +
  #  scale_y_continuous(limits = c(0, 200), breaks = seq(0, 200, by = 25)) +
  labs(title = "prediccion",
       x = "Fecha",
       y = "Indice de precios de produccion") +
  theme_light()




rm(list=ls())

# Crea un nuevo marco de datos con las fechas futuras
# future_DateDBs <- seq(from = as.Date("2024-01-01"), by = "month", length.out = 24)



