all:
	docker build . -t mds

rstudio:
	docker run \
		-it \
		-p 8787:8787 \
		-p 8888:8888 \
		--rm \
		mds

rs:
	make rstudio

jl:
	docker run \
		-it \
		-p 8787:8787 \
		-p 8888:8888 \
		--rm \
		mds \
		jupyter-lab --port=8888 --no-browser --ip=0.0.0.0 --allow-root --LabApp.token=''
