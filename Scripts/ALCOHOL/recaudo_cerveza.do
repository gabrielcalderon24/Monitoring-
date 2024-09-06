local dptos_c "$carpetaMadre\Data\dptos_alcohol"
clear all
set obs 1
gen uno=1

tempfile tempo
save `tempo', replace

local chip_c : dir "`dptos_c'" files "*.xls"
foreach file in `chip_c' {
	import excel "`dptos_c'/`file'", sheet("reporte pag 1") cellrange(A10) firstrow clear
	gen nome="`file'"
	append using `tempo'
	save `tempo', replace
}
drop in 1
drop uno

// Generar los años a partir de la variable nome de cada archivo 
gen year_str=substr(nome,-6,2)
gen year = real("20" + year_str)
destring year, replace

// Para 2014, 2015 y 2016 no hay recaudo en pesos, solo en miles, cambiamos las comas por puntos y volvemos ambas variables númericas. Para 2022 son muy diferentes los rubros  
gen recaudoefectivopesos = subinstr(RECAUDOEFECTIVOPesos, ",", ".", .)
destring recaudoefectivopesos, replace
format recaudoefectivopesos %20.2f   
 
gen recaudoefectivomiles = subinstr(RECAUDOEFECTIVOMiles, ",", ".", .)
destring recaudoefectivomiles, replace
format recaudoefectivomiles %20.2f

// Filtrar por códigos específicos de cerveza 

keep if CODIGO == "TI.A.1.16 " | CODIGO == "TI.A.1.17 " 

/// Sumo para cada año específico // Tener en cuenta que antes de 2016 están en miles (no en pesos) 
collapse (sum) recaudoefectivomiles recaudoefectivopesos, by(year) 

// En billones //
replace recaudoefectivomiles=recaudoefectivomiles/1000000000 
replace recaudoefectivopesos=recaudoefectivopesos/1000000000000 
gen recaudobillones=. 
replace recaudobillones= recaudoefectivomiles if year <2017 
replace recaudobillones= recaudoefectivopesos if year>=2017
drop if year==2008 | year==2009 
drop recaudoefectivomiles 
drop recaudoefectivopesos

save "$carpetaMadre\Data\Created data\recaudo_cerveza.dta", replace
