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
	import com.codeoscopic.avant.services.CompanyDelegate;
	import com.codeoscopic.avant.vos.Company;
	import com.codeoscopic.avant.vos.Product;
	import com.codeoscopic.avant.vos.Provider;

	import mx.rpc.events.ResultEvent;

	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.collections.ArrayListView;
	import org.apache.royale.collections.Sort;
	import org.apache.royale.collections.SortField;
	import org.apache.royale.crux.utils.services.ServiceHelper;
	import org.apache.royale.jewel.supportClasses.table.TableColumn;

	/**
     * The Todo Controller holds all the global actions. The views dispatch events that bubbles and
	 * this class register to these evens and updates the model, so views can update accordingly using
	 * binding most of the times.
     */
	public class CompanyController
	{
		/**
		 * Crux will automatically create any Bean for the built-in helper classes
		 * if one has not been defined.
		 */ 
		[Inject]
		public var serviceHelper:ServiceHelper;
		
        /**
		 *  Common todo model
		 */
		[Inject(source = "productCompaniesModel")]
		public var model:ProductCompaniesModel;
		
		[Inject]
		public var companyService:CompanyDelegate;

		[EventHandler(event="ProductCompaniesEvent.LOAD_COMPANIES")]
		public function loadCompanies():void
		{
			if(model.companies == null){
				model.selectedContent = "loader";//ProductCompaniesModel.LOADER_VIEW;
				serviceHelper.executeServiceCall(companyService.loadCompanies(), loadCompaniesResultHandler);
			} else {
				model.selectedContent = "companies";//ProductCompaniesModel.COMPANIES_VIEW;
			}
		}
		
		public function loadCompaniesResultHandler(event:ResultEvent):void {
			if(model.companies == null) {
				var data:Object = JSON.parse(event.result as String);
				processCompaniesData(data);
				model.selectedContent = "gridview";//"companies";//ProductCompaniesModel.COMPANIES_VIEW;
			}
		}

		public function processCompaniesData(data:Object):void
		{
			var sort:Sort = new Sort();
			sort.fields = [new SortField("name", true, false)];

			model.companies = new ArrayList();
			var product:Product;
			var products:Array;

			var found:Boolean;
			for each(var provider:Provider in model.legendProviders)
			{
				for each(var company:Company in provider.product.companies)
				{
					found = false;
					for each(var c:Company in model.companies)
					{
						if(company.provider != null && c.id == company.id)
						{
							found = true;
							break;
						}
					}
					if(!found){
						if(company.products == null)
							company.products = new ArrayListView();
						company.products.addItem(provider.product);
						model.companies.addItem(company);						
					}
				}
			}
			
			for (var i:int = 0; i < data.length; i++)
			{	
				found = false;
				for each(company in model.companies)
				{
					if(company.id == data[i].id)
					{
						found = true;
						break;
					}
				}
				
				if(!found)
				{
					company = new Company();
					company.id = data[i].id;
					company.name = data[i].companyname;
					company.logo = data[i].companylogo.guid;
					company.hasComplementaries = data[i].companyhascomplementaries == 1 ? true : false;
					// don't add this company if we don't have any product in it
					// if(!data[i].products && !data[i].productswip && data[i].companyhascomplementaries != "1")//) && !hasProviders(data[i].products))
					// 	continue;
					model.companies.addItem(company);
				}

				// add products
				products = data[i].products;
				if(company.products == null)
					company.products = new ArrayListView();
				for (var j:int = 0; j < products.length; j++) {

					found = false;
					for each(var p:Product in company.products)
					{
						if(p.id == products[j].id)
						{
							found = true;
							break;
						}
					}

					if(!found)
					{
						product = new Product();
						product.id = products[j].ID;
						product.name = products[j].productname;
						product.icon = products[j].producticon.guid;
						
						company.products.addItem(product);
					}
				}

				// now go over products wip
				products = data[i].productswip;
				if(products)
				{
					for (j = 0; j < products.length; j++) {
						product = new Product();
						product.id = products[j].ID;
						product.name = products[j].productname;
						product.icon = products[j].producticon.guid;
						product.wip = true;
						company.products.addItem(product);
					}
				}

				if(company.hasComplementaries)
				{
					product = model.complementaryProduct;
					company.products.addItem(product);
					
					// increment counter to show in table
					model.numComplementariesProduct++;
				}
				
				company.products.sort = sort;
				company.products.refresh();
			}


			// now that we have all the fake complementaries add the column to the table
			var column:TableColumn = new TableColumn();
			column.dataField = model.complementariesProductLabel;
			column.label = model.complementariesProductLabel + " (" + model.numComplementariesProduct + ")";
			column.align = "center";
			model.gridColumns.push(column);

			var alv:ArrayListView = new ArrayListView(model.companies);
			alv.sort = sort;
			alv.refresh();

			model.sortedCompanies = alv;
		}

		[EventHandler(event="ProductCompaniesEvent.GO_TO_GRID_VIEW")]
		public function goToGridView():void
		{
			if(model.companies == null){
				model.selectedContent = "loader";//ProductCompaniesModel.LOADER_VIEW;
				serviceHelper.executeServiceCall(companyService.loadCompanies(), goToGridViewResultHandler);
			} else {
				model.selectedContent = "gridview";//ProductCompaniesModel.COMPANIES_VIEW;
			}
		}

		public function goToGridViewResultHandler(event:ResultEvent):void {
			if(model.companies == null) {
				var data:Object = JSON.parse(event.result as String);
				processCompaniesData(data);
				model.selectedContent = "gridview";//ProductCompaniesModel.COMPANIES_VIEW;
			}
		}
	}
}
