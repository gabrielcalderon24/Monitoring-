*******************************************************
* Proporciones de consumo de acuerdo a la ENCSP 2019 
*******************************************************

// Para estimar el consumo de tabaco con la ECV, es fundamental completar los datos de consumo diario. Esto se puede realizar de acuerdo a las proporciones de consumo entre los distintos grupos de frecuencia semanal en la ENCSP 2019.

// Es decir, tomar el consumo promedio entre cada grupo y calcular las proporciones. Por ejemplo, quiénes fuman 1 día a la semana fuman en promedio cierta cantidad de cigarrillos en comparación a quiénes fuman 7 días a la semana según la ENSCP 2019.

// En tabaco_2019_proporciones se encuentran los datos ya procesados y estimados de la ENCSP 2019 con el fin de no tener que realizar el proceso nuevamente //
use "$carpetaMadre\Data\ENCSP\2019\tabaco_2019_proporciones.dta", clear 

// Calcular media de quienes fuman todos los días de la semana // 
keep if E_08==1 
collapse (mean) consumo_diario [pw=FEX_C], by(E_08) 
local mean_1 = consumo_diario  

// Proporciones entre cada grupo //
use "$carpetaMadre\Data\ENCSP\2019\tabaco_2019_proporciones.dta", clear 
collapse (mean) consumo_diario [aw=FEX_C], by(E_08)
gen proporciones = consumo_diario/`mean_1'

**** Resultados ****
* La proporción entre quienes fuman todos los días de la semana y quienes fuman algunos días es de 0.61
* Para los que fuman menos de una vez por semana es de 0.54
 

//////////////////////////////////////////
///// Consumo Tabaco ECV- IC al 95% /////
/////////////////////////////////////////
 
// Con el fin de agilizar el procesamiento de los datos se trabaja con los archivos <.derived> De igual forma los archivos originales del DANE se pueden encontrar en la carpeta "original" para cada año. 
 
 
/// Bootsrap e iteraciones por año ///
capture program drop myboot
program define myboot, rclass
    preserve
// Población representada // 
collapse (sum) FEX_C 
local pob2016= FEX_C 
// Volver a cargar la base //
use "$carpetaMadre\Data\ECV\ENCV2016\derived\Salud_derived.dta" , clear
keep P1706 P1706S1 P1706S1A1 FEX_C
rename P1706 prevalencia_semanal 
rename P1706S1 frecuencia_semanal 
rename P1706S1A1 consumo_diario  
replace prevalencia_semanal=0 if prevalencia_semanal==2
sum prevalencia_semanal [iw=FEX_C]
local prev2016=r(mean) // Calculo de la prevalencia
keep if prevalencia_semanal==1  
gen dias_semana=.
replace dias_semana=7 if frecuencia_semanal==1 
replace dias_semana=1 if frecuencia_semanal==3
replace dias_semana= runiformint(2,6) if frecuencia_semanal==2  
* Calculamos media para los que consumen diariamente *
summarize consumo_diario if frecuencia_semanal == 1, meanonly 
local mean_fuma_diario = r(mean)

* Completamos para los demás grupos de acuerdo a las proporciones estimadas anteriormente * 
gen consumo_diario_ajustado=.
replace consumo_diario_ajustado= consumo_diario if frecuencia_semanal==1
replace consumo_diario_ajustado= `mean_fuma_diario' * 0.61 if frecuencia_semanal==2 // fuman algunos días de la semana
replace consumo_diario_ajustado= `mean_fuma_diario' * 0.54 if frecuencia_semanal == 3 // Menos de una vez por semana

// Collapse para el consumo mensual promedio //
gen consumo_mensual= consumo_diario_ajustado*dias_semana*4.25 
collapse (mean) consumo_mensual [pw=FEX_C]
* Estimación clásica * 
gen consumo_total_2016= consumo_mensual*12*`pob2016'*`prev2016'  
// Guardamos el dato en un archivo temporal //
sum consumo_total_2016 
return scalar total2016 = r(mean)
restore 
end 
use "$carpetaMadre\Data\ECV\ENCV2016\derived\Salud_derived.dta" , clear
bootstrap r(total2016), reps(1000) seed(123): myboot 
estat bootstrap, all 

