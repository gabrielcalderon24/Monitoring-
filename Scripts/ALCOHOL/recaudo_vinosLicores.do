// Definir nuevamente la carpeta para leer archivos de cada departamento //
local dptos "$carpetaMadre/Data/dptos_alcohol"
clear all
set obs 1
gen uno=1

tempfile tempo
save `tempo', replace


local Chip : dir "`dptos'" files "*.xls"
foreach file in `Chip' {
	import excel using "`dptos'/`file'", sheet("reporte pag 1") cellrange(A10) firstrow clear
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

// Filtrar por códigos específicos
// No incluyo "TI.A.1.15 " porque ya incluyen las subdivisiones de recuado de IVA y puede haber doble contabilidad 

keep if inlist(CODIGO, ///
    "TI.A.1.14.1.1 ", ///
    "TI.A.1.14.1.2 ", ///
    "TI.A.1.14.1.4 ", ///   
    "TI.A.1.14.2.1 ", ///   
    "TI.A.1.14.2.2 ", ///
    "TI.A.1.14.2.3 ", ///
    "TI.A.1.15.1 " , ///   
    "TI.A.1.15.2 ", ///
    "TI.A.1.15.3 " ///
)

// No se incluye cerveza en esta estimación, las dinámicas impositivas son un poco distintas //

collapse (sum) recaudoefectivopesos recaudoefectivomiles , by(year CODIGO NOMBRE) 
// Excel para tener la contabilidad de acuerdo a cada recaudo específico por año ///  
export excel using "$carpetaMadre/Data/Created data/recuados_vinoLicores.xlsx", firstrow(variables) replace

/// Suma total por año ///
collapse (sum) recaudoefectivomiles recaudoefectivopesos, by(year)

// En billones //
replace recaudoefectivomiles=recaudoefectivomiles/1000000000 
replace recaudoefectivopesos=recaudoefectivopesos/1000000000000 

gen recaudobillones=. 
replace recaudobillones= recaudoefectivomiles if year<2017 
replace recaudobillones= recaudoefectivopesos if year>=2017 
drop if year==2009 | year==2008
drop recaudoefectivomiles 
drop recaudoefectivopesos

save "$carpetaMadre/Data/Created data/recaudo_vinosLicores", replace 
