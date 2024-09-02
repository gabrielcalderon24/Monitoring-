**********************************
* Gasto y prevalencia de alimentos ultraprocesados (comidas de paquete, dulces, etc) según la ECV

// Es posible calcular la prevalencia y el gasto en alimentos utraprocesados a partir del año 2020. En años anteriores el cuestionario no indagaba por este dato.


// No se emplea los productos con código 25, ya que no es posible aíslar el gasto en bebidas azucaradas al incluir "agua" en el mismo código de producto
// 20--> Dulces, caramelos, chocolatinas, helados y refrescos congelados, gelatinas, flanes y pudines en polvo
// 21-->  Maní, mezclas con frutos secos, otra comida de paquete (papas fritas, chitos, maicitos, patacones) 
// 25-->  Agua embotellada o en bolsa; gaseosas; refrescos, jugos o té frío líquidos o en polvo, bebidas energizantes


/// 2020 /// 

/// Gasto en alimentos utraprocesados /// 

use "$carpetaMadre\Data\ECV\ENCV2020\original\Gastos de los hogares (Gastos por Item) 2020.dta", clear

rename P3204 productos 
rename P3204S1 valorPagado  
rename P3204S2 valorEstimado  
keep if productos==20 | productos==21 

			   			   
// Retirar los valores de posibles errores: 99 //
drop if valorPagado == 99 
drop if valorEstimado == 99

collapse (sum) valorPagado valorEstimado [pw=FEX_C], by(productos)

// redondear a dos decimales // 
replace valorEstimado= round(valorEstimado,0.01)
replace valorPagado= round(valorPagado,0.01)

// Valor total en miles de millones //
gen valorTotal= (valorPagado + valorEstimado)/1000000000
gen year = 2020
tempfile gasto_2020
save `gasto_2020'

/// Prevalencia de consumo de alimentos ultraprocesados (alimentos de paquete:papas,chitos,chicharrones o similares) ///
use "$carpetaMadre\Data\ECV\ENCV2020\original\Salud.dta", clear 
keep P3003 P3003S1 FEX_C
rename P3003S1 frecuencia  
rename P3003 prevalencia 
gen prev=. 
replace prev=1 if prevalencia==1 
replace prev=0 if prevalencia==2 
gen year=2020 
tempfile prev2020 
save `prev2020' 

// Intensidad de consumo // 
use "$carpetaMadre\Data\ECV\ENCV2020\original\Salud.dta", clear 
keep P3003 P3003S1 FEX_C
rename P3003S1 frecuencia  
rename P3003 prevalencia 
gen intensidad=. 
replace intensidad=7 if frecuencia==1 | frecuencia==2 
replace intensidad= runiformint(4,6) if frecuencia==3 // Asignamos un valor dentro de una distribución uniforme en el intervalo de días
replace intensidad= runiformint(2,3) if frecuencia==4 
replace intensidad= 1 if frecuencia==5 | frecuencia==6 

collapse (mean) intensidad [pw=FEX_C] if prevalencia==1  
gen year=2020 
tempfile int2020  
save `int2020'  


////////////////////
/////// 2021 ///////
////////////////////
use "$carpetaMadre\Data\ECV\ENCV2021\original\Gastos de los hogares (Gastos por Item) 2021.dta", clear

rename p3204 productos  
rename p3204s1 valorPagado  
rename p3204s2 valorEstimado 
keep if productos==20 | productos==21 


// Retirar los valores de posibles errores: 99 //
drop if valorPagado == 99 
drop if valorEstimado == 99

collapse (sum) valorPagado valorEstimado [pw=fex_c], by(productos)

// redondear a dos decimales // 
replace valorEstimado= round(valorEstimado,0.01)
replace valorPagado= round(valorPagado,0.01)

//// Valor total en miles de millones ///
gen valorTotal= (valorPagado + valorEstimado)/1000000000
gen year = 2021 
tempfile gasto_2021
save `gasto_2021'

/// Prevalencia de consumo de alimentos ultraprocesados (alimentos de paquete:papas,chitos,chicharrones o similares) ///
use "$carpetaMadre\Data\ECV\ENCV2021\original\Salud.dta", clear 
keep p3003 p3003s1 fex_c
rename p3003s1 frecuencia  
rename p3003 prevalencia  
rename fex_c FEX_C
gen prev=. 
replace prev=1 if prevalencia==1 
replace prev=0 if prevalencia==2 
gen year=2021 
tempfile prev2021 
save `prev2021' 

// Intensidad de consumo // 
use "$carpetaMadre\Data\ECV\ENCV2021\original\Salud.dta", clear 
keep p3003 p3003s1 fex_c
rename p3003s1 frecuencia  
rename p3003 prevalencia 
gen intensidad=. 
replace intensidad=7 if frecuencia==1 | frecuencia==2 
replace intensidad= runiformint(4,6) if frecuencia==3 // Asignamos un valor dentro de una distribución uniforme en el intervalo de días
replace intensidad= runiformint(2,3) if frecuencia==4 
replace intensidad= 1 if frecuencia==5 | frecuencia==6 

collapse (mean) intensidad [pw=fex_c] if prevalencia==1  
gen year=2021 
tempfile int2021  
save `int2021'  


