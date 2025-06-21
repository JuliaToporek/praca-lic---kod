library(geodata)
library(raster)

setwd('c:/Users/Lenovo/Documents/test')

#wczytanie pobranych warstw do zmiennych
bio1_stack <-stack("./1.4_mid_holocene_layers_uncropped/cc/ccmidbi1.tif")
bio2_stack <-stack("./1.4_mid_holocene_layers_uncropped/cc/ccmidbi2.tif")
bio3_stack <-stack("./1.4_mid_holocene_layers_uncropped/cc/ccmidbi3.tif")
bio4_stack <-stack("./1.4_mid_holocene_layers_uncropped/cc/ccmidbi4.tif")
bio5_stack <-stack("./1.4_mid_holocene_layers_uncropped/cc/ccmidbi5.tif")
bio6_stack <-stack("./1.4_mid_holocene_layers_uncropped/cc/ccmidbi6.tif")
bio7_stack <-stack("./1.4_mid_holocene_layers_uncropped/cc/ccmidbi7.tif")
bio8_stack <-stack("./1.4_mid_holocene_layers_uncropped/cc/ccmidbi8.tif")
bio9_stack <-stack("./1.4_mid_holocene_layers_uncropped/cc/ccmidbi9.tif")
bio10_stack <-stack("./1.4_mid_holocene_layers_uncropped/cc/ccmidbi10.tif")
bio11_stack <-stack("./1.4_mid_holocene_layers_uncropped/cc/ccmidbi11.tif")
bio12_stack <-stack("./1.4_mid_holocene_layers_uncropped/cc/ccmidbi12.tif")
bio13_stack <-stack("./1.4_mid_holocene_layers_uncropped/cc/ccmidbi13.tif")
bio14_stack <-stack("./1.4_mid_holocene_layers_uncropped/cc/ccmidbi14.tif")
bio15_stack <-stack("./1.4_mid_holocene_layers_uncropped/cc/ccmidbi15.tif")
bio16_stack <-stack("./1.4_mid_holocene_layers_uncropped/cc/ccmidbi16.tif")
bio17_stack <-stack("./1.4_mid_holocene_layers_uncropped/cc/ccmidbi17.tif")
bio18_stack <-stack("./1.4_mid_holocene_layers_uncropped/cc/ccmidbi18.tif")
bio19_stack <-stack("./1.4_mid_holocene_layers_uncropped/cc/ccmidbi19.tif")

#przycięcie warstw do wybranego zakresu
bio1_stack_cropped <- crop(bio1_stack, extent(63,80,36.5,47))
bio2_stack_cropped <- crop(bio2_stack, extent(63,80,36.5,47))
bio3_stack_cropped <- crop(bio3_stack, extent(63,80,36.5,47))
bio4_stack_cropped <- crop(bio4_stack, extent(63,80,36.5,47))
bio5_stack_cropped <- crop(bio5_stack, extent(63,80,36.5,47))
bio6_stack_cropped <- crop(bio6_stack, extent(63,80,36.5,47))
bio7_stack_cropped <- crop(bio7_stack, extent(63,80,36.5,47))
bio8_stack_cropped <- crop(bio8_stack, extent(63,80,36.5,47))
bio9_stack_cropped <- crop(bio9_stack, extent(63,80,36.5,47))
bio10_stack_cropped <- crop(bio10_stack, extent(63,80,36.5,47))
bio11_stack_cropped <- crop(bio11_stack, extent(63,80,36.5,47))
bio12_stack_cropped <- crop(bio12_stack, extent(63,80,36.5,47))
bio13_stack_cropped <- crop(bio13_stack, extent(63,80,36.5,47))
bio14_stack_cropped <- crop(bio14_stack, extent(63,80,36.5,47))
bio15_stack_cropped <- crop(bio15_stack, extent(63,80,36.5,47))
bio16_stack_cropped <- crop(bio16_stack, extent(63,80,36.5,47))
bio17_stack_cropped <- crop(bio17_stack, extent(63,80,36.5,47))
bio18_stack_cropped <- crop(bio18_stack, extent(63,80,36.5,47))
bio19_stack_cropped <- crop(bio19_stack, extent(63,80,36.5,47))

writeRaster(bio1_stack_cropped, filename="1.4_mid_holocene_layers_cropped/cc/bio_1.tif", overwrite=TRUE )
writeRaster(bio1_stack_cropped$memidbi1, filename="1.4_asc_mid_holocene_layers_cropped/cc/bio_1.asc", format="ascii", overwrite=TRUE)

