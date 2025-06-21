options(java.parameters = "-Xmx12g" )
library(dismo)
library(ENMeval)
library(raster)
library(ENMTools)
library(ENMwizard)
library("spThin")
library(dplyr)
library(biomod2)
library(devtools)
library(rJava)
require(ggOceanMaps)
library(terra)
library(ggtext)
library(tidyterra)

#Wybieramy nieskorelowane przycięte warstwy bioklimatyczne
Warstwy_bio <- raster::stack(c(
  bio_2 <- raster("CURRENT_1.4/bio_asc_cropped/bio_2.asc"),
  bio_7 <- raster("CURRENT_1.4/bio_asc_cropped/bio_7.asc"),
  bio_8 <- raster("CURRENT_1.4/bio_asc_cropped/bio_8.asc"),
  bio_11 <- raster("CURRENT_1.4/bio_asc_cropped/bio_11.asc"),
  bio_19 <- raster("CURRENT_1.4/bio_asc_cropped/bio_19.asc")
))

#wczytujemy koordynaty gatunku
karataviensis.occ <- read.csv("karataviensis_occurrences.CSV",header = T, sep=",", dec=".")
head(karataviensis.occ)

#robimy z pliku z koordynatami listę
karataviensis.occ.list <- list(karataviensis = karataviensis.occ)

#tworzymy wielokątny obszar kalibracji obejmujący podane koordynaty
karataviensis.poly <- set_calibarea_b(karataviensis.occ.list, plot = T, save.pts = T, crs.set = "+init=epsg:3347") 

#tworzymy bufor wokół poligonu (szerokość w stopniach)
karataviensis.b <- buffer_b(karataviensis.poly, width = 2)

#przycinamy warstwy bioklimatyczne do poligonu z buforem, tworzymy zmienną typu raster brick z nimi wszystkimi
karataviensis.cut <- cut_calibarea_b(karataviensis.b, Warstwy_bio,numCores= 4)

#usuwamy lokalizacje S. karataviensis znajdujące się zbyt blisko siebie (thin.par w km)
thinned.dataset.karataviensis <- thin_b(loc.data.lst = list(karataviensis.occ), lat.col="lat", long.col = "long", spec.col = "species", thin.par=1)
karataviensis.locs <- load_thin_occ(thinned.dataset.karataviensis)
karataviensis.locs

#przeprowadzamy ewaluację ustawień maxenta dla naszych danych
ENMeval.karataviensis <- ENMwizard::ENMevaluate_b(karataviensis.locs, karataviensis.cut, RMvalues = seq(0.5, 5, 0.5),
                                                  fc = c("L", "P", "Q", "H", "LP", "LQ", "LH", "PQ", "PH", "QH", "LPQ", "LPH", "LQH", "PQH", "LPQH"),
                                                  method="checkerboard2", algorithm="maxent.jar",
                                                  numCores = 4,clamp = T)

save(ENMeval.karataviensis, file = "ENMeval.karataviensis.rdata")

#kalibrujemy modele maxent
mxnt.mdls.preds.karataviensis <- calib_mdl_b(ENMeval.o.l = ENMeval.karataviensis, 
                                             a.calib.l = karataviensis.cut, 
                                             mSel = c("LowAIC"),arg1 = "jackknife=true")

save(mxnt.mdls.preds.karataviensis, file = "mxnt.mdls.preds.karataviensis.rdata")

#Tworzymy poligon, wewnątrz którego analizować będzimy wpływ warstw bio na wystąpienia, przypisujemy do zmiennej poly.projection
poly.projection <- set_projarea_b(karataviensis.poly, mult = .1, buffer=FALSE)

#tworzymy raster stack z warstwami bio, żeby zadziałał jako argument w następnym kroku
predictors.l.kara <- list(current = Warstwy_bio)

pred.cut.l.kara <- cut_projarea_mscn_b(poly.projection, predictors.l.kara)

#-------------------------------------------------------------------------------------------------------------------------

#Tutaj wykorzystujemy kalibracje modelu maxenta dla naszego gatunku i przycięte do poligoinu Warstwy bio i tworzymy projekcję cross_forecast(?)
#są tu zapisane i pkt i background pkt
mxnt.mdls.preds.cf.kara <- proj_mdl_b(mxnt.mdls.preds.karataviensis, a.proj.l = pred.cut.l.kara, numCores=6)

