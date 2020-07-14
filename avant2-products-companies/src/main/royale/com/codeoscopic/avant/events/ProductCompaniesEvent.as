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
package com.codeoscopic.avant.events
{
	import org.apache.royale.events.Event;

	/**
	 * Todo Event
	 */
	public class ProductCompaniesEvent extends Event
	{
		/**
		 * Actions
		 */
		public static const LOAD_PRODUCTS:String = "load_products";
		public static const LOAD_COMPLEMENTARIES:String = "load_complementaries";
		public static const LOAD_COMPANIES:String = "load_companies";
		public static const GO_TO_GRID_VIEW:String = "go_to_grid_view";
		
		/**
         * constructor
		 * 
		 * This is just a normal Royale event which will be dispatched from a view instance.
		 * The only thing to note is that we set 'bubbles' to true, so that the event will bubble
		 * up the 'display' list, allowing Crux to listen for your events.
		 */ 
		public function ProductCompaniesEvent(type:String) {
			super(type, true);
		}
	}
}