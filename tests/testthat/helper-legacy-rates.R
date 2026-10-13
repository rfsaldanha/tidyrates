# Golden outputs from epitools 0.5-10.1, evaluated with R 4.5.0.
# Source: https://github.com/cran/epitools/tree/0.5-10.1
# Numeric fixtures only: tests do not install or load epitools.
legacy_rates <- list(ordinary = list(count = c(10, 20, 30), pop = c(1000, 2000, 
5000), stdcount = c(12, 15, 42), stdpop = c(1500, 2500, 4000), 
    direct = c(crude.rate = 0.0075, adj.rate = 0.008, lci = 0.00604550945286944, 
    uci = 0.0104445495210341), indirect = c(crude.rate = 0.0075, 
    adj.rate = 0.00713793103448276, lci = 0.00554220646807307, 
    uci = 0.00919310021135798)), sparse = list(count = c(0, 0, 
1), pop = c(100, 200, 300), stdcount = c(1, 2, 3), stdpop = c(300, 
200, 100), direct = c(crude.rate = 0.00166666666666667, adj.rate = 0.000555555555555556, 
lci = 1.40654488801611e-05, uci = 0.0188420433849577), indirect = c(crude.rate = 0.00166666666666667, 
adj.rate = 0.000882352941176471, lci = 0.000124291318317545, 
uci = 0.00626388651549823)), zero = list(count = c(0, 0, 0), 
    pop = c(100, 200, 300), stdcount = c(1, 2, 3), stdpop = c(300, 
    200, 100), direct = c(crude.rate = 0, adj.rate = 0, lci = NaN, 
    uci = 0.0184443972705697), indirect = c(crude.rate = 0, adj.rate = 0, 
    lci = 0, uci = NaN)), single = list(count = 5, pop = 1000, 
    stdcount = 10, stdpop = 2000, direct = c(crude.rate = 0.005, 
    adj.rate = 0.005, lci = 0.00162348639011842, uci = 0.0116683320793227
    ), indirect = c(crude.rate = 0.005, adj.rate = Inf, lci = Inf, 
    uci = Inf)), zero_weight = list(count = c(10, 20, 30), pop = c(1000, 
2000, 5000), stdcount = c(0, 15, 42), stdpop = c(0, 2500, 4000
), direct = c(crude.rate = 0.0075, adj.rate = 0.00753846153846154, 
lci = 0.0055504596583525, uci = 0.01005210332655), indirect = c(crude.rate = 0.0075, 
adj.rate = NaN, lci = NaN, uci = NaN)), zero_population = list(
    count = c(0, 20, 30), pop = c(0, 2000, 5000), stdcount = c(12, 
    15, 42), stdpop = c(1500, 2500, 4000), direct = c(crude.rate = 0.00714285714285714, 
    adj.rate = NaN, lci = NaN, uci = NaN), indirect = c(crude.rate = 0.00714285714285714, 
    adj.rate = 0.00668604651162791, lci = 0.00506747152240173, 
    uci = 0.00882160220497196)), missing = list(count = c(NA, 
20, 30), pop = c(1000, 2000, 5000), stdcount = c(12, 15, 42), 
    stdpop = c(1500, 2500, 4000), direct = c(crude.rate = NA_real_, 
    adj.rate = NA_real_, lci = NA_real_, uci = NA_real_), indirect = c(crude.rate = NA_real_, 
    adj.rate = NA_real_, lci = NA_real_, uci = NA_real_)), large = list(
    count = c(1e+06, 2e+06, 3e+06), pop = c(1e+09, 2e+09, 5e+09
    ), stdcount = c(1e+06, 2e+06, 4e+06), stdpop = c(1.5e+09, 
    2.5e+09, 4e+09), direct = c(crude.rate = 0.00075, adj.rate = 8e-04, 
    lci = 0.000799338420307551, uci = 0.000800662037196092), 
    indirect = c(crude.rate = 0.00075, adj.rate = 0.000722477064220183, 
    lci = 0.000721899204010081, uci = 0.000723055386991292))) 