save(mxnt.mdls.preds.cf.kara, file= "mxnt.mdls.preds.cf.kara.rdata")

#projekcja przy użyciu maxenta na obszar kalibracji
par(mfrow=c(1,1), mar=c(1,1,1,1))
plot(mxnt.mdls.preds.cf.kara[[1]][["mxnt.preds"]][["current"]])

writeRaster(mxnt.mdls.preds.cf.kara[[1]][["mxnt.preds"]][["current"]], filename = "mxnt.current.small_area.tif", format="GTiff", overwrite=TRUE)

write.csv(ENMeval.karataviensis[[1]]@occ.pts, "pointkara.csv")

#wczytujemy plik shapefile i przycinamy do rozważanego (docelowego) zakresu geograficznego
shp.asia <- shapefile("./shapefile/asia.shp")
extent.poly <- as(extent(63,80,37.5,47), "SpatialPolygons")

#Przechowujemy w zmiennej CRS system referencyjny dla naszej projekcji
CRS <-"+proj=longlat +datum=WGS84 +no_defs"

#przypisujemy poligonowi koordynaty geograficzne systemu WGS84
proj4string(extent.poly) <- CRS

shp2.asia <-clip_shapefile(shp.asia,limits=extent.poly)
shp2.asia
######

#nadajemy pierwszej kolumnie pliku "pointkara.csv" nazwę gatunku (karataviensis)
DataSpecies <- read.csv("pointkara.csv", header=TRUE, sep=",", dec=".")
View(DataSpecies)

myRespName <- 'karataviensis'
myResp <- as.numeric(DataSpecies[,myRespName])
myRespXY <- DataSpecies[,c("LON","LAT")]


#tworzymy pliki raster w formacie .asc z obszarem kalibracji, z którego brane będą punkty tła do algorytmu modelownaia
writeRaster(karataviensis.cut$karataviensis$bio_2, "CURRENT_1.4/current_cut/bio_2.asc", format="ascii", overwrite=TRUE)
writeRaster(karataviensis.cut$karataviensis$bio_7, "CURRENT_1.4/current_cut/bio_7.asc", format="ascii", overwrite=TRUE)
writeRaster(karataviensis.cut$karataviensis$bio_8, "CURRENT_1.4/current_cut/bio_8.asc", format="ascii", overwrite=TRUE)
writeRaster(karataviensis.cut$karataviensis$bio_11, "CURRENT_1.4/current_cut/bio_11.asc", format="ascii", overwrite=TRUE)
writeRaster(karataviensis.cut$karataviensis$bio_19, "CURRENT_1.4/current_cut/bio_19.asc", format="ascii", overwrite=TRUE)

#tworzymy z nich zmienną typu raster stack
myExpl_bg.kara <- raster::stack(c(
  bio_2 <- raster("CURRENT_1.4/current_cut/bio_2.asc"),
  bio_7 <- raster("CURRENT_1.4/current_cut/bio_7.asc"),
  bio_8 <- raster("CURRENT_1.4/current_cut/bio_8.asc"),
  bio_11 <- raster("CURRENT_1.4/current_cut/bio_11.asc"),
  bio_19 <- raster("CURRENT_1.4/current_cut/bio_19.asc")
))

#przypisujemy właściwe nazwy zmiennym bio
names(myExpl_bg.kara) <- names(Warstwy_bio)

#Tworzymy zmienną, która gromadzi wszystkie potrzebne dane wejściowe dla funkcji z pakieru biomod2, za pomocą której tworzymy modele, generujemy na tym etapie tzw. punkty tła )
myBiomodData.kara <- BIOMOD_FormatingData(resp.var = myResp, expl.var = myExpl_bg.kara, resp.xy = myRespXY, resp.name = myRespName, PA.nb.rep = 1,  PA.nb.absences = 10000, PA.strategy ='random')

#robimy przegląd wyników modelowania za pomocą maxent na małym obszarze i kierując się kryterium AIC 
#wybieramy te ustawienia maxent, przy których model miał najniższą wartość tej statystyki
View(ENMeval.karataviensis[[1]]@results) 