////////////////
//// 2022 ///// 
///////////////

/// Gasto en alimentos utraprocesados /// 

use "$carpetaMadre\Data\ECV\ENCV2022\original\Gastos de los hogares (Gastos por Item) 2022.DTA", clear

rename P3204 productos 
rename P3204S1 valorPagado  
rename P3204S2 valorEstimado  
keep if productos==20 | productos==21 

			   			   
// Retirar los valores de posibles errores: 99 //
drop if valorPagado == 99 
drop if valorEstimado == 99

collapse (sum) valorPagado valorEstimado [pw=FEX_C], by(productos)

// redondear a dos decimales // 
replace valorEstimado= round(valorEstimado,0.01)
replace valorPagado= round(valorPagado,0.01)

// Valor total en miles de millones //
gen valorTotal= (valorPagado + valorEstimado)/1000000000
gen year = 2022
tempfile gasto_2022
save `gasto_2022'

/// Prevalencia de consumo de alimentos ultraprocesados (alimentos de paquete:papas,chitos,chicharrones o similares) ///
use "$carpetaMadre\Data\ECV\ENCV2022\original\Salud.dta", clear 
keep P3003 P3003S1 FEX_C
rename P3003S1 frecuencia  
rename P3003 prevalencia 
gen prev=. 
replace prev=1 if prevalencia==1 
replace prev=0 if prevalencia==2 
gen year=2022 
tempfile prev2022 
save `prev2022' 

// Intensidad de consumo // 
use "$carpetaMadre\Data\ECV\ENCV2022\original\Salud.dta", clear 
keep P3003 P3003S1 FEX_C
rename P3003S1 frecuencia  
rename P3003 prevalencia 
gen intensidad=. 
replace intensidad=7 if frecuencia==1 | frecuencia==2 
replace intensidad= runiformint(4,6) if frecuencia==3 // Asignamos un valor dentro de una distribución uniforme en el intervalo de días
replace intensidad= runiformint(2,3) if frecuencia==4 
replace intensidad= 1 if frecuencia==5 | frecuencia==6 

collapse (mean) intensidad [pw=FEX_C] if prevalencia==1  
gen year=2022 
tempfile int2022  
save `int2022'  


////////////
/// 2023 ///
////////////

// Para 2023 no podemos calcular el gasto, no hay sección de gastos de los hogares

// Prevalencia de consumo de alimentos ultraprocesados //
use "$carpetaMadre\Data\ECV\ENCV2023\original\Salud.DTA", clear
keep P3003 P3003S1 FEX_C
rename P3003S1 frecuencia  
rename P3003 prevalencia 

gen prev=. 
replace prev=1 if prevalencia==1 
replace prev=0 if prevalencia==2 
gen year=2023 
tempfile prev2023 
save `prev2023' 

// Intensidad de consumo // 
use "$carpetaMadre\Data\ECV\ENCV2023\original\Salud.dta", clear 
keep P3003 P3003S1 FEX_C
rename P3003S1 frecuencia  
rename P3003 prevalencia 
gen intensidad=. 
replace intensidad=7 if frecuencia==1 | frecuencia==2 
replace intensidad= runiformint(4,6) if frecuencia==3 // Asignamos un valor dentro de una distribución uniforme en el intervalo de días
replace intensidad= runiformint(2,3) if frecuencia==4 
replace intensidad= 1 if frecuencia==5 | frecuencia==6 

collapse (mean) intensidad [pw=FEX_C] if prevalencia==1  
gen year=2023 
tempfile int2023  
save `int2023'  

////////////////////////////////
/// Juntar archivos de gasto ///
//////////////////////////////// 

// Para mayor claridad, no se juntan los archivos de gasto con los de prevalencia y consumo //
use `gasto_2020'
append using `gasto_2021'
append using `gasto_2022'

save "$carpetaMadre\Data\Created data\ecv_gasto_ultraprocesados.dta", replace 

///////////////////////////////////////////////////
/// Juntar archivos de intensidad de consumo //////
///////////////////////////////////////////////////
use `int2020' 
append using `int2021' 
append using `int2022'
append using `int2023'
tempfile int_ecv 
save `int_ecv'

////////////////////////////////////////////////
////////////// Prevalencia ////////////////////
/////////////////////////////////////////////// 

/// Juntar archivos de prevalencia ///
use `prev2020' 
append using `prev2021' 
append using `prev2022'
append using `prev2023'
tempfile prev_ecv
save `prev_ecv' 

/// Calcular prevalencia por año ///
use `prev_ecv', clear
replace prev=prev*100
mean prev [aw=FEX_C], over(year)
mat A =r(table)'
svmat2 A , names(col) rnames(stat)
gen annio = regexs(2) if regexm(stat, "^([^0-9]*)([0-9]+)([^0-9]*)$")
destring annio, replace 
keep b se t annio 
rename annio year
rename b prev
/// Juntar con el archivo de intensidad de consumo y guardar finalmente en la misma base //
merge m:1 year using `int_ecv' 
drop _merge
save "$carpetaMadre\Data\Created data\ecv_prevalencia_intensidad_ultraprocesados.dta", replace







