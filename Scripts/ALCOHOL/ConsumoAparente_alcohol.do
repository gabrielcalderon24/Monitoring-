clear all
// Construcción consumo aparente de alcohol

///////////////////////////
**# Importaciones /////////
///////////////////////////


/////// Voy a quitar los que tienen alcohol etílico en importaciones/exportaciones ////////////////// 
 
 //2207100000, /// // Alcohol etílico sin desnaturalizar con grado alcohólico volumétrico superior o igual al 80% vol.
 //2207200000, /// // Alcohol etílico y aguardiente desnaturalizados, de cualquier graduación.
 //2207200010, /// // Alcohol etílico o etanol, de contenido alcohólico volumétrico superior o igual al 96,3 % vol, desnaturalizado con gasolina 
 //2207200090, /// // Los demás Alcohol etílico y aguardiente desnaturalizados, de cualquier graduación

import excel "$carpetaMadre\Data\1_Importaciones y exportaciones 2014 a 2023 - 2024DP000063623 PQSR.xlsx", sheet("Importaciones 2014-2023") cellrange(A4:AQ11900) firstrow clear

keep if inlist(SubpartidaArancelaria, ///
    2207100000, /// Alcohol etílico sin desnaturalizar, mayor a 80%
    2203000000, /// Cerveza de malta
    2204100000, /// vino espumoso
    2204210000, /// Vinos en recipientes con capacidad inferior o igual a 2 l.
    2204221000, /// Mosto de uva en el que la fermentación se ha impedido o cortado añadiendo alcohol en recipientes con capacidad superior a 2 l pero
    2204229000, /// Los demás vinos en recipientes con capacidad superior a 2 l pero inferior o igual a 10 l.
    2204291000, /// Mosto de uva en el que la fermentación se ha impedido o cortado añadiendo alcohol (mosto apagado)
    2204299000, /// Los demás vinos de uvas frescas.
    2204300000, /// Los demás mostos de uva, excepto el de la partida 20.09.
    2205100000, /// Vermuts y demás vinos en recipientes con capacidad inferior o igual a 2 litros.
    2205900000, /// Los demás vinos de uvas frescas, preparados con plantas o sustancias aromáticas.
    2206000000, /// Las demás bebidas fermentadas (por ejemplo: sidra, perada, aguamiel); mezclas de bebidas fermentadas y mezclas de bebidas fermentadas
    2208202100, /// Aguardiente de vino: pisco
    2208202900, /// Los demás aguardientes de vino: "coñac", "brandys".
    2208203000, /// Aguardiente de orujo de uva (grapa y similares).
    2208300000, /// Whisky.
    2208400000, /// Ron y demás aguardientes procedentes de la destilación, previa fermentación, de productos de la caña de azúcar.
    2208500000, /// "Gin" y ginebra
    2208600000, /// Vodka.
    2208701000, /// Licores de anís.
    2208702000, /// Cremas.
    2208709000, /// Los demás licores.
    2208901000, /// Alcohol etílico sin desnaturalizar con grado alcohólico volumétrico inferior al 80% vol.
    2208902000, /// Aguardiente de agaves (tequila y similares)
    2208904900, /// Los demás aguardientes.
    2208909000  /// Los demás licores.
)


drop R- AQ
tab FechaAño PorcentajeArancel
tab FechaAño PorcentajeIVA



* Tomamos unidades comerciales en este caso como litros 

