# Serverless Flask Application

This project demonstrates a serverless architecture for a Flask application using AWS services. The application uses AWS Lambda to host the Flask app, API Gateway to handle API requests, S3 for static website hosting, CloudFront as a CDN, and Parameter Store for managing configuration variables. Infrastructure is managed using Terraform.

## Table of Contents

- [Architecture](#architecture)
- [Features](#features)
- [Requirements](#requirements)
- [Best Practices](#best-practices)
- [Notes](#notes)

## Architecture

1. **AWS Lambda**: Hosts the Flask application.
2. **API Gateway**: Acts as a front door to the Lambda function, handling API requests.
3. **S3**: Hosts the static website, including `index.html`.
4. **CloudFront**: Distributes the content from S3 globally with low latency.
5. **Parameter Store**: Stores important configuration variables securely.

## Features

- **Serverless Flask**: Deploy a Flask app on AWS Lambda, enabling a pay-per-use model.
- **Static Website Hosting**: Host static files (HTML, CSS, JS) on S3 with CloudFront CDN.
- **API Integration**: Use API Gateway to connect the frontend with the backend.
- **Configuration Management**: Securely manage application configurations using AWS Parameter Store.
- **Optimized Cold Start**: Use CloudWatch Events to warm up the Lambda function to reduce cold start latency.

## Requirements

- AWS Account
- AWS CLI configured with necessary permissions
- Python 3.8+
- Flask
- Terraform

## Best Practices

    Lambda Warm-Up: Use CloudWatch Events to reduce cold start times by periodically invoking the Lambda function.
    Parameter Store: Use AWS Parameter Store to manage sensitive configurations securely.
    Monitor Performance: Use AWS CloudWatch to monitor the performance and set alarms for any anomalies.
    Optimize Static Content: Leverage CloudFront for faster content delivery and better caching.

## Notes

While running a Flask application on Lambda is possible, it's essential to recognize that it might not be the best practice for all use cases due to cold start latency and other factors. Consider alternatives like AWS Fargate or other container services for long-running applications.