// Guardar los resultados en una matriz// 
matrix results2016=J(1,5,.)
matrix results2016[1,1]=2016
matrix results2016[1,2]= e(b)[1,1]
matrix results2016[1,3]= e(ci_percentile)[1,1]
matrix results2016[1,4]= e(ci_percentile)[2,1] 
matrix results2016[1,5]=e(se)[1,1]
matrix list results2016



//// 2017 ////
capture program drop myboot
program define myboot, rclass
    preserve
collapse (sum) FEX_C	
local pob2017=FEX_C	
use "$carpetaMadre\Data\ECV\ENCV2017\derived\Salud_derived.dta", clear
keep P1706 P1706S1 P1706S1A1 FEX_C
rename P1706 prevalencia_semanal 
rename P1706S1 frecuencia_semanal 
rename P1706S1A1 consumo_diario 
* Confirmamos que la codificación para frencuencia semanal es la misma *    
replace prevalencia_semanal=0 if prevalencia_semanal==2
sum prevalencia_semanal [iw=FEX_C]
local prev2017=r(mean) 
// Calculamos y completamos los días que fuma a la semana
keep if prevalencia_semanal==1  
gen dias_semana=. 
replace dias_semana=7 if frecuencia_semanal==1 
replace dias_semana=1 if frecuencia_semanal==3
replace dias_semana= runiformint(2,6) if frecuencia_semanal==2  
* Calculamos media para los que consumen diariamente *
summarize consumo_diario if frecuencia_semanal == 1, meanonly 
local mean_fuma_diario = r(mean)

* Completamos para los demás grupos de acuerdo a las proporciones estimadas anteriormente * 
gen consumo_diario_ajustado=.
replace consumo_diario_ajustado= consumo_diario if frecuencia_semanal==1
replace consumo_diario_ajustado= `mean_fuma_diario' * 0.61 if frecuencia_semanal==2 // Fuman algunos días de la semana
replace consumo_diario_ajustado= `mean_fuma_diario' * 0.54 if frecuencia_semanal == 3 // Menos de una vez por semana

// Collapse con el consumo mensual //
gen consumo_mensual= consumo_diario_ajustado*dias_semana*4.25 
collapse (mean) consumo_mensual [pw=FEX_C]

* Estimación consumo total * 
gen consumo_total_2017 = consumo_mensual*12*`pob2017'*`prev2017'
sum consumo_total_2017 
return scalar total2017 = r(mean)
restore
end 
use "$carpetaMadre\Data\ECV\ENCV2017\derived\Salud_derived.dta"	, clear
bootstrap r(total2017), reps(1000) seed(123): myboot 
estat bootstrap, all
// Guardar los resultados del bootstrap en una matriz//
matrix results2017=J(1,5,.)
matrix results2017[1,1]=2017
matrix results2017[1,2]= e(b)[1,1]
matrix results2017[1,3]= e(ci_percentile)[1,1]
matrix results2017[1,4]= e(ci_percentile)[2,1] 
matrix results2017[1,5]=e(se)[1,1]
matrix list results2017



//// 2018 /////
capture program drop myboot
program define myboot, rclass 
preserve
collapse (sum) FEX_C	
local pob2018=FEX_C	// Guardar el dato de población 
// Volver a cargar la base //
use "$carpetaMadre\Data\ECV\ENCV2018\derived\Salud_derived.dta", clear 
rename P1706 prevalencia_semanal 
rename P1706S1 frecuencia_semanal 
rename P1706S1A1 consumo_diario 
* Confirmamos que la codificación para frecuencia semanal es la misma *    
replace prevalencia_semanal=0 if prevalencia_semanal==2
sum prevalencia_semanal [iw=FEX_C]
local prev2018=r(mean) // Prevalencia 
keep if prevalencia_semanal==1  
gen dias_semana=. 
replace dias_semana=7 if frecuencia_semanal==1 
replace dias_semana=1 if frecuencia_semanal==3
replace dias_semana= runiformint(2,6) if frecuencia_semanal==2  
* Calcular la media para los que consumen diariamente *
summarize consumo_diario if frecuencia_semanal == 1, meanonly 
local mean_fuma_diario = r(mean)