collapse (sum) TotalArancel TotalIVA Q_imp=CantidadUnidadesComerciales, by(FechaAño)
destring FechaAño, replace
tempfile importaciones
save `importaciones'


////////////////////////////////////////////////////////////////////////////////
**# Exportaciones
////////////////////////////////////////////////////////////////////////////////

import excel "$carpetaMadre\Data\1_Importaciones y exportaciones 2014 a 2023 - 2024DP000063623 PQSR.xlsx", sheet("Exportaciones 2014-2023") cellrange(A4:M3629) firstrow clear
keep if inlist(SubpartidaArancelaria, ///
    2207100000, /// Alcohol etílico sin desnaturalizar, mayor a 80%
    2203000000, /// Cerveza de malta
    2204100000, /// vino espumoso
    2204210000, /// Vinos en recipientes con capacidad inferior o igual a 2 l.
    2204221000, /// Mosto de uva en el que la fermentación se ha impedido o cortado añadiendo alcohol en recipientes con capacidad superior a 2 l pero
    2204229000, /// Los demás vinos en recipientes con capacidad superior a 2 l pero inferior o igual a 10 l.
    2204291000, /// Mosto de uva en el que la fermentación se ha impedido o cortado añadiendo alcohol (mosto apagado)
    2204299000, /// Los demás vinos de uvas frescas.
    2204300000, /// Los demás mostos de uva, excepto el de la partida 20.09.
    2205100000, /// Vermuts y demás vinos en recipientes con capacidad inferior o igual a 2 litros.
    2205900000, /// Los demás vinos de uvas frescas, preparados con plantas o sustancias aromáticas.
    2206000000, /// Las demás bebidas fermentadas (por ejemplo: sidra, perada, aguamiel); mezclas de bebidas fermentadas y mezclas de bebidas fermentadas
    2208202100, /// Aguardiente de vino: pisco
    2208202900, /// Los demás aguardientes de vino: "coñac", "brandys".
    2208203000, /// Aguardiente de orujo de uva (grapa y similares).
    2208300000, /// Whisky.
    2208400000, /// Ron y demás aguardientes procedentes de la destilación, previa fermentación, de productos de la caña de azúcar.
    2208500000, /// "Gin" y ginebra
    2208600000, /// Vodka.
    2208701000, /// Licores de anís.
    2208702000, /// Cremas.
    2208709000, /// Los demás licores.
    2208901000, /// Alcohol etílico sin desnaturalizar con grado alcohólico volumétrico inferior al 80% vol.
    2208902000, /// Aguardiente de agaves (tequila y similares)
    2208904900, /// Los demás aguardientes.
    2208909000  /// Los demás licores.
)



	
collapse (sum) Q_exp=CantidadUnidadesComerciales, by(FechaAño)
destring FechaAño, replace

tempfile exportaciones
save `exportaciones'
		
////////////////////////////////////////////////////////////////////////////////
**# Producción Nacional
////////////////////////////////////////////////////////////////////////////////

/// En producción no hay alcohol etílico, no parece haber la necesidad de corregir ////////////////

