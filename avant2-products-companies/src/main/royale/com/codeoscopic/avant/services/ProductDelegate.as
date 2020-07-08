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
package com.codeoscopic.avant.services
{
    import mx.rpc.AsyncToken;
    import mx.rpc.http.HTTPService;

	public class ProductDelegate
	{
        [Inject(source = "productService", required="true")]
		public var service:HTTPService;

		public function loadProducts():AsyncToken {
			return service.send();
		}
	}
}
