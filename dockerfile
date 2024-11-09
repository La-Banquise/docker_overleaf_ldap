FROM    --platform=$TARGETOS/$TARGETARCH sharelatex/sharelatex:5.1.1

LABEL org.opencontainers.image.source="https://github.com/la-banquise/docker_overleaf_ldap"

RUN 	apt-get update #apk add --update curl 
		#&& apk add --update bash \
#		&& rm -rf /var/cache/apk/* \
#		&& adduser -D container

#USER        container
#ENV         USER=container HOME=/home/container
#WORKDIR     /home/container

#COPY        ./entrypoint.sh /entrypoint.sh
#CMD         [ "/bin/bash", "/entrypoint.sh" ]

WORKDIR /overleaf/services/web

# latex-bin must be on path to be found in compilation process
# needed for biber epstopdf and others
ENV PATH="/usr/local/texlive/2023/bin/x86_64-linux:${PATH};"

# overwrite some files
COPY src/AuthenticationManager.js    /overleaf/services/web/app/src/Features/Authentication/
COPY src/AuthenticationController.js /overleaf/services/web/app/src/Features/Authentication/
COPY src/ContactController.js        /overleaf/services/web/app/src/Features/Contacts/
COPY src/router.js                   /overleaf/services/web/app/src/router.js

# Too much changes to do inline (>10 Lines).
COPY src/settings.pug    /overleaf/services/web/app/views/user/
COPY src/login.pug       /overleaf/services/web/app/views/user/
COPY src/register.pug       /overleaf/services/web/app/views/user/
COPY src/navbar-website-redesign.pug      /overleaf/services/web/app/views/layout/
COPY src/navbar-marketing.pug      /overleaf/services/web/app/views/layout/

# Non LDAP User Registration for Admins
COPY src/admin-index.pug     /overleaf/services/web/app/views/admin/index.pug
COPY src/admin-sysadmin.pug  /tmp/admin-sysadmin.pug
