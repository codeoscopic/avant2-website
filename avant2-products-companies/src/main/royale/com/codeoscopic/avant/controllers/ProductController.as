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
	import com.codeoscopic.avant.vos.Provider;

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

				var sort:Sort = new Sort();
				sort.fields = [new SortField("order", false, false, true)];
				var sortSubCias:Sort = new Sort();
				sortSubCias.fields = [new SortField("name", false, false)];
				
				model.products = new ArrayList();
				var product:Product;
				var company:Company;
				var provider:Provider;
				var companies:Array;
				var providers:Array;
				for (var i:int = 0; i < data.length; i++) {
					// don't add this product if we don't have any company in it
					if(!data[i].companies && !data[i].companieswip && !data[i].providers)
						continue;
					product = new Product();
					product.id = data[i].id;
					product.name = data[i].productname;
					product.description = data[i].productdescription;
					product.icon = data[i].producticon.guid;
					product.order = data[i].productorder;

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
					// now go over providers
					providers = data[i].providers;
					if(providers) {
						for (j = 0; j < providers.length; j++) {
							provider = new Provider();
							provider.id = providers[j].ID;
							provider.name = providers[j].providername;
							provider.logo = providers[j].providerlogo.guid;
							provider.color = providers[j].providercolor;

							// for now there can be only one provider
							product.provider = provider;
							
							for (var l:Object in providers[j].providerproducts)
							{
								if(providers[j].providerproducts[l].ID == product.id)
								{
									var companies_o:Object = providers[j].companies;
									for (var k:Object in companies_o)
									{
										company = new Company();
										company.id = companies_o[k].ID;
										company.name = companies_o[k].companyname;
										// console.log(" - ",company.name,company.id);
										company.logo = companies_o[k].companylogo.guid;
										company.provider = provider;
										product.companies.addItem(company);
									}
									continue;
								}
							}
							continue; // for now there can be only one provider
						}
					}
					product.companies.sort = sortSubCias;
					product.companies.refresh();

					model.products.addItem(product);
				}

				var alv:ArrayListView = new ArrayListView(model.products);
				alv.sort = sort;
				alv.refresh();

				model.sortedProducts = alv;

				createGridColumns();

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
				sort.fields = [new SortField("description", true, false)];

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
		private function createGridColumns():void
		{
			model.gridColumns = new Array();

			var column:TableColumn;
			var product:Product;

			for (var i:int = 0; i < model.sortedProducts.length; i++) {
				product = model.sortedProducts.getItemAt(i) as Product;

				// don't add this product if we don't have any company in it
				if(!product.companies)
						continue;
				column = new TableColumn();
				column.dataField = product.name;
				column.label = product.name + " (" + product.companies.length + ")";
				column.align = "center"
				model.gridColumns.push(column);
			}
			
			column = new TableColumn();
			column.dataField = "name";
			column.label = "Compañías";
			column.align = "center";
			column.itemRenderer = new ClassFactory(TableImageLogoItemRenderer);

			model.gridColumns.unshift(column);
		}
	}
}
