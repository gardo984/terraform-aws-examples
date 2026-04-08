#!/bin/bash

test -f function.zip && rm -rf function.zip && echo "removing old function.zip..."
test -d venv && rm -rf venv  && echo "removing old venv..."

python3.10 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
deactivate
cd venv/lib/python3.10/site-packages && \
	zip -r function.zip . && \
	cd - && \
	mv -v venv/lib/python3.10/site-packages/function.zip .
zip function.zip app.py