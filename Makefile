.PHONY: init data baseline train deploy prepare-deployment test-endpoint

DEPLOYMENT_DIR = deployment_dir


data:
	python src/data.py

baseline:
	python src/baseline_model.py

train:
	python src/train.py

prepare-deployment:
	rm -rf $(DEPLOYMENT_DIR) && mkdir $(DEPLOYMENT_DIR)
	cp -r src/predict.py $(DEPLOYMENT_DIR)/main.py
	cp -r src $(DEPLOYMENT_DIR)/src/
	# pip install cerebrium --upgrade # otherwise cerebrium deploy might fail

deploy: prepare-deployment
	cd $(DEPLOYMENT_DIR) && cerebrium deploy --api-key $(CEREBRIUM_API_KEY) --hardware CPU eth-price-1-hour-predictor

test-endpoint:
	python src/test_endpoint.py
