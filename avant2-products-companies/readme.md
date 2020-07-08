<!--

  Copyright (C) 2020, Codeoscopic S.A. - All Rights Reserved
  Unauthorized copying of this file, via any medium is strictly prohibited
  Proprietary and confidential

  Copyright (C) 2020, Codeoscopic S.A. - Todos Los Derechos Reservados
  La copia no autorizada de este archivo, a través de cualquier medio está estrictamente prohibida
  Privado y confidencial

-->

# Avant2 - Products & Companies


A widget for Avant2.es web page to show the current products and companies that are available (or in progress) in Codeoscopic's Avant2 insurance aggregator product.

The widget is coded in Apache Royale and consume data from Avant2.es WordPress CMS website exposed throught the WP REST API. The website implements CPT (Custom Post Types) as the data structure to allow add new products and companies and create the relationships easily thtough the WP admin interface.

The Royale front end used Jewel UI Set with customized look and feel to adapt to the Avant2.es website. Also Crux micro framework is used to add DI (Dependency Injection), IoC (Inversion of Control), Beans, event handling and more.