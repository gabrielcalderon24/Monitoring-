
////////////////////////////////////////////////////////////////////////////////
**# Importaciones
////////////////////////////////////////////////////////////////////////////////



import excel "$carpetaMadre\Data\1_Importaciones y exportaciones 2014 a 2023 - 2024DP000063623 PQSR.xlsx", sheet("Importaciones 2014-2023") cellrange(A4:AQ11900) firstrow clear

keep if inlist(SubpartidaArancelaria, ///  
    2207200000, /// Alcohol etílico y aguardiente desnaturalizados, de cualquier graduación.
    2207200010, /// Alcohol etílico o etanol, de contenido alcohólico volumétrico superior o igual al 96,3 % vol, desnaturalizado con gasolina 
    2207200090  /// Los demás Alcohol etílico y aguardiente desnaturalizados, de cualquier graduación
)

format SubpartidaArancelaria %20.2f 

* Tomamos unidades comerciales en este caso como litros 
collapse (sum) Q_imp=CantidadUnidadesComerciales v_ventas_I= ValorCIFPesos, by(FechaAño)
gen valor_L_CIF= v_ventas_I/Q_imp
destring FechaAño, replace
tempfile importaciones
save `importaciones'


////////////////////////////////////////////////////////////////////////////////
**# Exportaciones
////////////////////////////////////////////////////////////////////////////////

clear
import excel "$carpetaMadre\Data\1_Importaciones y exportaciones 2014 a 2023 - 2024DP000063623 PQSR.xlsx", sheet("Exportaciones 2014-2023") cellrange(A4:M3629) firstrow clear

 keep if inlist(SubpartidaArancelaria, ///  
    2207200000, /// Alcohol etílico y aguardiente desnaturalizados, de cualquier graduación.
    2207200010, /// Alcohol etílico o etanol, de contenido alcohólico volumétrico superior o igual al 96,3 % vol, desnaturalizado con gasolina 
    2207200090  /// Los demás Alcohol etílico y aguardiente desnaturalizados, de cualquier graduación
)

	
collapse (sum) Q_exp=CantidadUnidadesComerciales, by(FechaAño)
destring FechaAño, replace



tempfile exportaciones
save `exportaciones'
		
////////////////////////////////////////////////////////////////////////////////
**# Producción Nacional
////////////////////////////////////////////////////////////////////////////////



