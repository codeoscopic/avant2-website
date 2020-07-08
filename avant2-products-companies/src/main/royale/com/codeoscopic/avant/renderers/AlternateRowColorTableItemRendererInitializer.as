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
package com.codeoscopic.avant.renderers
{	
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.jewel.beads.itemRenderers.TableItemRendererInitializer;
	import org.apache.royale.jewel.itemRenderers.TableItemRenderer;

	/**
	 *  The TableItemRendererInitializer class initializes item renderers
     *  in Table component.
	 *  
	 *  By Default this works the same as ListItemRendererInitializer, but create a placeholder
	 *  for it.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.10.0
	 */
	public class AlternateRowColorTableItemRendererInitializer extends TableItemRendererInitializer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
		public function AlternateRowColorTableItemRendererInitializer()
		{
		}

       /**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
        override protected function setupVisualsForItemRenderer(ir:IIndexedItemRenderer):void
        {
			var tir:TableItemRenderer = ir as TableItemRenderer;

            if (tir && ownerView)
                tir.itemRendererOwnerView = ownerView;

			var oddIndex:Boolean = tir.rowIndex % 2;
            (ir as UIBase).style = "background: rgb(" + (oddIndex ? "241, 248, 253" : "255, 255, 255") + ");";
		}
	}
}
