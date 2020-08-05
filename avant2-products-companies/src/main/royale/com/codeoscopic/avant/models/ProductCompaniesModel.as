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
package com.codeoscopic.avant.models
{
	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.collections.ArrayListView;
	import org.apache.royale.events.EventDispatcher;
	import com.codeoscopic.avant.vos.Product;

    /**
     *  Todo Model stores global model variables that are updated by controller
     *  and used in views to update visuals for the user
     */
	[Bindable]
	public class ProductCompaniesModel
	{
        public function ProductCompaniesModel():void
        {
            complementaryProduct = new Product();
            complementaryProduct.id = -1;
            complementaryProduct.name = complementariesProductLabel;
            complementaryProduct.icon = complementaryProductIcon;
        }

        /**
         * BUILD NUMBER
         */
        public static var buildNumber:String = BUILD::buildNumber;

        /**
         * Project Version
         */
        public static var projectVersion:String = BUILD::buildVersion;

        public static const LOADER_VIEW:String = "loader";
        public static const PRODUCTS_VIEW:String = "products";
        public static const COMPANIES_VIEW:String = "companies";

        public var products:ArrayList;
        public var sortedProducts:ArrayListView;
        
        public var complementaries:ArrayList;
        public var sortedComplementaries:ArrayListView;
        
        public var companies:ArrayList;
        public var sortedCompanies:ArrayListView;
        
        public var gridColumns:Array;

		public var selectedContent:String;
		
        public var complementaryProduct:Product;
        public var complementariesProductLabel:String = "Complementarios";
        public var complementaryProductIcon:String = "https://avant2.es/wp-content/uploads/2020/07/productos-complementarios.svg";
        public var numComplementariesProduct:int = 0;

        public var legendProviders:ArrayList = new ArrayList();
	}
}
