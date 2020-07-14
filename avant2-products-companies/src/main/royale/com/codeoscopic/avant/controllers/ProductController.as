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
package com.codeoscopic.avant.controllers
{
	import com.codeoscopic.avant.models.ProductCompaniesModel;
	import com.codeoscopic.avant.renderers.TableImageLogoItemRenderer;
	import com.codeoscopic.avant.services.ComplementaryDelegate;
	import com.codeoscopic.avant.services.ProductDelegate;
	import com.codeoscopic.avant.vos.Company;
	import com.codeoscopic.avant.vos.Complementary;
	import com.codeoscopic.avant.vos.Product;

	import mx.rpc.events.ResultEvent;

	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.collections.ArrayListView;
	import org.apache.royale.collections.Sort;
	import org.apache.royale.collections.SortField;
	import org.apache.royale.core.ClassFactory;
	import org.apache.royale.crux.utils.services.ServiceHelper;
	import org.apache.royale.jewel.supportClasses.table.TableColumn;
	
	/**
     * The Product Controller holds the product operations. The views dispatch events that bubbles and
	 * this class register to these evens and updates the model, so views can update accordingly using
	 * binding most of the times.
     */
	public class ProductController
	{
		/**
		 * Crux will automatically create any Bean for the built-in helper classes
		 * if one has not been defined.
		 */ 
		[Inject]
		public var serviceHelper:ServiceHelper;
		
        /**
		 *  Common model
		 */
		[Inject(source = "productCompaniesModel")]
		public var model:ProductCompaniesModel;

		[Inject]
		public var productDelegate:ProductDelegate;
		
		[Inject]
		public var complementaryDelegate:ComplementaryDelegate;

		/**
		 *  [PostConstruct] methods are invoked after all dependencies are injected.
		 *  This is the starting point of the application dta retrieve.
		 * Initializing the widget by loading all products
		 */
		[PostConstruct]
		public function setUp():void {
			loadProducts();
			loadComplementaries();
        }

		/**
		 * load all products from the server
		 */
		[EventHandler(event="ProductCompaniesEvent.LOAD_PRODUCTS")]
		public function loadProducts():void
		{
			if(model.products == null){
				model.selectedContent = "loader";//ProductCompaniesModel.LOADER_VIEW;
				serviceHelper.executeServiceCall(productDelegate.loadProducts(), loadProductsResultHandler);
			} else {
				model.selectedContent = "products";//ProductCompaniesModel.PRODUCTS_VIEW;
			}
		}

		/**
		 * load products call back. We get results from server and generate
		 * front end data structures.
		 */
		private function loadProductsResultHandler(event:ResultEvent):void {
			if(model.products == null){
				var data:Object = JSON.parse(event.result as String);

				createGridColumns(data);

				var sort:Sort = new Sort();
				sort.fields = [new SortField("name", true, false)];
				
				model.products = new ArrayList();
				var product:Product;
				var company:Company;
				var companies:Array;
				var companies_wip:Array;
				for (var i:int = 0; i < data.length; i++) {
					// don't add this product if we don't have any company in it
					if(!data[i].companies && !data[i].companieswip)
						continue;
					product = new Product();
					product.id = data[i].id;
					product.name = data[i].productname;
					product.description = data[i].productdescription;
					product.image = data[i].productimage.guid;

					// add companies	
					companies = data[i].companies;
					product.companies = new ArrayListView();
					for (var j:int = 0; j < companies.length; j++) {
						company = new Company();
						company.id = companies[j].ID;
						company.name = companies[j].companyname;
						company.logo = companies[j].companylogo.guid;
						product.companies.addItem(company);
					}
					// now go over companies wip
					companies = data[i].companieswip;
					if(companies) {
						for (j = 0; j < companies.length; j++) {
							company = new Company();
							company.id = companies[j].ID;
							company.name = companies[j].companyname;
							company.logo = companies[j].companylogo.guid;
							company.wip = true;
							product.companies.addItem(company);
						}
					}
					product.companies.sort = sort;
					product.companies.refresh();

					model.products.addItem(product);
				}

				var alv:ArrayListView = new ArrayListView(model.products);
				alv.sort = sort;
				alv.refresh();

				model.sortedProducts = alv;

				model.selectedContent = "products";//ProductCompaniesModel.PRODUCTS_VIEW;
			}
		}

		/**
		 * load all complementary products from the server
		 */
		[EventHandler(event="ProductCompaniesEvent.LOAD_COMPLEMENTARIES")]
		public function loadComplementaries():void
		{
			if(model.complementaries == null){
				model.selectedContent = "loader";//ProductCompaniesModel.LOADER_VIEW;
				serviceHelper.executeServiceCall(complementaryDelegate.loadComplementaries(), loadComplementariesResultHandler);
			} else {
				model.selectedContent = "products";//ProductCompaniesModel.PRODUCTS_VIEW;
			}
		}

		/**
		 * load complementary products call back. We get results from server and generate
		 * front end data structures.
		 */
		private function loadComplementariesResultHandler(event:ResultEvent):void {
			if(model.products == null){
				var data:Object = JSON.parse(event.result as String);

				var sort:Sort = new Sort();
				sort.fields = [new SortField("name", true, false)];

				model.complementaries = new ArrayList();
				var complementary:Complementary;

				for (var i:int = 0; i < data.length; i++) {
					complementary = new Complementary();
					complementary.id = data[i].id;
					complementary.name = data[i].complementaryname;
					complementary.description = data[i].complementarydescription;
					complementary.image = data[i].complementaryimage.guid;

					model.complementaries.addItem(complementary);
				}

				var alv:ArrayListView = new ArrayListView(model.complementaries);
				alv.sort = sort;
				alv.refresh();

				model.sortedComplementaries = alv;

				// model.selectedContent = "products";//ProductCompaniesModel.PRODUCTS_VIEW;
			}
		}

		/**
		 * Generate the grid columns depending on the products we retrieve from the server
		 */
		private function createGridColumns(data:Object):void
		{
			model.gridColumns = new Array();

			var column:TableColumn;

			for (var i:int = 0; i < data.length; i++) {
				// don't add this product if we don't have any company in it
				if(!data[i].companies)
						continue;
				column = new TableColumn();
				column.dataField = data[i].productname;
				column.label = data[i].productname;
				column.align = "center"
				model.gridColumns.push(column);
			}

			model.gridColumns = model.gridColumns.sort(sortAlphabetic);
			
			column = new TableColumn();
			column.dataField = "name";
			column.label = "Compañía";
			column.align = "center"
			column.itemRenderer = new ClassFactory(TableImageLogoItemRenderer);

			model.gridColumns.unshift(column);
		}

		/**
		 * to sort the array of columns in alphabetic order
		 */
		private function sortAlphabetic(a:Object, b:Object):int
		{
			if(a.label < b.label) 
				return -1;
			if(a.label > b.label)
				return 1;
			return 0;
		}
	}
}