clear
set obs 1
gen uno=1
tempfile produccion
save `produccion'

import excel "$carpetaMadre\Data\EAM\c6_2_14.xlsx", sheet("c6_2_14") cellrange(A10:I3323) firstrow clear 
keep if CÓDIGOCPC == "3413101" | CÓDIGOCPC == "3413102" | CÓDIGOCPC == "3413103" 
gen year=2014
rename ARTÍCULOSCONPRODUCCIÓN ARTÍCULOS
append using `produccion'
save `produccion', replace

import excel "$carpetaMadre\Data\EAM\Anexos_EAM_desagregacion_variables_2015.xls", sheet("6,2") cellrange(A12:I3340) firstrow clear 
keep if CÓDIGOCPC == "3413101" | CÓDIGOCPC == "3413102" | CÓDIGOCPC == "3413103" 
gen year=2015
rename ARTÍCULOSCONPRODUCCIÓN ARTÍCULOS
append using `produccion'
save `produccion', replace


import excel "$carpetaMadre\Data\EAM\Anexos_EAM_desagregacion_variables_2016.xls", sheet("6.2") cellrange(A14:I3293) firstrow clear
keep if CÓDIGOCPC == "3413101" | CÓDIGOCPC == "3413102" | CÓDIGOCPC == "3413103" 
gen year=2016
rename ARTÍCULOSCONPRODUCCIÓN ARTÍCULOS
append using `produccion'
save `produccion', replace


// EN 2017 todos los códigos tienen un 0 al principio//
import excel "$carpetaMadre\Data\EAM\Anexos_EAM_desagregacion_variables_2017.xls", sheet("6.2") cellrange(A13:I3228) firstrow clear
keep if CÓDIGOCPC == "03413101" | CÓDIGOCPC == "03413102" | CÓDIGOCPC == "03413103" 
gen year=2017
rename ARTÍCULOSCONPRODUCCIÓN ARTÍCULOS
append using `produccion'
save `produccion', replace


import excel "$carpetaMadre\Data\EAM\Anexos_EAM_desagregacion_variables_2018.xls", sheet("6.2") cellrange(A13:I3279) firstrow clear  
keep if CÓDIGOCPC == "3413101" | CÓDIGOCPC == "3413102" | CÓDIGOCPC == "3413103" 
gen year=2018
append using `produccion'
save `produccion', replace


import excel "$carpetaMadre\Data\EAM\Anexos_EAM_desagregacion_variables_2019.xls", sheet("6.2") cellrange(A13:I3232) firstrow clear
keep if CÓDIGOCPC == "3413101" | CÓDIGOCPC == "3413102" | CÓDIGOCPC == "3413103" 
gen year=2019
append using `produccion'
save `produccion', replace

import excel "$carpetaMadre\Data\EAM\Anexos_EAM_desagregacion_variables_2020.xls", sheet("6.2") cellrange(A13:I3228) firstrow clear
keep if CÓDIGOCPC == "3413101" | CÓDIGOCPC == "3413102" | CÓDIGOCPC == "3413103" 
gen year=2020
append using `produccion'
save `produccion', replace


import excel "$carpetaMadre\Data\EAM\Anexos_EAM_desagregacion_variables_2021.xlsx", sheet("6.2") cellrange(A13:I3217) firstrow clear
keep if CÓDIGOCPC == "3413101" | CÓDIGOCPC == "3413102" | CÓDIGOCPC == "3413103" 
gen year=2021
append using `produccion'
save `produccion', replace

import excel "$carpetaMadre\Data\EAM\anex-EAM-desagregacion-2022.xlsx", sheet("6.2") cellrange(A13:I3176) firstrow clear
keep if CÓDIGOCPC == "3413101" | CÓDIGOCPC == "3413102" | CÓDIGOCPC == "3413103" 
gen year=2022
append using `produccion'
save `produccion', replace


drop if uno==1
drop uno


destring PRODUCCIÓN VENTAS VALORDEVENTAS, replace
replace PRODUCCIÓN= PRODUCCIÓN * 3.785 if CÓDIGOCPC== "3413103" | CÓDIGOCPC== "03413103" 
replace VENTAS= VENTAS * 3.785 if year != 2016 & (CÓDIGOCPC== "3413103"  | CÓDIGOCPC== "03413103") 
replace VALORDEVENTAS= VALORDEVENTAS*1000  
collapse (sum) Q_prod= PRODUCCIÓN Q_vent=VENTAS v_ventas_EAM = VALORDEVENTAS , by(year)
rename year FechaAño

* No se registran datos para el valor de ventas entre los años 2015-2019
gen precio_EAM_L= v_ventas_EAM/Q_vent 
save "$carpetaMadre\Data\Created data\produccion_etilico_EAM.dta", replace
		
		

////////////////////////////////////////////////////////////////////////////////
**# Construccion Consumpo aparente y consolidación
////////////////////////////////////////////////////////////////////////////////


	
use "$carpetaMadre\Data\Created data\produccion_etilico_EAM.dta", clear
merge 1:1 FechaAño using `exportaciones', nogen
merge 1:1 FechaAño using `importaciones', nogen
	
	
gen consumoAparente = Q_imp + Q_vent - Q_exp 
* En millones de litros 
replace consumoAparente=consumoAparente/1000000 

format consumoAparente %20.2f
drop v_ventas_EAM v_ventas_I		
tw (connected consumoAparente FechaAño) 

save "$carpetaMadre\Data\Created data\ConsumoAparente_alcoholEtilico.dta", replace