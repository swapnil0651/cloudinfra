# Cloud Infrastructure 

This project demonstrates a cloud infrastructure setup using AWS and Terraform, hosting a Next.js application with load balancing capabilities.

## Architecture Overview

The infrastructure consists of:
- 2 EC2 instances running the Next.js application
- Elastic Load Balancer (ELB) for traffic distribution
- Security groups for both EC2 instances and ELB
- CI/CD pipeline using GitHub Actions

## Prerequisites

- AWS Account
- AWS CLI configured
- Terraform (v1.5.0 or later)
- Node.js (v18 or later)
- Docker
- GitHub account (for CI/CD)

## Project Structure

```
swapnil0651-cloudinfra/
├── main.tf
├── provider.tf           # AWS provider and resource configurations
├── variables.tf         
├── frontend/            # Next.js application
└── .github/workflows/   # CI/CD configuration
```

## Infrastructure Details

### AWS Resources
- **Region**: ap-south-1
- **Instance Type**: t2.micro
- **AMI**: ami-00bb6a80f01f03502 (Ubuntu)
- **Load Balancer**: Classic ELB with cross-zone load balancing
- **Security Groups**: 
  - EC2: Ports 80, 22, 3000
  - ELB: Port 80

### Security Groups Configuration
- EC2 instances allow incoming traffic on ports:
  - 80 (HTTP)
  - 22 (SSH)
  - 3000 (Next.js development)
- ELB allows incoming traffic on port 80

## Next.js Application


## Deployment

### Manual Deployment

1. Initialize Terraform:
```bash
terraform init
```

2. Apply Terraform configuration:
```bash
terraform apply
```

3. Build and run the Next.js application:
```bash
cd frontend
npm install
npm run build
npm start
```

### Automated Deployment (CI/CD)

The project includes a GitHub Actions workflow that:
1. Checks out the repository
2. Sets up Terraform
3. Initializes and applies Terraform configuration
4. Requires AWS credentials as GitHub secrets:
   - AWS_ACCESS_KEY_ID
   - AWS_SECRET_ACCESS_KEY

## Environment Variables

Required environment variables for the frontend:
- NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY
- CLERK_SECRET_KEY

## Development

1. Clone the repository:
```bash
git clone <repository-url>
```

2. Install frontend dependencies:
```bash
cd frontend
npm install
```

3. Run development server:
```bash
npm run dev
```

4. Access the application at http://localhost:3000

## Docker Support

The frontend includes a Dockerfile for containerization:
```bash
cd frontend
docker build -t frontend .
docker run -p 3000:3000 frontend
```

## Security Notes

- Ensure to keep your AWS credentials secure
- Never commit .env files containing sensitive data
- Update security group rules according to your production needs
- Regularly update dependencies for security patches
