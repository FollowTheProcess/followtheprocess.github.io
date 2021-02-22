help:
	@echo "Available Commands:\n"
	@echo " - build     :  Builds the site."
	@echo " - serve     :  Builds and serves with autoload and drafts enabled."

build:
	hugo

serve:
	hugo server --disableFastRender -D