* Completamos para los demás grupos de acuerdo a las proporciones estimadas anteriormente * 
gen consumo_diario_ajustado=.
replace consumo_diario_ajustado= consumo_diario if frecuencia_semanal==1
replace consumo_diario_ajustado= `mean_fuma_diario' * 0.61 if frecuencia_semanal==2 // Fuman algunos días de la semana
replace consumo_diario_ajustado= `mean_fuma_diario' * 0.54 if frecuencia_semanal == 3 // Menos de una vez por semana

// Collapse con el consumo mensual //
gen consumo_mensual= consumo_diario_ajustado*dias_semana*4.25 
collapse (mean) consumo_mensual [pw=FEX_C]

* Estimación consumo total * 
gen consumo_total_2018 = consumo_mensual*12*`pob2018'* `prev2018'
sum consumo_total_2018 
return scalar total2018 = r(mean)
restore 
end 
use "$carpetaMadre\Data\ECV\ENCV2018\derived\Salud_derived.dta"	, clear 
bootstrap r(total2018), reps(1000) seed(123): myboot 
estat bootstrap, all
// Armamos las matrices y guardamos los resultados //
matrix results2018=J(1,5,.)
matrix results2018[1,1]=2018
matrix results2018[1,2]= e(b)[1,1]
matrix results2018[1,3]= e(ci_percentile)[1,1]
matrix results2018[1,4]= e(ci_percentile)[2,1] 
matrix results2018[1,5]=e(se)[1,1]
matrix list results2018



//2019
capture program drop myboot
program define myboot, rclass 
preserve
collapse (sum) FEX_C 
local pob2019=FEX_C
// Volver a cargar la base //
use "$carpetaMadre\Data\ECV\ENCV2019\derived\Salud_derived.dta", clear
rename P3008S1 prevalencia_semanal 
rename P3008S1A1 frecuencia_semanal 
rename P3008S1A2 consumo_diario 
* Confirmamos que la codificación para frecuencia semanal es la misma *  
replace prevalencia_semanal=0 if prevalencia_semanal==2
sum prevalencia_semanal [iw=FEX_C]
local prev2019=r(mean) // Prevalencia   
keep if prevalencia_semanal==1  
gen dias_semana=. 
replace dias_semana=7 if frecuencia_semanal==1 
replace dias_semana=1 if frecuencia_semanal==3
replace dias_semana= runiformint(2,6) if frecuencia_semanal==2  
// Calculamos la media para los que consumen diariamente //
summarize consumo_diario if frecuencia_semanal == 1, meanonly 
local mean_fuma_diario = r(mean)

* Completamos para los demás grupos de acuerdo a las proporciones estimadas anteriormente * 
gen consumo_diario_ajustado=.
replace consumo_diario_ajustado= consumo_diario if frecuencia_semanal==1
replace consumo_diario_ajustado= `mean_fuma_diario' * 0.61 if frecuencia_semanal==2 // Algunos días a la semana
replace consumo_diario_ajustado= `mean_fuma_diario' * 0.54 if frecuencia_semanal == 3 // Menos de una vez por semana

// Estimar un consumo mensual //
gen consumo_mensual= consumo_diario_ajustado*dias_semana*4.25 
collapse (mean) consumo_mensual [pw=FEX_C]

* Estimación consumo total * 
gen consumo_total_2019= consumo_mensual*12*`pob2019' *`prev2019' 
sum consumo_total_2019 
return scalar total2019= r(mean)
restore 
end 
use "$carpetaMadre\Data\ECV\ENCV2019\derived\Salud_derived.dta", clear
bootstrap r(total2019), reps(1000) seed(123): myboot 
estat bootstrap, all
// Guardamos los resultados en una matriz ///
matrix results2019=J(1,5,.)
matrix results2019[1,1]=2019
matrix results2019[1,2]= e(b)[1,1]
matrix results2019[1,3]= e(ci_percentile)[1,1]
matrix results2019[1,4]= e(ci_percentile)[2,1] 
matrix results2019[1,5]=e(se)[1,1]
matrix list results2019



