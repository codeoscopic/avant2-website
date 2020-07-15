/////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2020, Codeoscopic S.A. - All Rights Reserved
//  Unauthorized copying of this file, via any medium is strictly prohibited
//  Proprietary and confidential
//
//  Copyright (C) 2020, Codeoscopic S.A. - Todos Los Derechos Reservados
//  La copia no autorizada de este archivo, a través de cualquier medio está estrictamente prohibida
//  Privado y confidencial
//
////////////////////////////////////////////////////////////////////////////////
package
{
	import html2pdf.Worker;

	/**
	 * We use the <script src="assets/js/html2pdf.bundle.min.js"></script>
	 * with node cloning
	 * 
	 * <inject_script>
	 * var script = document.createElement("script");
	 * script.setAttribute("src", "js/html2pdf.bundle.min.js");
	 * document.head.appendChild(script);
	 * </inject_script>
	 * 
	 * @externs
	*/
	COMPILE::JS
	public function html2pdf(element:Element = null):Worker {
		return null;		
	}	
}