PORT := "8080"

local-run:
	PORT=$(PORT) crystal run src/app.cr

local-build:
	crystal build -p src/app.cr -o dist/app