//2020//
capture program drop myboot
program define myboot, rclass 
preserve 
collapse (sum) FEX_C
local pob2020=FEX_C
// Volver a cargar la base //
use "$carpetaMadre\Data\ECV\ENCV2020\derived\Salud_derived.dta", clear
rename P3008S1 prevalencia_semanal 
rename P3008S1A1 frecuencia_semanal 
rename P3008S1A2 consumo_diario 
* Confirmamos que la codificación para frecuencia semanal es la misma *   
 replace prevalencia_semanal=0 if prevalencia_semanal==2
sum prevalencia_semanal [iw=FEX_C]
local prev2020=r(mean)    
keep if prevalencia_semanal==1  
gen dias_semana=. 
replace dias_semana=7 if frecuencia_semanal==1 
replace dias_semana=1 if frecuencia_semanal==3
replace dias_semana= runiformint(2,6) if frecuencia_semanal==2  

* Calculamos media para los que consumen diariamente *
summarize consumo_diario if frecuencia_semanal == 1, meanonly 
local mean_fuma_diario = r(mean)

* Completamos para los demás grupos de acuerdo a las proporciones estimadas anteriormente * 
gen consumo_diario_ajustado=.
replace consumo_diario_ajustado= consumo_diario if frecuencia_semanal==1
replace consumo_diario_ajustado= `mean_fuma_diario' * 0.61 if frecuencia_semanal==2 // Algunos días a la semana
replace consumo_diario_ajustado= `mean_fuma_diario' * 0.54 if frecuencia_semanal == 3 // Menos de una vez por semana 

// Collapse con consumo mensual//
gen consumo_mensual= consumo_diario_ajustado*dias_semana*4.25 
collapse (mean) consumo_mensual [pw=FEX_C]

* Consumo total * 
gen consumo_total_2020= consumo_mensual*12*`pob2020'*`prev2020'
sum consumo_total_2020 
return scalar total2020= r(mean) 
restore 
end 
use "$carpetaMadre\Data\ECV\ENCV2020\derived\Salud_derived.dta", clear
bootstrap r(total2020), reps(1000) seed(123): myboot 
estat bootstrap, all
// Guardamos los resultados en matrices
matrix results2020=J(1,5,.)
matrix results2020[1,1]=2020
matrix results2020[1,2]= e(b)[1,1]
matrix results2020[1,3]= e(ci_percentile)[1,1]
matrix results2020[1,4]= e(ci_percentile)[2,1] 
matrix results2020[1,5]=e(se)[1,1]
matrix list results2020


//2021// 
capture program drop myboot
program define myboot, rclass 
preserve
collapse (sum) fex_c 
local pob2021=fex_c // Población representada 
// Volver a cargar la base //
use "$carpetaMadre\Data\ECV\ENCV2021\derived\Salud_derived.dta", clear
rename p3008s1 prevalencia_semanal 
rename p3008s1a1 frecuencia_semanal 
rename p3008s1a2 consumo_diario 
* Confirmamos que la codificación para frecuencia semanal es la misma *    
replace prevalencia_semanal=0 if prevalencia_semanal==2
sum prevalencia_semanal [iw=fex_c]
local prev2021=r(mean)    
keep if prevalencia_semanal==1  
gen dias_semana=. 
replace dias_semana=7 if frecuencia_semanal==1 
replace dias_semana=1 if frecuencia_semanal==3
replace dias_semana= runiformint(2,6) if frecuencia_semanal==2  
**Completar consumo diario con las proporciones calculadas**
* Calculamos media para los que consumen diariamente *
summarize consumo_diario if frecuencia_semanal == 1, meanonly 
local mean_fuma_diario = r(mean)

* Completamos para los demás grupos de acuerdo a las proporciones estimadas anteriormente * 
gen consumo_diario_ajustado=.
replace consumo_diario_ajustado= consumo_diario if frecuencia_semanal==1
replace consumo_diario_ajustado= `mean_fuma_diario' * 0.61 if frecuencia_semanal==2 // Algunos días a la semana
replace consumo_diario_ajustado= `mean_fuma_diario' * 0.54 if frecuencia_semanal == 3 // Menos de una vez por semana 

