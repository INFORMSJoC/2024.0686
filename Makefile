init:
	julia -e "import Pkg; Pkg.add(path=\".\")"

pluto:
	cd results; julia -e "import Pluto; Pluto.run()"
