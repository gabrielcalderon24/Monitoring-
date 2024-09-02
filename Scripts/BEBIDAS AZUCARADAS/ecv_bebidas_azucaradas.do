
////////////////////////////
///// Prevalencias /////////
////////////////////////////

// Las prevalencias sí pueden calcularse desde el año 2016, también se obtiene una intensidad de consumo, entendido como el número promedio de días que consumen bebidas azucaradas. Para alimentos ultraprocesados es posible construir este dato a partir de 2020.

********************************** 
* Prevalencia e intensidad de consumo: bebidas azucaradas según la ECV


/////// 2016 ////// 

// Prevalencia //
use "$carpetaMadre\Data\ECV\ENCV2016\original\Salud.dta", clear   
keep P1707 P1707S1 FEX_C
rename P1707 prevalencia 
rename P1707S1 frecuencia 

gen prev=. 
replace prev= 1 if prevalencia==1 
replace prev=0 if prevalencia==2 
 
gen year=2016 
tempfile prev2016 
save `prev2016 '

// Intensidad de consumo // 
use "$carpetaMadre\Data\ECV\ENCV2016\original\Salud.dta", clear 
keep P1707 P1707S1 FEX_C 
rename P1707S1 frecuencia  
rename P1707 prevalencia 
gen intensidad=. 
replace intensidad=7 if frecuencia==1 | frecuencia==2 
replace intensidad= runiformint(4,6) if frecuencia==3 // Asignamos un valor dentro de una distribución uniforme en el intervalo de días
replace intensidad= runiformint(2,3) if frecuencia==4 
replace intensidad= 1 if frecuencia==5 | frecuencia==6 

collapse (mean) intensidad [pw=FEX_C] if prevalencia==1  
gen year = 2016  
tempfile int2016  
save `int2016'  


/////// 2017 ////// 

// Prevalencia //
use "$carpetaMadre\Data\ECV\ENCV2017\original\Salud.dta", clear 
keep P1707 P1707S1 FEX_C
rename P1707 prevalencia 
rename P1707S1 frecuencia 

gen prev=. 
replace prev= 1 if prevalencia==1 
replace prev=0 if prevalencia==2 
 
gen year=2017 
tempfile prev2017 
save `prev2017 '

// Intensidad de consumo // 
use "$carpetaMadre\Data\ECV\ENCV2017\original\Salud.dta", clear 
keep P1707 P1707S1 FEX_C 
rename P1707S1 frecuencia  
rename P1707 prevalencia 
gen intensidad=. 
replace intensidad=7 if frecuencia==1 | frecuencia==2 
replace intensidad= runiformint(4,6) if frecuencia==3 // Asignamos un valor dentro de una distribución uniforme en el intervalo de días
replace intensidad= runiformint(2,3) if frecuencia==4 
replace intensidad= 1 if frecuencia==5 | frecuencia==6 

collapse (mean) intensidad [pw=FEX_C] if prevalencia==1  
gen year = 2017  
tempfile int2017  
save `int2017'  



/////// 2018 ////////
use "$carpetaMadre\Data\ECV\ENCV2018\original\Salud.dta", clear 
keep P1707 P1707S1 FEX_C 
rename P1707 prevalencia 
rename P1707S1 frecuencia 

gen prev=. 
replace prev= 1 if prevalencia==1 
replace prev=0 if prevalencia==2 
 
gen year=2018 
tempfile prev2018 
save `prev2018'

// Intensidad de consumo // 
use "$carpetaMadre\Data\ECV\ENCV2018\original\Salud.dta", clear 
keep P1707 P1707S1 FEX_C 
rename P1707S1 frecuencia  
rename P1707 prevalencia 
gen intensidad=. 
replace intensidad=7 if frecuencia==1 | frecuencia==2 
replace intensidad= runiformint(4,6) if frecuencia==3 // Asignamos un valor dentro de una distribución uniforme en el intervalo de días
replace intensidad= runiformint(2,3) if frecuencia==4 
replace intensidad= 1 if frecuencia==5 | frecuencia==6 

collapse (mean) intensidad [pw=FEX_C] if prevalencia==1  
gen year=2018 
tempfile int2018  
save `int2018'  


/////// 2019 ////////
use "$carpetaMadre\Data\ECV\ENCV2019\original\Salud.dta", clear 
keep P1707 P1707S1 FEX_C 
rename P1707 prevalencia 
rename P1707S1 frecuencia 

gen prev=. 
replace prev= 1 if prevalencia==1 
replace prev=0 if prevalencia==2 
 
gen year=2019 
tempfile prev2019 
save `prev2019'

// Intensidad de consumo // 
use "$carpetaMadre\Data\ECV\ENCV2019\original\Salud.dta", clear 
keep P1707 P1707S1 FEX_C 
rename P1707S1 frecuencia  
rename P1707 prevalencia 
gen intensidad=. 
replace intensidad=7 if frecuencia==1 | frecuencia==2 
replace intensidad= runiformint(4,6) if frecuencia==3 // Asignamos un valor dentro de una distribución uniforme en el intervalo de días
replace intensidad= runiformint(2,3) if frecuencia==4 
replace intensidad= 1 if frecuencia==5 | frecuencia==6 

collapse (mean) intensidad [pw=FEX_C] if prevalencia==1  
gen year=2019 
tempfile int2019  
save `int2019'  


/// 2020 ///
use "$carpetaMadre\Data\ECV\ENCV2020\original\Salud.dta", clear 
keep P1707 P1707S1 FEX_C 
rename P1707 prevalencia 
rename P1707S1 frecuencia 

gen prev=. 
replace prev= 1 if prevalencia==1 
replace prev=0 if prevalencia==2 
 
