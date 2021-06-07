FROM node:10-slim      
                                   
RUN apt-get update && apt-get install -yq libgconf-2-4 ca-certificates gnupg
RUN apt-get update && apt-get install -y wget --no-install-recommends \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
 && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
        libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
        --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /src/*.deb

RUN npm install -g pa11y-ci --unsafe-perm=true --allow-root

COPY /.pa11yci.conf.js /.pa11yci.conf.js

ENV BASE_URL=https://VCCTestUser1:CleanAir99@dev.cleanairzonevehiclecheck.co.uk
CMD ["/usr/local/bin/pa11y-ci", "-c", ".pa11yci.conf.js"]