**************************************************************************************
* Cálculo de prevalencia y gasto total (gasto pagado + gasto estimado) en alcohol según la ECV

****************
**** 2020 ******
****************

/// PREVALENCIA 2020 /// 

// Los códigos están distribuidos de acuerdo al hogar y el producto que compró. El código del hogar se repite por cada producto, por lo que el cálculo de la prevalencia requiere de ciertos pasos adicionales

use "$carpetaMadre\Data\ECV\ENCV2020\original\Gastos de los hogares (Gastos por Item) 2020.dta", clear 

rename P3204 productos  

// Hacemos una dummie para indicar si compró bebidas alcohólicas, luego agrupamos por código de hogar 
gen alcohol= 0. 
replace alcohol=1 if productos== 27   

bysort DIRECTORIO: egen prevalencia = max(alcohol)  // Agrupar por hogar si ha comprado bebidas alcohólicas 
duplicates drop DIRECTORIO, force // Quitar duplicados  
collapse (mean) prevalencia  [iw=FEX_C]
gen year = 2020  
tempfile prev_2020
save `prev_2020'

/// GASTO 2020 ///
use "$carpetaMadre\Data\ECV\ENCV2020\original\Gastos de los hogares (Gastos por Item) 2020.dta", clear 

rename P3204 productos  
keep if productos== 27  
rename P3204S1 valorPagado  
rename P3204S2 valorEstimado 

// Retirar los valores de posibles errores: 99 //
drop if valorPagado == 99 
drop if valorEstimado == 99

collapse (sum) valorPagado valorEstimado [iw=FEX_C] 

//// Valor total en miles de millones ///
gen valorTotal= (valorPagado + valorEstimado)/1000000000
gen year = 2020
tempfile gasto_2020
save `gasto_2020'

****************
**** 2021 ******
****************
/// PREVALENCIA 2021 /// 

// Repetir el mismo proceso de 2020 para los años posteriores
use "$carpetaMadre\Data\ECV\ENCV2021\original\Gastos de los hogares (Gastos por Item) 2021.dta", clear 

rename p3204 productos 
gen alcohol= 0. 
replace alcohol=1 if productos== 27   

bysort directorio: egen prevalencia = max(alcohol)  // Agrupar por hogar si ha comprado bebidas alcohólicas 
duplicates drop directorio, force  
collapse (mean) prevalencia  [iw=fex_c]
gen year = 2021 
tempfile prev_2021
save `prev_2021'

/// 2021 ///
use "$carpetaMadre\Data\ECV\ENCV2021\original\Gastos de los hogares (Gastos por Item) 2021.dta", clear 
rename p3204 productos
keep if productos== 27  
rename p3204s1 valorPagado  
rename p3204s2 valorEstimado 

// Retirar los valores de posibles errores: 99 //
drop if valorPagado == 99 
drop if valorEstimado == 99

collapse (sum) valorPagado valorEstimado [iw=fex_c] 

//// Valor total en miles de millones ///
gen valorTotal= (valorPagado + valorEstimado)/1000000000
gen year = 2021 
tempfile gasto_2021
save `gasto_2021'


****************
**** 2022 ******
****************

/// PREVALENCIA 2022 ///
use "$carpetaMadre\Data\ECV\ENCV2022\original\Gastos de los hogares (Gastos por Item) 2022.dta", clear 

rename P3204 productos 
gen alcohol= 0. 
replace alcohol=1 if productos== 27   

bysort DIRECTORIO: egen prevalencia = max(alcohol)  // Agrupar por hogar si ha comprado bebidas alcohólicas 
duplicates drop DIRECTORIO, force // Quitamos duplicados y ahora sí tenemos prevalencia  
collapse (mean) prevalencia  [iw=FEX_C]
gen year = 2022 
tempfile prev_2022
save `prev_2022'

/////  GASTO 2022 /////
use "$carpetaMadre\Data\ECV\ENCV2022\original\Gastos de los hogares (Gastos por Item) 2022.dta", clear 
rename P3204 productos  
keep if productos== 27  
rename P3204S1 valorPagado  
rename P3204S2 valorEstimado 

// Retirar los valores de posibles errores: 99 //
drop if valorPagado == 99 
drop if valorEstimado == 99

collapse (sum) valorPagado valorEstimado [iw=FEX_C] 

//// Valor total en miles de millones ///
gen valorTotal= (valorPagado + valorEstimado)/1000000000
gen year = 2022 
tempfile gasto_2022
save `gasto_2022'


**********************************
* Juntar ambos archivos temporales

// Gasto por año
use `gasto_2020', clear
append using `gasto_2021'
append using `gasto_2022'
tempfile gasto_ecv 
save `gasto_ecv', replace

// Prevalencia por año
use `prev_2020', clear
append using `prev_2021'
append using `prev_2022'
tempfile prev_ecv
save `prev_ecv', replace

use `prev_ecv', clear
merge m:1 year using `gasto_ecv' 
drop _merge 
rename valorTotal ValorTotal_miles_millones
save "$carpetaMadre\Data\Created data\ECV_alcohol", replace

