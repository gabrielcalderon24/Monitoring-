
// IC al 95% para consumo total de cigarrillos (Unidades)
// según la ENCSP 2008, 2013 y 2019

/////////////////////
///// ENCSP 2008 //// 
///////////////////// 

capture program drop myboot
program define myboot, rclass
    preserve 
	
keep p26 p26a p27 exp
rename p26 prevalencia_mensual
rename p26a dias_mes 
rename  p27 consumo_diario 
destring prevalencia_mensual, replace
destring consumo_diario, replace 
// Si no ha fumado en los últimos doce meses, saltan las preguntas 26, 26a y 27. Nos interesa los que han fumado en el último mes para la prevalencia mensual, p26=1
keep if prevalencia_mensual==1

/// Hacemos la aleatorización para determinar el consumo planteada por Paraje (2019) ////
gen consumo_aleatorizacion=1 if consumo_diario==1 
replace consumo_aleatorizacion= runiformint(1,5) if consumo_diario==2  
replace consumo_aleatorizacion= runiformint(6,10) if consumo_diario==3  
replace consumo_aleatorizacion= runiformint(11,20) if consumo_diario==4  
replace consumo_aleatorizacion= runiformint(20,74) if consumo_diario==5  

// Con los consumos diarios estimados ya se puede calcular el consumo mensual y de ahí se toma el promedio  // 
gen consumo_mensual= consumo_aleatorizacion*dias_mes
collapse (mean) consumo_mensual [aw=exp]

// Los datos de población y prevalencia salen del informe  sobre la encuesta /// 
// pob= 19764799
// prev= 0.1706 
// consumo total con la formula del documento de GAP ANALYSIS
gen consumototal_2008 = 0.1706*19764799*12*consumo_mensual 
sum consumototal_2008 // Guardamos como un escalar
return scalar total2008 =r(mean)
restore 
end 

use "$carpetaMadre\Data\ENCSP\final_2008.dta", clear 
bootstrap r(total2008), reps(1000) seed(123): myboot 
estat bootstrap, all 
// Guardar resultados en una matriz ///
matrix results2008=J(1,5,.)
matrix results2008[1,1]=2008
matrix results2008[1,2]= e(b)[1,1]
matrix results2008[1,3]= e(ci_percentile)[1,1]
matrix results2008[1,4]= e(ci_percentile)[2,1]  
matrix results2008[1,5]= 17.6
matrix list results2008


///////////////////////////////
////// Consumo ENCSP 2013 /////
//////////////////////////////

*use "C:\Users\gabri\Universidad del rosario\Control Tabaco Facultad Economica - Documentos\Gap\ENCSP_estimaciones\2013\BASE_COLOMBIA_2013_1.dta", clear
capture program drop myboot
program define myboot, rclass
    preserve 

keep p29 p30 p30a fexp3
destring p29, replace  
destring p30, replace
destring p30a, replace 

keep if p29==1 & p30 != 999 // quitando valores de 999 posibles errores
gen consumo_mensual_sin999= .
replace consumo_mensual_sin99= p30 * p30a  

// calcular el consumo promedio mensual ///
collapse (mean) consumo_mensual_sin99 [aw=fexp3]

/// Los datos de población y prevalencia salen del informe del DANE //  
* Población= 23317460 
* Prevalencia mensual= 12,95%
gen consumo_total_2013 = consumo_mensual_sin99 * 12 * 23317460 * 0.1295
sum consumo_total_2013 // Guardamos como un escalar
return scalar total2013 =r(mean)
restore 
end 
use "$carpetaMadre\Data\ENCSP\BASE_COLOMBIA_2013_1.dta",clear
bootstrap r(total2013), reps(1000) seed(123): myboot 
estat bootstrap, all  
/// Guardar en matriz ///
matrix results2013=J(1,5,.)
matrix results2013[1,1]=2013
matrix results2013[1,2]= e(b)[1,1]
matrix results2013[1,3]= e(ci_percentile)[1,1]
matrix results2013[1,4]= e(ci_percentile)[2,1]  
matrix results2013[1,5]= 12.95
matrix list results2013


//////////////////////////////////
//////// Consumo ENCSP 2019 //////
//////////////////////////////////

/// El capítulo no contiene los factores de expansión, por eso se usa el capítulo de "Personas seleccionadas", se quitan los datos con errores (99,9) para limpiar la base

// Unir para incluir FEX_C //
use "$carpetaMadre\Data\ENCSP\2019\e_capitulos.dta", clear
merge 1:1 DIRECTORIO using "$carpetaMadre\Data\ENCSP\2019\personas_seleccionadas.dta"

keep E_05 E_06  E_07 E_09 FEX_C
rename E_06 dias_mes
rename E_09 consumo_diario  
keep if consumo_diario!=99 & E_07!=9 & dias_mes!=99 

// Guardar la nueva base de datos con el merge para poder procesar el boot //
save "$carpetaMadre\Data\ENCSP\2019\tabaco_2019.dta", replace


********************************
** Estimación con IC ENCSP 2019 

capture program drop myboot
program define myboot, rclass
    preserve 
// Guardamos los promedios ponderados para cada grupo según el número de días que fuma al mes, esto para completar quienes no registran consumo diario 
keep if E_05==1
rename consumo_diario consumo_diario_mean
collapse (mean) consumo_diario_mean [pw=FEX_C], by(dias_mes)
tempfile promedios 
save `promedios', replace

// Volver a juntar los promedios ponderados según el número de días con la base original //
use "C:\Users\gabri\Universidad del rosario\Control Tabaco Facultad Economica - Documentos\Gap\ENCSP_estimaciones\2019\tabaco_2019.dta", clear 
keep if E_05==1 
merge m:1 dias_mes using `promedios'

/// completar registros de consumo diario con las medias calculadas y generar un consumo mensual promedio /// 
replace consumo_diario= consumo_diario_mean if missing(consumo_diario)
drop consumo_diario_mean 
drop _merge
gen consumo_mensual= consumo_diario*dias_mes
collapse (mean) consumo_mensual [pw=FEX_C] 

/// Los datos de prevalencia y población representada se obtienen del informe del DANE 
*Población= 23747000
*Prev_mensual= 0.098
gen consumo_total_2019 = consumo_mensual * 12 * 23747000 * 0.098
sum consumo_total_2019 // Guardamos como un escalar
return scalar total2019 =r(mean)
restore 
end 
use "$carpetaMadre\Data\ENCSP\2019\tabaco_2019.dta", clear
bootstrap r(total2019), reps(1000) seed(123): myboot 
estat bootstrap, all  
/// Guardar en matriz ///
matrix results2019=J(1,5,.)
matrix results2019[1,1]=2019
matrix results2019[1,2]= e(b)[1,1]
matrix results2019[1,3]= e(ci_percentile)[1,1]
matrix results2019[1,4]= e(ci_percentile)[2,1]
matrix results2019[1,5]= 9.8 
matrix list results2019


///// Juntar resultados de todos los años y convertir la matriz en base de datos /// 
clear
matrix matriz_anual= results2008\results2013\results2019
matrix list matriz_anual 
svmat matriz_anual, names(col) 
rename c1 año 
rename c2 estimacion_consumo
rename c3 IC_limite_inferior 
rename c4 IC_limite_superior 
rename c5 prevalencia

save "$carpetaMadre\Data\Created data\consumo_tabaco_encsp", replace

