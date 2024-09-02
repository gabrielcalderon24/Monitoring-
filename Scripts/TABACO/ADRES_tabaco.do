* Procesamiento recaudo de impuestos según la ADRES 
clear
set obs 1
gen uno=1
tempfile recaudo
save `recaudo'

foreach year in 2019 2020 2021 2022 2023 {
	foreach month in "01" "02" "03" "04" "05" "06" "07" "08" "09" "11" "12" {
		disp in red "`year'`month'"
		import excel "$carpetaMadre\Data\Compilado ADRES recaudo.xlsx", sheet("`year'`month'") cellrange(A4:H36) clear
		gen year=`year'
		gen month=`month'
		append using `recaudo'
		save `recaudo', replace
	}
}

rename A departamento
rename B juegosyazar
rename C cerveza
rename D cigarrillos
rename E adValcigarrillos
rename F licores
rename G otros
rename H totales

drop if year==.
drop uno

foreach varo of varlist juegosyazar - totales {
	replace `varo'=subinstr(`varo',".","",.)
	replace `varo'=subinstr(`varo',",",".",.)
}
destring juegosyazar - totales , replace force

save "$carpetaMadre\Data\Created data\recaudoADRES.dta", replace


