"""
Este código tiene la función de agrubar, combinar, y extraer variables de dos bases de datos
para así poder exportar la base de datos en Excel.

authors: Juliana López
Laura Otalora
Isabella Perilla
"""
library(dplyr)
library(tidyr)
library(haven)
library(readxl)
library(writexl)
# 1. Cargar la base de tenderos
TenderosFU03_Publica <- read_dta("Monitoria-doing-economics/TenderosFU03_Publica.dta")

TenderosFU03_Publica <- TenderosFU03_Publica %>%
  mutate(Munic_Dept = as.character(Munic_Dept))

TenderosFU03_Publica.dta <- TenderosFU03_Publica %>%
  select(Munic_Dept, actG1, actG2, actG3, actG4, actG5, actG6, actG7, actG8, actG9, actG10, actG11, uso_internet)

Tenderos_Agrupado <- TenderosFU03_Publica %>%
  group_by(Munic_Dept) %>%
  summarise(across(starts_with("actG"), sum, na.rm = TRUE), 
            Uso_internet = sum(uso_internet, na.rm = TRUE))
  
Total_Poblacion_Municipios <- read_excel("C:/Users/moral/Downloads/Total_Poblacion_Municipios.xlsx")
Poblacion_Dane_Agrupada <- Total_Poblacion_Municipios %>%
  select(Munic_Dept, Poblacion) %>%
  mutate(Munic_Dept = as.character(Munic_Dept))

Tenderos_Agrupado <- Tenderos_Agrupado %>%
  mutate(Munic_Dept = as.character(Munic_Dept) %>% trimws())

Poblacion_Dane_Agrupada <- Poblacion_Dane_Agrupada %>%
  mutate(Munic_Dept = as.character(Munic_Dept) %>% trimws())

Base_Final_Wide <- Base_Final %>%
  pivot_longer(
    cols = -Munic_Dept,  # Convierte todas las columnas excepto Munic_Dept en dos columnas: nombre y valor
    names_to = "Actividad",  
    values_to = "Valor"
  ) %>%
  pivot_wider(
    names_from = Munic_Dept,  # Convierte los municipios en nombres de columna
    values_from = Valor       # Los valores de cada actividad se distribuyen en los municipios
  )

write_xlsx(Base_Final_Wide, "C:/Users/moral/Downloads/Base_Fina_Wide.xlsx")





