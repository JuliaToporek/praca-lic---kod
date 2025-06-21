Plik "przycinanie_map_kod.R" zawiera kod wykorzystany do przycięcia map zmiennych bioklimatycznych do rozważanego obszaru geograficznego.
Znajduje się w nim również fragment użyty do wygenerowania macierzy korelacji liniowej zmiennych. 

Plik "modelowanie_kod.R" zawiera kod wykorzystany do modelowania niszy ekologicznej. 
W kodzie tym wybrane są ustawienia funkcji do modelowania zespołowego dla klimatu w przeszłości.
Modelowanie zespołowe dla przyszłych czasów przeprowadzono za pomocą tego samego kodu z użyciem odpowiednio innych warstw bioklimatycznych, a w ustawieniach funkcji BIOMOD_Modeling() ustawiono w parametrze 'models' tylko 4 wybrane algorytmy ('GBM', 'MARS', 'GAM', 'MAXENT'). Podczas modelowania z użyciem samego algorytmu MaxEnt, w prarametrze 'models' podano tylko 'MAXENT'.
