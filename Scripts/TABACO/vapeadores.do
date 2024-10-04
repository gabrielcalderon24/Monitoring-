clear all

//////////////////////////////////////////////////////////////////////////
// Indicadores de consumo aparente, IHH y prevalencia para Vapeadores ////
//////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
**# Consolidación consumo aparente e IHH- Productos llegan por importación /////
////////////////////////////////////////////////////////////////////////////////

import excel "$carpetaMadre\Data\1_Importaciones y exportaciones 2014 a 2023 - 2024DP000063623 PQSR.xlsx", sheet("Importaciones 2014-2023") cellrange(A4:AQ11979) firstrow clear

 keep if inlist(SubpartidaArancelaria, ///  
    2404110000, /// Productos destinados para la inhalación sin combustión: Que contengan tabaco o tabaco reconstituido
    2404120000, /// Productos destinados para la inhalación sin combustión: Los demás, que contengan nicotina
    2404190000, ///  Productos destinados para la inhalación sin combustión: Los demás
    2404910000 ///  Productos destinados para la inhalación sin combustión: Para administarse por vía oral
)


format SubpartidaArancelaria %20.2f
 
collapse (sum) Q_imp=CantidadUnidadesComerciales valor=ValorCIFPesos, by(FechaAño SubpartidaArancelaria)

destring FechaAño, replace 

* Poner en millones de pesos
replace valor= valor/1000000

* Exportar en Excel para base de indicadores 
export excel "$carpetaMadre\Data\Created data\vapeadores.xlsx", firstrow(variables) replace

* Exportar en archivo .dta
save "$carpetaMadre\Data\Created data\vapeadores.data", replace 

////////////////////////////////
// IHH POR PRODUCTO ////////////
//////////////////////////////// 

import excel "$carpetaMadre\Data\1_Importaciones y exportaciones 2014 a 2023 - 2024DP000063623 PQSR.xlsx", sheet("Importaciones 2014-2023") cellrange(A4:AQ11979) firstrow clear

// Construir el IHH de acuerdo a cada subpartida arancelaria 

 keep if inlist(SubpartidaArancelaria, ///  
    2404110000, /// Productos destinados para la inhalación sin combustión: Que contengan tabaco o tabaco reconstituido
    2404120000, /// Productos destinados para la inhalación sin combustión: Los demás, que contengan nicotina
    2404190000, ///  Productos destinados para la inhalación sin combustión: Los demás
    2404910000 ///  Productos destinados para la inhalación sin combustión: Para administarse por vía oral
)

rename RazónSocialdelImportador importador
format SubpartidaArancelaria %20.2f 
destring FechaAño, replace


keep SubpartidaArancelaria FechaAño ValorCIFPesos importador
collapse (sum) ValorCIFPesos, by(FechaAño SubpartidaArancelaria importador)

* Agrupar valor total por año y subpartida arancelaria
bysort SubpartidaArancelaria FechaAño: egen total_venta= total(ValorCIFPesos)

* Generar participaciones de mercado en porcentaje
gen share= ((ValorCIFPesos/total_venta)*100)
 
* Archivo con participaciones de mercado de cada importador según subpartida arancelaria  
export excel "$carpetaMadre\Data\Created data\vap_market_shares.xlsx", firstrow(variables) replace

* Finalmente, obtenemos el IHH por Subpartida Arancelaria 
replace share= share^2 
collapse (sum) share, by(SubpartidaArancelaria FechaAño)
rename share IHH 
 
save "$carpetaMadre\Data\Created data\IHH_VAP.data", replace  


////////////////////////////
**# Prevalencias ///////////
////////////////////////////

*************************************************************************************
** Las prevalencias para cigarrillos electrónicos se pueden calcular a partir de 2019
************************************************************************************* 


/////// 2019 //////// 
use "Data\ECV\ENCV2019\original\Salud.dta", clear 
keep P3008S2 FEX_C 
rename P3008S2 prevalencia  

gen prev=. 
replace prev= 1 if prevalencia==1 
replace prev=0 if prevalencia==2 
 
gen year=2019 
tempfile prev2019 
save `prev2019'


  
/////// 2020 //////// 
use "Data\ECV\ENCV2020\original\Salud.dta", clear 
keep P3008S2 FEX_C 
rename P3008S2 prevalencia  

gen prev=. 
replace prev= 1 if prevalencia==1 
replace prev=0 if prevalencia==2 
 
gen year=2020 
tempfile prev2020
save `prev2020'



//////// 2021 ///////
use "Data\ECV\ENCV2021\original\Salud.dta", clear 
keep p3008s2  fex_c 
rename p3008s2 prevalencia  
rename fex_c FEX_C
gen prev=. 
replace prev= 1 if prevalencia==1 
replace prev=0 if prevalencia==2 
 
gen year=2021 
tempfile prev2021 
save `prev2021'



/////// 2022 ///////
use "Data\ECV\ENCV2022\original\Salud.dta", clear 
keep P3008S2 FEX_C 
rename P3008S2 prevalencia  

gen prev=. 
replace prev= 1 if prevalencia==1 
replace prev=0 if prevalencia==2 
 
gen year=2022 
tempfile prev2022
save `prev2022'



/////// 2023 ///////
use "Data\ECV\ENCV2023\original\Salud.dta", clear 
keep P3008S2 FEX_C 
rename P3008S2 prevalencia  

gen prev=. 
replace prev= 1 if prevalencia==1 
replace prev=0 if prevalencia==2 
 
gen year=2023 
tempfile prev2023
save `prev2023'



// Juntar archivos de prevalencia ///
use `prev2019' , clear
append using `prev2020'
append using `prev2021'
append using `prev2022'
append using `prev2023' 


///////////////////////////////////// 
///// Prevalencias //////////////////
/////////////////////////////////////
replace prev=prev*100
mean prev [aw=FEX_C], over(year)
mat A =r(table)'
svmat2 A , names(col) rnames(stat)
gen annio = regexs(2) if regexm(stat, "^([^0-9]*)([0-9]+)([^0-9]*)$")
destring annio, replace 
keep b se t annio
save "$carpetaMadre\Data\Created data\prev_vapeadores.dta", replace