writeRaster(bio2_stack_cropped, filename="1.4_mid_holocene_layers_cropped/cc/bio_2.tif", overwrite=TRUE )
writeRaster(bio2_stack_cropped$memidbi2, filename="1.4_asc_mid_holocene_layers_cropped/cc/bio_2.asc", format="ascii", overwrite=TRUE)

writeRaster(bio3_stack_cropped, filename="1.4_mid_holocene_layers_cropped/cc/bio_3.tif", overwrite=TRUE )
writeRaster(bio3_stack_cropped$memidbi3, filename="1.4_asc_mid_holocene_layers_cropped/cc/bio_3.asc", format="ascii", overwrite=TRUE)

writeRaster(bio4_stack_cropped, filename="1.4_mid_holocene_layers_cropped/cc/bio_4.tif", overwrite=TRUE )
writeRaster(bio4_stack_cropped$memidbi4, filename="1.4_asc_mid_holocene_layers_cropped/cc/bio_4.asc", format="ascii", overwrite=TRUE)

writeRaster(bio5_stack_cropped, filename="1.4_mid_holocene_layers_cropped/cc/bio_5.tif", overwrite=TRUE )
writeRaster(bio5_stack_cropped$memidbi5, filename="1.4_asc_mid_holocene_layers_cropped/cc/bio_5.asc", format="ascii", overwrite=TRUE)

writeRaster(bio6_stack_cropped, filename="1.4_mid_holocene_layers_cropped/cc/bio_6.tif", overwrite=TRUE )
writeRaster(bio6_stack_cropped$memidbi6, filename="1.4_asc_mid_holocene_layers_cropped/cc/bio_6.asc", format="ascii", overwrite=TRUE)

writeRaster(bio7_stack_cropped, filename="1.4_mid_holocene_layers_cropped/cc/bio_7.tif", overwrite=TRUE )
writeRaster(bio7_stack_cropped$memidbi7, filename="1.4_asc_mid_holocene_layers_cropped/cc/bio_7.asc", format="ascii", overwrite=TRUE)

writeRaster(bio8_stack_cropped, filename="1.4_mid_holocene_layers_cropped/cc/bio_8.tif", overwrite=TRUE )
writeRaster(bio8_stack_cropped$memidbi8, filename="1.4_asc_mid_holocene_layers_cropped/cc/bio_8.asc", format="ascii", overwrite=TRUE)

writeRaster(bio9_stack_cropped, filename="1.4_mid_holocene_layers_cropped/cc/bio_9.tif", overwrite=TRUE )
writeRaster(bio9_stack_cropped$memidbi9, filename="1.4_asc_mid_holocene_layers_cropped/cc/bio_9.asc", format="ascii", overwrite=TRUE)

writeRaster(bio10_stack_cropped, filename="1.4_mid_holocene_layers_cropped/cc/bio_10.tif", overwrite=TRUE )
writeRaster(bio10_stack_cropped$memidbi10, filename="1.4_asc_mid_holocene_layers_cropped/cc/bio_10.asc", format="ascii", overwrite=TRUE)

writeRaster(bio11_stack_cropped, filename="1.4_mid_holocene_layers_cropped/cc/bio_11.tif", overwrite=TRUE )
writeRaster(bio11_stack_cropped$memidbi11, filename="1.4_asc_mid_holocene_layers_cropped/cc/bio_11.asc", format="ascii", overwrite=TRUE)

writeRaster(bio12_stack_cropped, filename="1.4_mid_holocene_layers_cropped/cc/bio_12.tif", overwrite=TRUE )
writeRaster(bio12_stack_cropped$memidbi12, filename="1.4_asc_mid_holocene_layers_cropped/cc/bio_12.asc", format="ascii", overwrite=TRUE)

writeRaster(bio13_stack_cropped, filename="1.4_mid_holocene_layers_cropped/cc/bio_13.tif", overwrite=TRUE )
writeRaster(bio13_stack_cropped$memidbi13, filename="1.4_asc_mid_holocene_layers_cropped/cc/bio_13.asc", format="ascii", overwrite=TRUE)

writeRaster(bio14_stack_cropped, filename="1.4_mid_holocene_layers_cropped/cc/bio_14.tif", overwrite=TRUE )
writeRaster(bio14_stack_cropped$memidbi14, filename="1.4_asc_mid_holocene_layers_cropped/cc/bio_14.asc", format="ascii", overwrite=TRUE)

writeRaster(bio15_stack_cropped, filename="1.4_mid_holocene_layers_cropped/cc/bio_15.tif", overwrite=TRUE )
writeRaster(bio15_stack_cropped$memidbi15, filename="1.4_asc_mid_holocene_layers_cropped/cc/bio_15.asc", format="ascii", overwrite=TRUE)

