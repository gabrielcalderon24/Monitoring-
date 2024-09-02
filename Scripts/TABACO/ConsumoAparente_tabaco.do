clear all
////////////////////////////////////////////////////////////////////////////////
**# Importaciones
////////////////////////////////////////////////////////////////////////////////

import excel "$carpetaMadre\Data\1_Importaciones y exportaciones 2014 a 2023 - 2024DP000063623 PQSR.xlsx", sheet("Importaciones 2014-2023") cellrange(A4:AQ11979) firstrow clear
keep if ///
inlist(SubpartidaArancelaria, ///
					/// // 2401101000, /// // Tabaco negro sin desvenar o desnervar, en rama o sin elaborar
					/// // 2401102000, /// // Tabaco rubio en rama o sin elaborar, sin desvenar o desnervar
					/// // 2401201000, /// // Tabaco negro total o parcialmente desvenado o desnervad
					/// // 2401202000, /// // Tabaco rubio total o parcialmente desvenado o desnervado
					/// // 2401300000, /// // Desperdicios de tabaco
					/// // 2402100000, /// // Cigarros (puros) (incluso despuntados) y cigarritos (puritos) que contengan tabaco
					2402201000, /// // Cigarrillos de tabaco negro <<<<<<<<
					2402202000, /// // Cigarrillos de tabaco rubio <<<<<<<<
					2402900000 /// // Los demás cigarrillos de tabaco o de  sucedáneos del tabaco
					/// // 2403110000, /// // Tabaco para pipa de agua mencionado en la Nota 1 de Subpartida
					/// // 2403190000, /// // Los demás tabacos para fumar, incluso con sucedáneos de tabaco en cualquier proporción
					/// // 2403910000, /// // Tabaco "homogeneizado" o "reconstituido"
					/// // 2403990000  ///   // Los demás tabacos elaborados, extractos y jugos de tabaco.
		)

drop R- AQ

tab FechaAño PorcentajeArancel
tab FechaAño PorcentajeIVA

* Una aproximación burda a unidades por otro lado
gen punit= PesoNetoKG*1000/ (CantidadUnidadesComerciale)
sum punit if punit<10, d //... como 1 gramo realmente
gen Q_impPeso = (PesoNetoKG*1000)/1000000 // cigarrillos en millones

* Tomando unidades como "cigarrillos". En general, está bien
replace CantidadUnidadesComerciales = CantidadUnidadesComerciales/1000000

collapse (sum) TotalArancel TotalIVA ValorCIFPesos Q_impPeso Q_imp=CantidadUnidadesComerciales, by( FechaAño)

format %15.0g TotalIVA
format %15.0g TotalArancel

replace TotalIVA=TotalIVA/1000000000 // Miles de millones COP
replace TotalArancel=TotalArancel/1000000000 // Miles de millones COP

replace ValorCIFPesos=ValorCIFPesos/1000000 // Millones COP CIF

destring FechaAño, replace


*tw (connected Q_imp FechaAño)  (connected numcig FechaAño)

