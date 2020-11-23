ACCOUNT_ID?=546525900473
AWS_REGION?=us-east-1


build-push-app:
	docker build -t gravatar-service gravatar-app/.
	docker tag gravatar-service:latest ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/gravatar-service:latest
	docker push ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/gravatar-service:latest

.PHONY: build-push-app