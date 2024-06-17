🌐 Portfolio Website

Welcome to my portfolio website repository, where I showcase a sleek serverless architecture using AWS services. Initially, this project was built with Flask on the backend, but to boost performance and scalability, it has been migrated to a serverless setup. The frontend is developed with JavaScript and HTML, now hosted on Amazon S3 with CloudFront distribution.
🚀 Overview

The primary goal of this project is to provide a performant and scalable portfolio website. Transitioning from a Flask-based backend to a serverless architecture was driven by the need to reduce latency and improve the startup time of backend services.
✨ Key Features

    Frontend: Hosted on Amazon S3 with static HTML and JavaScript.
    Backend: AWS Lambda functions for handling API requests.
    Email Functionality: AWS Lambda triggered by API Gateway POST requests for form submissions.
    Infrastructure: Managed with AWS services including S3, API Gateway, Lambda, CloudFront, SSM, Route 53, and ACM for SSL certificates.
    Deployment: Infrastructure as Code (IaC) managed using Terraform.

🏗️ Architecture

    Frontend:
        Hosted on Amazon S3 for static content.
        Distributed via Amazon CloudFront for low latency and high transfer speeds.

    Backend:
        AWS Lambda functions handle server-side logic.
        API Gateway manages API endpoints and routes requests to Lambda functions.

    Form Submission:
        The contact form on the website triggers an AWS Lambda function through an API Gateway POST request.
        AWS SES is used for sending emails.

    Infrastructure Services:
        Amazon S3: Stores static frontend files.
        Amazon CloudFront: Distributes frontend content globally.
        AWS Lambda: Executes backend logic on demand.
        Amazon API Gateway: Manages and routes HTTP requests to Lambda functions.
        AWS Systems Manager (SSM): Manages parameters and secrets.
        Amazon Route 53: Handles DNS routing.
        AWS Certificate Manager (ACM): Provides SSL/TLS certificates for secure communications.
        Terraform: Used for defining and deploying the infrastructure.
