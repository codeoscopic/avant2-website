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
package com.codeoscopic.avant.vos
{
    import org.apache.royale.collections.ArrayListView;

    [Bindable]
    public class Product
    {
        public var id:Number;
        public var name:String;
        public var description:String;
        public var icon:String;
        public var companies:ArrayListView;
        public var wip:Boolean;
        public var order:int;
    }
}
