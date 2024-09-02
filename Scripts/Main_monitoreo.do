* Paths setting 
* global carpetaMadre= ".\..\" 
global carpetaMadre= "C:\Users\gabri\Universidad del rosario\Control Tabaco Facultad Economica - Documentos\Repositorio" 

* Los códigos en el repositorio están agrupados de acuerdo al producto: Tabaco, alcohol y bebidas azucaradas


**************************************
* A) Códigos correspondientes a Tabaco 

* A.1) Procesamiento unidades de cigarrillos consumidas en la ECV
do "TABACO/ecv_tabaco"	
* A.2) Procesamiento unidades de cigarrillos consumidas en la ENCSP  
do "TABACO\encsp_tabaco.do"
* A.3) Procesamiento recaudo ADRES 
do "TABACO\ADRES_tabaco.do"		
* A.4) Procesamiento consumo aparente (Producción + Imp - exp) 
do "TABACO\ConsumoAparente_tabaco"
* A.5) Procesamiento recaudo CHIP  

***************************************
* B) Códigos correspondientes a Alcohol  

* B.1) Procesamiento prevalencia y gasto en la ECV (bebidas alcohólicas)
do "ALCOHOL\alcohol_ECV.do"
* B.2) Procesamiento recaudo CHIP cerveza  

* B.2.1) Procesamiento recaudo CHIP Licores y vinos 
 
* B.3) Procesamiento recaudo ADRES 
	
* B.4) Procesamiento consumo aparente 
do "ALCOHOL\ConsumoAparente_alcohol"	

**************************************************
* C) Códigos correspondientes a Bebidas azucaradas y alimentos ultraprocesados

* C.1) Procesamiento prevalencia y consumo de Bebidas azucaradas ECV 
do "BEBIDAS AZUCARADAS\ecv_bebidas_azucaradas"	

* C.2) Procesamiento prevalencia, gasto y consumo de alimentos ultraprocesados ECV 
do "BEBIDAS AZUCARADAS\ecv_ultraprocesados"