#najlepszymi ustawieniami okazły się być LQ_0.5, czyli linear, quadratic, beta-multiplier = 0.5

#wprowadzamy wybrane ustawienia maxent to zmiennej z ustawieniami funkcji do modelowania
myBiomodOption.kara <- BIOMOD_ModelingOptions(MAXENT = list(path_to_maxent.jar = "./maxent.jar", "/java", sep='',
                                                            memory_allocated = 8192,
                                                            background_data_dir = "CURRENT_1.4/current_cut",
                                                            maximumbackground = 'default',
                                                            maximumiterations = 500,
                                                            visible = F,
                                                            linear = T,
                                                            quadratic = T,
                                                            product = F,
                                                            threshold = F,
                                                            hinge = F,
                                                            lq2lqptthreshold = 80,
                                                            l2lqthreshold = 10,
                                                            hingethreshold = 15,
                                                            beta_threshold = -1,
                                                            beta_categorical = -1,
                                                            beta_lqp = -1,
                                                            beta_hinge = -1,
                                                            betamultiplier = 0.5,
                                                            defaultprevalence = 0.5))


#przeprowadzamy modelowanie z użyciem przygotowanych we wcześniejszych krokach danych, 
#na trenowanie algorytmu przeznaczamy 70% danych, pozostałe 30% posłuży do ewaluacji,
#jako miary jakości testu wybieramy TSS i ROC

myBiomodModelOut.kara <- BIOMOD_Modeling(bm.format = myBiomodData.kara,
                                          modeling.id = 'karataviensis_current.all.sel',
                                          models = c("GLM", "GBM", "GAM", "CTA", "ANN", "SRE", "FDA", "MARS", "RF", "MAXENT",
                                                     "MAXNET", "XGBOOST"),
                                          bm.options = myBiomodOption.kara,
                                          CV.strategy = 'random',
                                          CV.nb.rep = 10,
                                          CV.perc = 0.7, #ile pocent do trenowania
                                          metric.eval = c('TSS','ROC'),#miary jakości testu
                                          var.import = 2)

save(myBiomodModelOut.kara, file="myBiomodModelOut.kara.all.sel.rdata")

#stworzenie zmiennej z wynikami ewaluacji modeli (TSS, ROC) i zapisanie jako plik .csv
model.eva.kara <- get_evaluations(myBiomodModelOut.kara)
model.eva.kara
write.csv(model.eva.kara, file="model.eva.kara.all.sel.csv")

#wyodrębnienie poszczególnych statystyk testowych i zapisanie ich w osobnych plikach
tss_mxnt <- model.eva.kara[model.eva.kara$metric.eval == "TSS", "calibration"]
roc_mxnt <- model.eva.kara[model.eva.kara$metric.eval == "ROC", "calibration"]
save(tss_mxnt, file = "tss_mxnt.rdata")
write.csv(tss_mxnt, file = "tss_mxnt.csv")
save(roc_mxnt, file = "roc_mxnt.rdata")
write.csv(roc_mxnt, file = "roc_mxnt.csv")

#utworzenie zmiennej zawierającej dane o ważności warstw bioklimatycznych dla modelu
var_import <-get_variables_importance(myBiomodModelOut.kara)
var_import
write.csv(var_import, file="var_import.all.sel.csv")

#ŁĄCZENIE WSZYTSKICH MODELI Z BIOMOD W 1 ENSEMBLE MODEL

#EnsembleModeling - modelowanie zespołowe
myBiomodEM <- BIOMOD_EnsembleModeling(bm.mod = myBiomodModelOut.kara,
                                      models.chosen = 'all',
                                      em.by='all',
                                      metric.select = c('TSS','ROC'),
                                      metric.select.thresh = c(0.6,0.8),
                                      metric.eval = c('TSS','ROC'),
                                      prob.mean = T,
                                      prob.cv = F,
                                      prob.ci = F,
                                      prob.ci.alpha = 0.05,
                                      prob.median = T,
                                      committee.averaging = F,
                                      em.algo = 'EMmean', #zwykła średnia
                                      var.import = 2)

#ewaluacja modelu zespołowego
model.eva.EM.kara <- get_evaluations(myBiomodEM)
model.eva.EM.kara