// collapse con consumo mensual //
gen consumo_mensual= consumo_diario_ajustado*dias_semana*4.25 
collapse (mean) consumo_mensual [pw=fex_c]

* Estimación clásica * 
gen consumo_total_2021= consumo_mensual*12*`pob2021'*`prev2021' 
sum consumo_total_2021 
return scalar total2021=r(mean) 
restore
end 
use "$carpetaMadre\Data\ECV\ENCV2021\derived\Salud_derived.dta"	, clear 
bootstrap r(total2021), reps(1000) seed(123): myboot 
estat bootstrap, all  
// Guardamos los resultados en matrices //
matrix results2021=J(1,5,.)
matrix results2021[1,1]=2021
matrix results2021[1,2]= e(b)[1,1]
matrix results2021[1,3]= e(ci_percentile)[1,1]
matrix results2021[1,4]= e(ci_percentile)[2,1] 
matrix results2021[1,5]=e(se)[1,1]
matrix list results2021



///// Año 2022 //// 
capture program drop myboot
program define myboot, rclass 
preserve 
collapse (sum) FEX_C 
local pob2022=FEX_C // Población representada 
// Volvemos a cargar la base de datos //
use "$carpetaMadre\Data\ECV\ENCV2022\derived\Salud_derived.dta",clear     
replace prevalencia_semanal=0 if prevalencia_semanal==2
sum prevalencia_semanal [iw=FEX_C]
local prev2022=r(mean)    
keep if prevalencia_semanal==1  
gen dias_semana=. 
replace dias_semana=7 if frecuencia_semanal==1 
replace dias_semana=1 if frecuencia_semanal==3
replace dias_semana= runiformint(2,6) if frecuencia_semanal==2  
* Calculamos media para los que consumen diariamente *
summarize consumo_diario if frecuencia_semanal == 1, meanonly 
local mean_fuma_diario = r(mean)

* Completamos para los demás grupos de acuerdo a las proporciones estimadas anteriormente * 
gen consumo_diario_ajustado=.
replace consumo_diario_ajustado= consumo_diario if frecuencia_semanal==1
replace consumo_diario_ajustado= `mean_fuma_diario' * 0.61 if frecuencia_semanal==2 // Algunos días a la semana
replace consumo_diario_ajustado= `mean_fuma_diario' * 0.54 if frecuencia_semanal == 3 // Menos de una vez por semana 

// Collapse consumo mensual //
gen consumo_mensual= consumo_diario_ajustado*dias_semana*4.25 
collapse (mean) consumo_mensual [pw=FEX_C]
* Estimación clásica * 
gen consumo_total_2022= consumo_mensual*12*`pob2022'*`prev2022'
sum consumo_total_2022
return scalar total2022=r(mean) 
restore 
end
use "$carpetaMadre\Data\ECV\ENCV2022\derived\Salud_derived.dta",clear 
bootstrap r(total2022), reps(1000) seed(123): myboot 
estat bootstrap, all 
// Guardamos los resultados en matrices //
matrix results2022=J(1,5,.)
matrix results2022[1,1]=2022
matrix results2022[1,2]= e(b)[1,1]
matrix results2022[1,3]= e(ci_percentile)[1,1]
matrix results2022[1,4]= e(ci_percentile)[2,1] 
matrix results2022[1,5]=e(se)[1,1]
matrix list results2022

/// 2023 ///
capture program drop myboot
program define myboot, rclass 
preserve 
collapse (sum) FEX_C 
local pob2023=FEX_C // Población representada
// Cargar nuevamente la base // 
use "$carpetaMadre\Data\ECV\ENCV2023\derived\Salud_derived.dta", clear  
replace prevalencia_semanal=0 if prevalencia_semanal==2
sum prevalencia_semanal [iw=FEX_C]
local prev2023=r(mean)  
// Guardamos la prevalencia en un local // 
keep if prevalencia_semanal==1  
gen dias_semana=. 
replace dias_semana=7 if frecuencia_semanal==1 
replace dias_semana=1 if frecuencia_semanal==3
replace dias_semana= runiformint(2,6) if frecuencia_semanal==2  
* Calculamos media para los que consumen diariamente *
summarize consumo_diario if frecuencia_semanal == 1, meanonly 
local mean_fuma_diario = r(mean)

