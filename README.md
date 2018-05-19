Azure App Service PHP Docker Build
==================================

Fork from https://github.com/Azure-App-Service/php

See details under https://github.com/joschi127/azure-app-service-php

With the following changes, optimized for running Symfony framework
based web applications:


* Added PHP extensions:
  * xml
  * simplexml
  * exif


* Changed Apache document root to:

        /home/site/wwwroot/web (instead of /home/site/wwwroot/)
        
  The document root can can be customized by setting the 
  APACHE_DOCUMENT_ROOT environment variable.


* Supports running an own post deployment / container startup script.
  Just put the script in your project root folder:

        /home/site/wwwroot/deploy-post-deployment.sh
        
  If the file exists in the filesystem, the script will be executed
  during container startu, before starting the Apache webserver.

  The path to the post deployment script can be customized by setting
  the POST_DEPLOYMENT_SCRIPT environment variable.