#utworzenie zmiennej zawierającej dane o ważności warstw bioklimatycznych dla modelu zespołowego
var_import.EM.kara <-get_variables_importance(myBiomodEM)
var_import.EM.kara
write.csv(var_import, file="var_import.EM.kara.all.sel.csv")


save(myBiomodEM, file="myBiomodEM.kara.all.sel.rdata")
save(model.eva.EM.kara, file="model.eva.EM.kara.all.sel.rdata")
save(var_import.EM.kara, file="var_import.EM.kara.all.sel.rdata")

library(ggplot2)

#Projekcja modeli składowych na pełen interesujący nas zakres geograficzny

myBiomodProj.kara <- BIOMOD_Projection(
  bm.mod = myBiomodModelOut.kara,
  new.env = Warstwy_bio,
  proj.name = 'karataviensis_current.all.sel', 
  models.chosen = 'all', 
  metric.binary = c('TSS','ROC'), 
  compress = 'gzip', 
  build.clamping.mask = F, 
  output.format = '.tif',
  do.stack=T,
  nb.cpu = 4)

#modele występowania obecngo rozciągnięte na cały zakres modelowania
mod_proj_curr.kara <- get_predictions(myBiomodProj.kara)
plot(mod_proj_curr.kara)

#wyciągnięcie średniej z modeli
mean_proj_curr.kara <-mean(mod_proj_curr.kara)

#ostateczny model current, który jest średnią modeli
plot(mean_proj_curr.kara)
points(myRespXY, pch ="+", col = 'red')

writeRaster(mean_proj_curr.kara, "./mean_proj_curr.kara.all.sel.tif", overwrite=T)

save(myBiomodProj.kara, file="myBiomodProj.kara.all.sel.rdata")
save(mod_proj_curr.kara, file="mod_proj_curr.kara.all.sel.rdata")
save(mean_proj_curr.kara, file="mean_proj_curr.kara.all.sel.rdata")

myBiomodProj.kara


#model zespołowy dla pełnego zakresu geograficznego
myBiomodEF.kara <- BIOMOD_EnsembleForecasting(bm.em = myBiomodEM,
                                              bm.proj = myBiomodProj.kara,
                                              binary.meth =c('TSS','ROC'),
                                              proj.name = 'current_EM.all.sel')
proj_curr_Ensemble.kara <- get_predictions(myBiomodEF.kara)
proj_curr_Ensemble.kara
plot(proj_curr_Ensemble.kara)
plot(mean(proj_curr_Ensemble.kara))
points(myRespXY, pch ="+", col = 'red')


save(myBiomodEF.kara, file="CURRENT_1.4/myBiomodEF.all.sel.rdata")
save(proj_curr_Ensemble.kara, file="CURRENT_1.4/proj_curr_Ensemble.all.sel.rdata")

# PRZESZŁOŚĆ

#wczytanie warstw dla maksimum ostatniego zlodowacenia

Expl_lgcc.kara <- raster::stack(c(
  bio_2 <- raster("./lgmax/bio_layers/cc/bio_2.tif"),
  bio_7 <- raster("./lgmax/bio_layers/cc/bio_7.tif"),
  bio_8 <- raster("./lgmax/bio_layers/cc/bio_8.tif"),
  bio_11 <- raster("./lgmax/bio_layers/cc/bio_11.tif"),
  bio_19 <- raster("./lgmax/bio_layers/cc/bio_19.tif")))

Expl_lgcc.kara@layers[[1]]@data@names < "bio_2"
Expl_lgcc.kara@layers[[2]]@data@names <- "bio_7"
Expl_lgcc.kara@layers[[3]]@data@names <- "bio_8"
Expl_lgcc.kara@layers[[4]]@data@names <- "bio_11"
Expl_lgcc.kara@layers[[5]]@data@names <- "bio_19"


#Projekcja poszczególnych modeli na nowe warunki klimatyczne
myBiomodProj_lgcc.kara <- BIOMOD_Projection(
  bm.mod = myBiomodModelOut.kara,
  new.env = Expl_lgcc.kara,
  proj.name = 'lgcc_kara.all.sel', 
  models.chosen = 'all', 
  metric.binary = c('TSS','ROC'), 
  compress = 'gzip', 
  build.clamping.mask = F, 
  output.format = '.tif',
  do.stack=T,
  nb.cpu = 6)