writeRaster(bio16_stack_cropped, filename="1.4_mid_holocene_layers_cropped/cc/bio_16.tif", overwrite=TRUE )
writeRaster(bio16_stack_cropped$memidbi16, filename="1.4_asc_mid_holocene_layers_cropped/cc/bio_16.asc", format="ascii", overwrite=TRUE)

writeRaster(bio17_stack_cropped, filename="1.4_mid_holocene_layers_cropped/cc/bio_17.tif", overwrite=TRUE )
writeRaster(bio17_stack_cropped$memidbi17, filename="1.4_asc_mid_holocene_layers_cropped/cc/bio_17.asc", format="ascii", overwrite=TRUE)

writeRaster(bio18_stack_cropped, filename="1.4_mid_holocene_layers_cropped/cc/bio_18.tif", overwrite=TRUE )
writeRaster(bio18_stack_cropped$memidbi18, filename="1.4_asc_mid_holocene_layers_cropped/cc/bio_18.asc", format="ascii", overwrite=TRUE)

writeRaster(bio19_stack_cropped, filename="1.4_mid_holocene_layers_cropped/cc/bio_19.tif", overwrite=TRUE )
writeRaster(bio19_stack_cropped$memidbi19, filename="1.4_asc_mid_holocene_layers_cropped/cc/bio_19.asc", format="ascii", overwrite=TRUE)

#tworzymy zmienną typu raster stack ze wszytskimi przyciętymi warstwami
Expl <- raster::stack(c(
  bio_1 <- raster("1.4_mid_holocene_layers_cropped/cc/bio_1.tif"),
  bio_2 <- raster("1.4_mid_holocene_layers_cropped/cc/bio_2.tif"),
  bio_3 <- raster("1.4_mid_holocene_layers_cropped/cc/bio_3.tif"),
  bio_4 <- raster("1.4_mid_holocene_layers_cropped/cc/bio_4.tif"),
  bio_5 <- raster("1.4_mid_holocene_layers_cropped/cc/bio_5.tif"),
  bio_6 <- raster("1.4_mid_holocene_layers_cropped/cc/bio_6.tif"),
  bio_7 <- raster("1.4_mid_holocene_layers_cropped/cc/bio_7.tif"),
  bio_8 <- raster("1.4_mid_holocene_layers_cropped/cc/bio_8.tif"),
  bio_9 <- raster("1.4_mid_holocene_layers_cropped/cc/bio_9.tif"),
  bio_10 <- raster("1.4_mid_holocene_layers_cropped/cc/bio_10.tif"),
  bio_11 <- raster("1.4_mid_holocene_layers_cropped/cc/bio_11.tif"),
  bio_12 <- raster("1.4_mid_holocene_layers_cropped/cc/bio_12.tif"),
  bio_13 <- raster("1.4_mid_holocene_layers_cropped/cc/bio_13.tif"),
  bio_14 <- raster("1.4_mid_holocene_layers_cropped/cc/bio_14.tif"),
  bio_15 <- raster("1.4_mid_holocene_layers_cropped/cc/bio_15.tif"),
  bio_16 <- raster("1.4_mid_holocene_layers_cropped/cc/bio_16.tif"),
  bio_17 <- raster("1.4_mid_holocene_layers_cropped/cc/bio_17.tif"),
  bio_18 <- raster("1.4_mid_holocene_layers_cropped/cc/bio_18.tif"),
  bio_19 <- raster("1.4_mid_holocene_layers_cropped/cc/bio_19.tif")))

#nadajemy właściwe nazwy
for (i in 1:19) {
  Expl@layers[[i]]@data@names <- paste("bio_",i, sep='')
}

#macierz korelacji pearsona dla całych warstw
cor_Expl=layerStats(Expl, 'pearson', na.rm=T)
cor_matrix=cor_Expl$'pearson correlation coefficient'
cor_matrix

library(ggcorrplot)
ggcorrplot(cor_matrix, hc.order = TRUE, type = "lower", lab = TRUE)

#wczytanie koordynatów punktów występowania gatunku
points <- read.csv("karataviensis_omeurrences.csv", header = T)
points_no_1 <- subset(points, select=(-1))

#wyekstrahowanie wartości zmiennych bioklimatycznych z punktów, w których zaobserwowano gatunek
extracted <-extract(Expl, points_no_1)

#macierz korelacji liniowej dla punktów występowania Stipa Karataviensis
library(psych)
pairs.panels(extracted, scale=T)