gen year=2020 
tempfile prev2020 
save `prev2020'

// Intensidad de consumo // 
use "$carpetaMadre\Data\ECV\ENCV2020\original\Salud.dta", clear 
keep P1707 P1707S1 FEX_C 
rename P1707S1 frecuencia  
rename P1707 prevalencia 
gen intensidad=. 
replace intensidad=7 if frecuencia==1 | frecuencia==2 
replace intensidad= runiformint(4,6) if frecuencia==3 // Asignamos un valor dentro de una distribución uniforme en el intervalo de días
replace intensidad= runiformint(2,3) if frecuencia==4 
replace intensidad= 1 if frecuencia==5 | frecuencia==6 

collapse (mean) intensidad [pw=FEX_C] if prevalencia==1  
gen year=2020 
tempfile int2020  
save `int2020'  


//////// 2021 ///////
use "$carpetaMadre\Data\ECV\ENCV2021\original\Salud.dta", clear 
keep p1707 p1707s1 fex_c 
rename p1707 prevalencia 
rename p1707s1 frecuencia 
rename fex_c FEX_C
gen prev=. 
replace prev= 1 if prevalencia==1 
replace prev=0 if prevalencia==2 
 
gen year=2021 
tempfile prev2021 
save `prev2021'

// Intensidad de consumo // 
use "$carpetaMadre\Data\ECV\ENCV2021\original\Salud.dta", clear 
keep p1707 p1707s1 fex_c 
rename p1707 prevalencia 
rename p1707s1 frecuencia 
rename fex_c FEX_C 
gen intensidad=. 
replace intensidad=7 if frecuencia==1 | frecuencia==2 
replace intensidad= runiformint(4,6) if frecuencia==3 // Asignamos un valor dentro de una distribución uniforme en el intervalo de días
replace intensidad= runiformint(2,3) if frecuencia==4 
replace intensidad= 1 if frecuencia==5 | frecuencia==6 

collapse (mean) intensidad [pw=FEX_C] if prevalencia==1  
gen year=2021 
tempfile int2021  
save `int2021'  



/////// 2022 ///////
use "$carpetaMadre\Data\ECV\ENCV2022\original\Salud.dta", clear 
keep P1707 P1707S1 FEX_C 
rename P1707 prevalencia 
rename P1707S1 frecuencia 

gen prev=. 
replace prev= 1 if prevalencia==1 
replace prev=0 if prevalencia==2 
 
gen year=2022 
tempfile prev2022 
save `prev2022'

// Intensidad de consumo // 
use "$carpetaMadre\Data\ECV\ENCV2022\original\Salud.dta", clear 
keep P1707 P1707S1 FEX_C 
rename P1707S1 frecuencia  
rename P1707 prevalencia 
gen intensidad=. 
replace intensidad=7 if frecuencia==1 | frecuencia==2 
replace intensidad= runiformint(4,6) if frecuencia==3 // Asignamos un valor dentro de una distribución uniforme en el intervalo de días
replace intensidad= runiformint(2,3) if frecuencia==4 
replace intensidad= 1 if frecuencia==5 | frecuencia==6 

collapse (mean) intensidad [pw=FEX_C] if prevalencia==1  
gen year=2022 
tempfile int2022  
save `int2022'  


///// 2023 ////////
use "$carpetaMadre\Data\ECV\ENCV2023\original\Salud.dta", clear 
keep P1707 P1707S1 FEX_C 
rename P1707 prevalencia 
rename P1707S1 frecuencia 

gen prev=. 
replace prev= 1 if prevalencia==1 
replace prev=0 if prevalencia==2 

gen year=2023 
tempfile prev2023 
save `prev2023'


// Intensidad de consumo // 
use "$carpetaMadre\Data\ECV\ENCV2023\original\Salud.DTA", clear 
keep P1707 P1707S1 FEX_C 
rename P1707S1 frecuencia  
rename P1707 prevalencia 
gen intensidad=. 
replace intensidad=7 if frecuencia==1 | frecuencia==2 
replace intensidad= runiformint(4,6) if frecuencia==3 // Asignamos un valor dentro de una distribución uniforme en el intervalo de días
replace intensidad= runiformint(2,3) if frecuencia==4 
replace intensidad= 1 if frecuencia==5 | frecuencia==6 

collapse (mean) intensidad [pw=FEX_C] if prevalencia==1  
gen year=2023 
tempfile int2023  
save `int2023'  

////////////////////////////////////////////////
///////// Intensidad de consumo ////////////////
////////////////////////////////////////////////

// Juntar archivos temporales para intensidad de consumo // 
use `int2016' , clear
append using `int2017' 
append using `int2018'
append using `int2019'
append using `int2020'
append using `int2021'
append using `int2022'
append using `int2023' 
tempfile ecv_int
save `ecv_int', replace

///////////////////////////////////// 
///// Prevalencias //////////////////
/////////////////////////////////////

tempfile prev_azucaradas

// Juntar archivos de prevalencia /// 
use `prev2016' , clear
append using `prev2017' 
append using `prev2018'
append using `prev2019'
append using `prev2020'
append using `prev2021'
append using `prev2022'
append using `prev2023' 
save `prev_azucaradas', replace

// Obtener intervalos de confianza //
use `prev_azucaradas', clear 
replace prev=prev*100
mean prev [aw=FEX_C], over(year)
mat A =r(table)'
svmat2 A , names(col) rnames(stat)
gen annio = regexs(2) if regexm(stat, "^([^0-9]*)([0-9]+)([^0-9]*)$")
destring annio, replace 
keep b se t annio 
rename b prevalencia 
rename t tvalue 
rename annio year 

// Combinar archivos de prevalencia e intensidad de consumo //
merge m:1 year using `ecv_int' 
drop _merge
save "$carpetaMadre\Data\Created data\ecv_azucaradas.dta", replace