mod_proj_lgcc.kara <- get_predictions(myBiomodProj_lgcc.kara)
plot(mod_proj_lgcc.kara)

save(myBiomodProj_lgcc.kara, file="myBiomodProj_lgcc.kara.all.sel.rdata")
save(mod_proj_lgcc.kara, file="mod_proj_lgcc.kara.all.sel.rdata")

#Predykcja na pełnym obszarze dla nowych warunków - model zespołowy
myBiomodEF_lgcc.kara <- BIOMOD_EnsembleForecasting(bm.em = myBiomodEM,
                                                   bm.proj = myBiomodProj_lgcc.kara,
                                                   binary.meth =c('TSS','ROC'),
                                                   proj.name = 'lgcc_karataviensis.all.sel',
                                                   total.consensus=TRUE)

proj_Ensemble_lgcc.kara <- get_predictions(myBiomodEF_lgcc.kara)
plot(mean(proj_Ensemble_lgcc.kara))
mean_fin <- mean(proj_Ensemble_lgcc.kara)
writeRaster(mean_fin, filename = "lgcc_proj.tif", overwrite = T)

points(myRespXY, pch ="+", col = 'red')
save(myBiomodEF_lgcc.kara, file="myBiomodEF_lgcc.kara.all.sel.rdata")
save(proj_Ensemble_lgcc.kara, file="proj_Ensemble_lgcc.kara.all.sel.rdata")


#holocen

#wczytanie warstw dla środkowego holocenu
Expl_holocc.kara <- raster::stack(c(
  bio_2 <- raster("./holocen/bio_layers/cc/bio_2.tif"),
  bio_7 <- raster("./holocen/bio_layers/cc/bio_7.tif"),
  bio_8 <- raster("./holocen/bio_layers/cc/bio_8.tif"),
  bio_11 <- raster("./holocen/bio_layers/cc/bio_11.tif"),
  bio_19 <- raster("./holocen/bio_layers/cc/bio_19.tif")))

Expl_holocc.kara@layers[[1]]@data@names < "bio_2"
Expl_holocc.kara@layers[[2]]@data@names <- "bio_7"
Expl_holocc.kara@layers[[3]]@data@names <- "bio_8"
Expl_holocc.kara@layers[[4]]@data@names <- "bio_11"
Expl_holocc.kara@layers[[5]]@data@names <- "bio_19"


#Projekcja modeli na nowe warstwy
myBiomodProj_holocc.kara <- BIOMOD_Projection(
  bm.mod = myBiomodModelOut.kara,
  new.env = Expl_holocc.kara,
  proj.name = 'holocc_kara.all.sel', 
  models.chosen = 'all', 
  metric.binary = c('TSS','ROC'), 
  compress = 'gzip', 
  build.clamping.mask = F, 
  output.format = '.tif',
  do.stack=T,
  nb.cpu = 6)


mod_proj_holocc.kara <- get_predictions(myBiomodProj_holocc.kara)
plot(mod_proj_holocc.kara)

save(myBiomodProj_holocc.kara, file="myBiomodProj_holocc.kara.all.sel.rdata")
save(mod_proj_holocc.kara, file="mod_proj_holocc.kara.all.sel.rdata")

#Projekcja modelu zespołowego na nowe warstwy
myBiomodEF_holocc.kara <- BIOMOD_EnsembleForecasting(bm.em = myBiomodEM,
                                                   bm.proj = myBiomodProj_holocc.kara,
                                                   binary.meth =c('TSS','ROC'),
                                                   proj.name = 'holocc_karataviensis.all.sel',
                                                   total.consensus=TRUE)

proj_Ensemble_holocc.kara <- get_predictions(myBiomodEF_holocc.kara)
plot(mean(proj_Ensemble_holocc.kara))
mean_fin4 <- mean(proj_Ensemble_holocc.kara)
writeRaster(mean_fin4, filename = "holocc_proj.tif", overwrite = T)

points(myRespXY, pch ="+", col = 'red')
save(myBiomodEF_holocc.kara, file="myBiomodEF_holocc.kara.all.sel.rdata")
save(proj_Ensemble_holocc.kara, file="proj_Ensemble_holocc.kara.all.sel.rdata")