* Completamos para los demás grupos de acuerdo a las proporciones estimadas anteriormente * 
gen consumo_diario_ajustado=.
replace consumo_diario_ajustado= consumo_diario if frecuencia_semanal==1
replace consumo_diario_ajustado= `mean_fuma_diario' * 0.61 if frecuencia_semanal==2 // Algunos días a la semana
replace consumo_diario_ajustado= `mean_fuma_diario' * 0.54 if frecuencia_semanal == 3 // Menos de una vez por semana  

// collapse consumo mensual//
gen consumo_mensual= consumo_diario_ajustado*dias_semana*4.25 
collapse (mean) consumo_mensual [pw=FEX_C]
* Intento de estimarlo distinto teniendo en cuenta que los consumos mensuales son heterogeneos, da muy poquito * 
gen consumo_total_2023= consumo_mensual*12*`pob2023'*`prev2023'
sum consumo_total_2023
return scalar total2023=r(mean) 
restore 
end
use "$carpetaMadre\Data\ECV\ENCV2023\derived\Salud_derived.dta", clear 
bootstrap r(total2023), reps(1000) seed(123): myboot 
estat bootstrap, all  
/// Guardamos los resultados en matrices //
matrix results2023=J(1,5,.)
matrix results2023[1,1]=2023
matrix results2023[1,2]= e(b)[1,1]
matrix results2023[1,3]= e(ci_percentile)[1,1]
matrix results2023[1,4]= e(ci_percentile)[2,1] 
matrix results2023[1,5]=e(se)[1,1]
matrix list results2023


//// Juntar las matrices de todos los años ///
matrix matriz_anual= results2016\results2017\results2018\results2019\results2020\results2021\results2022\results2023 
matrix list matriz_anual 
clear
/// Guardar la matriz de los años como una base de datos y cambiar nombres de las columnas ///
svmat matriz_anual, names(col) 
rename c1 año 
rename c2 estimacion_consumo
rename c3 IC_limite_inferior 
rename c4 IC_limite_superior 
rename c5 error_estandar

// Formato /// 
format IC_limite_inferior %20.3f 
format IC_limite_superior %20.3f 
format estimacion_consumo %20.3f 
format error_estandar %20.3f 

save "$carpetaMadre\Data\Created data\ECV_TABACO", replace 


****************************************
* Graficar 

* Gráfico sobre millones * 
replace IC_limite_superior= IC_limite_superior/1000000
replace IC_limite_inferior= IC_limite_inferior/1000000
replace estimacion_consumo = estimacion_consumo/1000000

twoway (line estimacion_consumo año, mcolor(blue) lwidth(medium)) ///
       (line IC_limite_superior año, lcolor(red) lwidth(medium) lpattern(dash)) ///
       (line IC_limite_inferior año, lcolor(green) lwidth(medium) lpattern(dash)), ///
       xtitle("Año") ///
       ytitle("Consumo de Cigarrillos (en millones)") ///
       xlabel(2016(1)2023) ///
       ylabel(4000(500)8500)


* Según Caballero et al se utiliza un factor de correción de 1.2 en la prevalencia de la ECV por problemas de subreporte * 

gen UpperL_ajuste = IC_limite_superior * 1.2
gen Consumo_ajuste = estimacion_consumo * 1.2
gen LowerL_ajuste = IC_limite_inferior * 1.2 

twoway (line Consumo_ajuste año, mcolor(blue) lwidth(medium)) ///
       (line UpperL_ajuste año, lcolor(red) lwidth(medium) lpattern(dash)) ///
       (line LowerL_ajuste año, lcolor(green) lwidth(medium) lpattern(dash)), ///
       xtitle("Año") ///
       ytitle("Consumo de Cigarrillos con ajuste de prev. (en millones)") ///
       xlabel(2016(1)2023) ///
       ylabel(5000(500)10000)
