Azure App Service PHP Docker Build
==================================

Fork from https://github.com/joschi127/azure-app-service-php

With the following changes, optimized for running Symfony framework
based web applications:


* Added PHP extensions:
  * xml
  * exif


* Changed Apache document root to:

        /home/site/wwwroot/web (instead of /home/site/wwwroot/)


* Allow to configure Apache document root by setting env variable:

        APACHE_DOCUMENT_ROOT = /any/other/path