tempfile importaciones
save `importaciones'

save "$carpetaMadre\Data\Created data\importacionesDIAN.dta", replace


////////////////////////////////////////////////////////////////////////////////
**# Exportaciones
////////////////////////////////////////////////////////////////////////////////

import excel "$carpetaMadre\Data\1_Importaciones y exportaciones 2014 a 2023 - 2024DP000063623 PQSR.xlsx", sheet("Exportaciones 2014-2023") cellrange(A4:M3626) firstrow clear
keep if ///
inlist(SubpartidaArancelaria, ///
					/// // 2401101000, /// // Tabaco negro sin desvenar o desnervar, en rama o sin elaborar
					/// // 2401102000, /// // Tabaco rubio en rama o sin elaborar, sin desvenar o desnervar
					/// // 2401201000, /// // Tabaco negro total o parcialmente desvenado o desnervad
					/// // 2401202000, /// // Tabaco rubio total o parcialmente desvenado o desnervado
					/// // 2401300000, /// // Desperdicios de tabaco
					/// // 2402100000, /// // Cigarros (puros) (incluso despuntados) y cigarritos (puritos) que contengan tabaco
					2402201000, /// // Cigarrillos de tabaco negro <<<<<<<<
					2402202000, /// // Cigarrillos de tabaco rubio <<<<<<<<
					2402900000 /// // Los demás cigarrillos de tabaco o de  sucedáneos del tabaco
					/// // 2403110000, /// // Tabaco para pipa de agua mencionado en la Nota 1 de Subpartida
					/// // 2403190000, /// // Los demás tabacos para fumar, incluso con sucedáneos de tabaco en cualquier proporción
					/// // 2403910000, /// // Tabaco "homogeneizado" o "reconstituido"
					/// // 2403990000  ///   // Los demás tabacos elaborados, extractos y jugos de tabaco.
		)

* Tomando unidades como "cigarrillos". En general, está bien
replace CantidadUnidadesComerciales = CantidadUnidadesComerciales/1000000

* Una aproximación burda a unidades por otro lado
gen Q_expPeso = (PesoNetoKG*1000)/1000000 // cigarrillos en millones

		
collapse (sum) Q_expPeso Q_exp=CantidadUnidadesComerciales, by( FechaAño)

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
keep if CÓDIGOCPC=="2502001" | CÓDIGOCPC=="2502002"
gen year=2014
rename ARTÍCULOSCONPRODUCCIÓN ARTÍCULOS
append using `produccion'
save `produccion', replace

import excel "$carpetaMadre\Data\EAM\Anexos_EAM_desagregacion_variables_2015.xls", sheet("6,2") cellrange(A12:I3340) firstrow clear
keep if CÓDIGOCPC=="2502001" | CÓDIGOCPC=="2502002"
gen year=2015
rename ARTÍCULOSCONPRODUCCIÓN ARTÍCULOS
append using `produccion'
save `produccion', replace

import excel "$carpetaMadre\Data\EAM\Anexos_EAM_desagregacion_variables_2016.xls", sheet("6.2") cellrange(A14:I3293) firstrow clear
keep if CÓDIGOCPC=="2502001" | CÓDIGOCPC=="2502002"
gen year=2016
rename ARTÍCULOSCONPRODUCCIÓN ARTÍCULOS
append using `produccion'
save `produccion', replace

import excel "$carpetaMadre\Data\EAM\Anexos_EAM_desagregacion_variables_2017.xls", sheet("6.2") cellrange(A13:I3232) firstrow clear
keep if CÓDIGOCPC=="02502001" | CÓDIGOCPC=="02502002"
gen year=2017
rename ARTÍCULOSCONPRODUCCIÓN ARTÍCULOS
append using `produccion'
save `produccion', replace

import excel "$carpetaMadre\Data\EAM\Anexos_EAM_desagregacion_variables_2018.xls", sheet("6.2") cellrange(A13:I3279) firstrow clear
keep if CÓDIGOCPC=="2502001" | CÓDIGOCPC=="2502002"
gen year=2018
append using `produccion'
save `produccion', replace

import excel "$carpetaMadre\Data\EAM\Anexos_EAM_desagregacion_variables_2019.xls", sheet("6.2") cellrange(A13:I3238) firstrow clear
keep if CÓDIGOCPC=="2502001" | CÓDIGOCPC=="2502002"
gen year=2019
append using `produccion'
save `produccion', replace

import excel "$carpetaMadre\Data\EAM\Anexos_EAM_desagregacion_variables_2020.xls", sheet("6.2") cellrange(A13:I3228) firstrow clear
keep if CÓDIGOCPC=="2502001" | CÓDIGOCPC=="2502002"
gen year=2020
append using `produccion'
save `produccion', replace

import excel "$carpetaMadre\Data\EAM\Anexos_EAM_desagregacion_variables_2021.xlsx", sheet("6.2") cellrange(A13:I3217) firstrow clear
keep if CÓDIGOCPC=="2502001" | CÓDIGOCPC=="2502002"
gen year=2021
append using `produccion'
save `produccion', replace

drop if uno==1
drop uno


destring PRODUCCIÓN VENTAS, replace
collapse (sum) Q_prod= PRODUCCIÓN Q_vent=VENTAS , by(year)
rename year FechaAño
replace Q_prod=Q_prod/1000 // La unidad de medida es "miles"
replace Q_vent=Q_vent/1000

tempfile produccion
save `produccion'
		

////////////////////////////////////////////////////////////////////////////////
**# Recaudo
////////////////////////////////////////////////////////////////////////////////

* El archivo de "recaudoADRES" se debe crear previamente con el archido "ADRES_tabaco"
use "$carpetaMadre\Data\Created data\recaudoADRES.dta", clear

collapse (sum) juegosyazar - totales , by(year)

foreach varo of varlist juegosyazar - totales {
	replace `varo'= `varo'/1000
}

keep cigarrillos adValcigarrillos year
rename year FechaAño

tempfile impoConsumo
save `impoConsumo'
		

////////////////////////////////////////////////////////////////////////////////
**# Construccion Consumpo aparente y consolidación
////////////////////////////////////////////////////////////////////////////////


	
use `importaciones', clear
merge 1:1 FechaAño using `exportaciones', nogen
merge 1:1 FechaAño using `produccion', nogen
merge 1:1 FechaAño using `impoConsumo', nogen
		
replace Q_vent = 21 if FechaAño==2022 | FechaAño==2023 // Supuesto porque los datos aún no están

gen consumoAparente = Q_imp     + Q_vent - Q_exp
gen consumoAparente2= Q_impPeso + Q_vent - Q_expPeso
		
tw (connected consumoAparente FechaAño) (connected consumoAparente2 FechaAño) ///
	, legend(order( 1 "Con unidades reportadas" 2 "Con unidades imputadas"  ) pos(6)) ///
	ytitle(Millones de cigarrillos) scheme(plotplainblind)

save "$carpetaMadre\Data\Created data\monitoreo_tabaco.dta", replace


use "$carpetaMadre\Data\Created data\monitoreo_tabaco.dta", clear

tw (connected Q_imp FechaAño) (connected Q_impPeso FechaAño) (connected Q_exp FechaAño) (connected Q_expPeso FechaAño) (connected Q_vent FechaAño) ///
	, legend(order( 1 "Impor - rep" 2 "Impor - imp" 3 "Exp - rep" 4 "Exp - imp" 5 "Nacional"  ) pos(6) cols(3)) ///
	ytitle(Millones de cigarrillos) scheme(plotplainblind)
		
		