clear
set obs 1
gen uno=1
tempfile produccion
save `produccion'

import excel "$carpetaMadre\Data\EAM\c6_2_14.xlsx", sheet("c6_2_14") cellrange(A10:I3323) firstrow clear
keep if CÓDIGOCPC == "2411001" | CÓDIGOCPC == "2413101" | CÓDIGOCPC == "2413104" | CÓDIGOCPC == "2413199" | CÓDIGOCPC == "2413105" | CÓDIGOCPC == "2413102" | CÓDIGOCPC == "2413109" | CÓDIGOCPC == "2413103" | CÓDIGOCPC == "2413106" | CÓDIGOCPC == "2413110" |CÓDIGOCPC == "2413111" | CÓDIGOCPC == "2413901" | CÓDIGOCPC == "2421101" | CÓDIGOCPC == "2421202" | CÓDIGOCPC == "2423002" | CÓDIGOCPC == "2423003" | CÓDIGOCPC == "2431001" | CÓDIGOCPC == "2431002" | CÓDIGOCPC == "2431004" 

gen year=2014
rename ARTÍCULOSCONPRODUCCIÓN ARTÍCULOS
append using `produccion'
save `produccion', replace

import excel "$carpetaMadre\Data\EAM\Anexos_EAM_desagregacion_variables_2015.xls", sheet("6,2") cellrange(A12:I3340) firstrow clear
keep if CÓDIGOCPC == "2411001" | CÓDIGOCPC == "2413101" | CÓDIGOCPC == "2413104" | CÓDIGOCPC == "2413199" | CÓDIGOCPC == "2413105" | CÓDIGOCPC == "2413102" | CÓDIGOCPC == "2413109" | CÓDIGOCPC == "2413103" | CÓDIGOCPC == "2413106" | CÓDIGOCPC == "2413110" |CÓDIGOCPC == "2413111" | CÓDIGOCPC == "2413901" | CÓDIGOCPC == "2421101" | CÓDIGOCPC == "2421202" | CÓDIGOCPC == "2423002" | CÓDIGOCPC == "2423003" | CÓDIGOCPC == "2431001" | CÓDIGOCPC == "2431002" | CÓDIGOCPC == "2431004" 
gen year=2015
rename ARTÍCULOSCONPRODUCCIÓN ARTÍCULOS
append using `produccion'
save `produccion', replace

import excel "$carpetaMadre\Data\EAM\Anexos_EAM_desagregacion_variables_2016.xls", sheet("6.2") cellrange(A14:I3293) firstrow clear
keep if CÓDIGOCPC == "2411001" | CÓDIGOCPC == "2413101" | CÓDIGOCPC == "2413104" | CÓDIGOCPC == "2413199" | CÓDIGOCPC == "2413105" | CÓDIGOCPC == "2413102" | CÓDIGOCPC == "2413109" | CÓDIGOCPC == "2413103" | CÓDIGOCPC == "2413106" | CÓDIGOCPC == "2413110" |CÓDIGOCPC == "2413111" | CÓDIGOCPC == "2413901" | CÓDIGOCPC == "2421101" | CÓDIGOCPC == "2421202" | CÓDIGOCPC == "2423002" | CÓDIGOCPC == "2423003" | CÓDIGOCPC == "2431001" | CÓDIGOCPC == "2431002" | CÓDIGOCPC == "2431004" 
gen year=2016
rename ARTÍCULOSCONPRODUCCIÓN ARTÍCULOS
append using `produccion'
save `produccion', replace

// EN 2017 todos los códigos tienen un 0 al principio//
import excel "$carpetaMadre\Data\EAM\Anexos_EAM_desagregacion_variables_2017.xls", sheet("6.2") cellrange(A13:I3228) firstrow clear
keep if CÓDIGOCPC == "02411001" | CÓDIGOCPC == "02413101" | CÓDIGOCPC == "02413104" | CÓDIGOCPC == "02413199" | CÓDIGOCPC == "02413105" | CÓDIGOCPC == "02413102" | CÓDIGOCPC == "02413109" | CÓDIGOCPC == "02413103" | CÓDIGOCPC == "02413106" | CÓDIGOCPC == "02413110" |CÓDIGOCPC == "02413111" | CÓDIGOCPC == "02413901" | CÓDIGOCPC == "02421101" | CÓDIGOCPC == "02421202" | CÓDIGOCPC == "02423002" | CÓDIGOCPC == "02423003" | CÓDIGOCPC == "02431001" | CÓDIGOCPC == "02431002" | CÓDIGOCPC == "02431004" 

gen year=2017
rename ARTÍCULOSCONPRODUCCIÓN ARTÍCULOS
append using `produccion'
save `produccion', replace

import excel "$carpetaMadre\Data\EAM\Anexos_EAM_desagregacion_variables_2018.xls", sheet("6.2") cellrange(A13:I3279) firstrow clear 
keep if CÓDIGOCPC == "2411001" | CÓDIGOCPC == "2413101" | CÓDIGOCPC == "2413104" | CÓDIGOCPC == "2413199" | CÓDIGOCPC == "2413105" | CÓDIGOCPC == "2413102" | CÓDIGOCPC == "2413109" | CÓDIGOCPC == "2413103" | CÓDIGOCPC == "2413106" | CÓDIGOCPC == "2413110" |CÓDIGOCPC == "2413111" | CÓDIGOCPC == "2413901" | CÓDIGOCPC == "2421101" | CÓDIGOCPC == "2421202" | CÓDIGOCPC == "2423002" | CÓDIGOCPC == "2423003" | CÓDIGOCPC == "2431001" | CÓDIGOCPC == "2431002" | CÓDIGOCPC == "2431004" 
gen year=2018
append using `produccion'
save `produccion', replace


import excel "$carpetaMadre\Data\EAM\Anexos_EAM_desagregacion_variables_2019.xls", sheet("6.2") cellrange(A13:I3232) firstrow clear
keep if CÓDIGOCPC == "2411001" | CÓDIGOCPC == "2413101" | CÓDIGOCPC == "2413104" | CÓDIGOCPC == "2413199" | CÓDIGOCPC == "2413105" | CÓDIGOCPC == "2413102" | CÓDIGOCPC == "2413109" | CÓDIGOCPC == "2413103" | CÓDIGOCPC == "2413106" | CÓDIGOCPC == "2413110" |CÓDIGOCPC == "2413111" | CÓDIGOCPC == "2413901" | CÓDIGOCPC == "2421101" | CÓDIGOCPC == "2421202" | CÓDIGOCPC == "2423002" | CÓDIGOCPC == "2423003" | CÓDIGOCPC == "2431001" | CÓDIGOCPC == "2431002" | CÓDIGOCPC == "2431004" 
gen year=2019
append using `produccion'
save `produccion', replace

import excel "$carpetaMadre\Data\EAM\Anexos_EAM_desagregacion_variables_2020.xls", sheet("6.2") cellrange(A13:I3228) firstrow clear
keep if CÓDIGOCPC == "2411001" | CÓDIGOCPC == "2413101" | CÓDIGOCPC == "2413104" | CÓDIGOCPC == "2413199" | CÓDIGOCPC == "2413105" | CÓDIGOCPC == "2413102" | CÓDIGOCPC == "2413109" | CÓDIGOCPC == "2413103" | CÓDIGOCPC == "2413106" | CÓDIGOCPC == "2413110" |CÓDIGOCPC == "2413111" | CÓDIGOCPC == "2413901" | CÓDIGOCPC == "2421101" | CÓDIGOCPC == "2421202" | CÓDIGOCPC == "2423002" | CÓDIGOCPC == "2423003" | CÓDIGOCPC == "2431001" | CÓDIGOCPC == "2431002" | CÓDIGOCPC == "2431004" 
gen year=2020
append using `produccion'
save `produccion', replace

import excel "$carpetaMadre\Data\EAM\Anexos_EAM_desagregacion_variables_2021.xlsx", sheet("6.2") cellrange(A13:I3217) firstrow clear
keep if CÓDIGOCPC == "2411001" | CÓDIGOCPC == "2413101" | CÓDIGOCPC == "2413104" | CÓDIGOCPC == "2413199" | CÓDIGOCPC == "2413105" | CÓDIGOCPC == "2413102" | CÓDIGOCPC == "2413109" | CÓDIGOCPC == "2413103" | CÓDIGOCPC == "2413106" | CÓDIGOCPC == "2413110" |CÓDIGOCPC == "2413111" | CÓDIGOCPC == "2413901" | CÓDIGOCPC == "2421101" | CÓDIGOCPC == "2421202" | CÓDIGOCPC == "2423002" | CÓDIGOCPC == "2423003" | CÓDIGOCPC == "2431001" | CÓDIGOCPC == "2431002" | CÓDIGOCPC == "2431004" 
gen year=2021
append using `produccion'
save `produccion', replace

import excel "$carpetaMadre\Data\EAM\anex-EAM-desagregacion-2022.xlsx", sheet("6.2") cellrange(A13:I3176) firstrow clear
keep if CÓDIGOCPC == "2411001" | CÓDIGOCPC == "2413101" | CÓDIGOCPC == "2413104" | CÓDIGOCPC == "2413199" | CÓDIGOCPC == "2413105" | CÓDIGOCPC == "2413102" | CÓDIGOCPC == "2413109" | CÓDIGOCPC == "2413103" | CÓDIGOCPC == "2413106" | CÓDIGOCPC == "2413110" |CÓDIGOCPC == "2413111" | CÓDIGOCPC == "2413901" | CÓDIGOCPC == "2421101" | CÓDIGOCPC == "2421202" | CÓDIGOCPC == "2423002" | CÓDIGOCPC == "2423003" | CÓDIGOCPC == "2431001" | CÓDIGOCPC == "2431002" | CÓDIGOCPC == "2431004" 
gen year=2022
append using `produccion'
save `produccion', replace


drop if uno==1
drop uno


destring PRODUCCIÓN VENTAS, replace
collapse (sum) Q_prod= PRODUCCIÓN Q_vent=VENTAS , by(year)
rename year FechaAño

tempfile produccion
save `produccion'		
		
////////////////////////////////////////////////////////////////////////////////
**# Construccion Consumpo aparente y consolidación
////////////////////////////////////////////////////////////////////////////////	
use `importaciones', clear
merge 1:1 FechaAño using `exportaciones', nogen
merge 1:1 FechaAño using `produccion', nogen
		
gen consumoAparente = Q_imp + Q_vent - Q_exp
format consumoAparente %20.2f

// Graficar sobre miles de millones
replace consumoAparente = consumoAparente/1000000000 		
tw connected consumoAparente FechaAño, ///
    title("Consumo aparente de alcohol (miles de millones de litros)")

save "$carpetaMadre\Data\Created data\consumoaparente_alcohol.dta", replace