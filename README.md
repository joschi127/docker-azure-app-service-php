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


* Added PHP INI settings:
  * memory_limit = 2048M
  * max_execution_time  = 900
  * max_input_time      = 300
  * post_max_size       = 500M
  * upload_max_filesize = 500M
  * max_input_vars = 10000
  * expose_php = off


* Changed Apache document root to:

        /home/site/wwwroot/web (instead of /home/site/wwwroot/)
        
  The document root can can be customized by setting the 
  APACHE_DOCUMENT_ROOT environment variable.


* Added Apache security headers:
  * Header always set Strict-Transport-Security max-age=31536000


* Supports running an own post deployment / container startup script.
  Just put the script in your project root folder:

        /home/site/wwwroot/deploy-post-deployment.sh
        
  If the file exists in the filesystem, the script will be executed
  during container startu, before starting the Apache webserver.

  The path to the post deployment script can be customized by setting
  the POST_DEPLOYMENT_SCRIPT environment variable.


* Test created image

        # run container
        docker run --name test --detach --env MYVAR=foo joschi127/azure-app-service-php:latest

        # show logs
        docker logs test [ -f ]

        # open shell
        docker exec -i -t test /bin/bash

        # stop and remove
        docker stop test && docker rm test
