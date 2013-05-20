all: lib/infatuate.js lib/cli.js

lib/infatuate.js: src/infatuate.coffee
	coffee  -o lib -c src/infatuate.coffee

lib/cli.js: src/cli.coffee
	echo "#!/usr/bin/env node" > lib/cli.js
	coffee -p -c src/cli.coffee >> lib/cli.js
