build:
	docker build -t pa11y-ci .

test:
	docker run -it -v /vagrant/pa11y/screenshots:/screenshots -e BASE_URL=https://dev.paycleanairzonecharge.co.uk/ pa11y-ci
